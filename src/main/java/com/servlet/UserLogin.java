package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Handles customer authentication and session management.
 * Mapped to /UserLogin and /UserLogout.
 */
@WebServlet(name = "UserLogin", urlPatterns = {"/UserLogin", "/UserLogout"})
public class UserLogin extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Session attribute constants
    public static final String SESS_USER_ID   = "USERID";
    public static final String SESS_USER_NAME = "USERNAME";
    public static final String SESS_UID_ALT   = "USER_ID";
    public static final String SESS_UNAME_ALT = "USER_NAME";
    public static final String SESS_EMAIL     = "EMAIL";
    public static final String SESS_ROLE      = "USER_ROLE";
    public static final String ROLE_CUSTOMER  = "CUSTOMER";

    // Database connection constants
    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String DEFAULT_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DEFAULT_USER = "CARVERSE";
    private static final String DEFAULT_PASSWORD_MANAGER = "manager";
    private static final String DEFAULT_PASSWORD_ORACLE26 = "oracle26";

    public UserLogin() {
        super();
    }

    /**
     * Handles GET requests:
     * - If called as /UserLogout or ?action=logout, invalidates the session and logs the user out.
     * - If user is already authenticated, redirects to index.jsp.
     * - Otherwise redirects to login.html.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String uri = request.getRequestURI();

        // Logout handling
        if ("logout".equalsIgnoreCase(action) || (uri != null && uri.endsWith("/UserLogout"))) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute(SESS_USER_ID);
                session.removeAttribute(SESS_USER_NAME);
                session.removeAttribute(SESS_UID_ALT);
                session.removeAttribute(SESS_UNAME_ALT);
                session.removeAttribute(SESS_EMAIL);
                session.removeAttribute(SESS_ROLE);
                session.invalidate();
            }
            response.sendRedirect("login.html?logout=true");
            return;
        }

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(SESS_USER_ID) != null) {
            response.sendRedirect("index.jsp");
            return;
        }

        response.sendRedirect("login.html");
    }

    /**
     * Handles POST login requests from login.html.
     * Authenticates user against USER_REGISTRATION table and establishes an HttpSession.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate presence of credentials
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect("login.html?error=invalid");
            return;
        }

        email = email.trim();

        String sql = "SELECT USER_ID, USERNAME, EMAIL FROM USER_REGISTRATION WHERE LOWER(TRIM(EMAIL)) = LOWER(?) AND PASSWORD = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String userId = rs.getString("USER_ID");
                    String userName = rs.getString("USERNAME");
                    String userEmail = rs.getString("EMAIL");

                    // Session Fixation Defense: Invalidate existing session if present
                    HttpSession oldSession = request.getSession(false);
                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    // Create new session via HttpSession
                    HttpSession session = request.getSession(true);

                    // Set standard session attributes used across CarVerse
                    session.setAttribute(SESS_USER_ID, userId);
                    session.setAttribute(SESS_USER_NAME, userName);

                    // Set alternate attributes for full compatibility
                    session.setAttribute(SESS_UID_ALT, userId);
                    session.setAttribute(SESS_UNAME_ALT, userName);
                    session.setAttribute(SESS_EMAIL, userEmail);
                    session.setAttribute(SESS_ROLE, ROLE_CUSTOMER);

                    // 30 minutes inactivity timeout
                    session.setMaxInactiveInterval(30 * 60);

                    // Redirect to home page
                    response.sendRedirect("index.jsp");
                    return;
                } else {
                    // Invalid credentials
                    response.sendRedirect("login.html?error=invalid");
                    return;
                }
            }

        } catch (SQLException e) {
            getServletContext().log("Database error during user authentication", e);
            response.sendRedirect("login.html?error=server");
        } catch (Exception e) {
            getServletContext().log("Unexpected error during user authentication", e);
            response.sendRedirect("login.html?error=server");
        }
    }

    /**
     * Helper to obtain DB connection with fallback support for local environments.
     */
    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(DRIVER);

        String envUrl = System.getenv("DB_URL");
        String url = (envUrl != null && !envUrl.trim().isEmpty()) ? envUrl : DEFAULT_URL;

        String envUser = System.getenv("DB_USER");
        String user = (envUser != null && !envUser.trim().isEmpty()) ? envUser : DEFAULT_USER;

        String envPass = System.getenv("DB_PASSWORD");
        if (envPass != null && !envPass.trim().isEmpty()) {
            return DriverManager.getConnection(url, user, envPass);
        }

        try {
            return DriverManager.getConnection(url, user, DEFAULT_PASSWORD_MANAGER);
        } catch (SQLException e) {
            // Fallback to "oracle26" if "manager" password does not match
            return DriverManager.getConnection(url, user, DEFAULT_PASSWORD_ORACLE26);
        }
    }
}

