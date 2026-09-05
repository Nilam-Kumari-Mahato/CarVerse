package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles POST login from business-login.jsp.
 *
 * Flow:
 *   1. Read email + password from request.
 *   2. Basic presence check.
 *   3. Delegate credential verification to BusinessDAO.login().
 *   4. On success: create session with BUSINESS_ID, BUSINESS_NAME, and role
 *      marker, then redirect to business-dashboard.jsp.
 *   5. On failure: forward back to login page with a generic error message.
 *      The error message never reveals whether the email exists.
 */
@WebServlet("/BusinessLogin")
public class BusinessLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Session attribute names used by this module
    public static final String SESS_BUSINESS_ID   = "BUSINESS_ID";
    public static final String SESS_BUSINESS_NAME = "BUSINESS_NAME";
    public static final String SESS_BRAND_NAME    = "BRAND_NAME";
    public static final String SESS_ROLE          = "USER_ROLE";

    // Value stored in SESS_ROLE for business partner accounts
    public static final String ROLE_BUSINESS      = "BUSINESS_PARTNER";

    // Generic credential-failure message — never reveal which field is wrong
    private static final String GENERIC_ERROR = "Invalid email or password.";

    // -----------------------------------------------------------------------
    // POST handler
    // -----------------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String loginEmail = trim(request.getParameter("loginEmail"));
        String password   = request.getParameter("password"); // do not trim

        // Basic presence check
        if (blank(loginEmail) || blank(password)) {
            fail(request, response, GENERIC_ERROR, loginEmail);
            return;
        }

        try {
            BusinessDAO dao = new BusinessDAO();
            Business b = dao.login(loginEmail, password);

            if (b == null) {
                // Wrong email or wrong password
                fail(request, response, GENERIC_ERROR, loginEmail);
                return;
            }

            // ---------------------------------------------------------------
            // Successful authentication — create session
            // ---------------------------------------------------------------

            // Invalidate any existing session (prevents session fixation)
            HttpSession existing = request.getSession(false);
            if (existing != null) {
                existing.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute(SESS_BUSINESS_ID,   b.getBusinessId());
            session.setAttribute(SESS_BUSINESS_NAME, b.getBusinessName());
            session.setAttribute(SESS_BRAND_NAME,    b.getBrandName());
            session.setAttribute(SESS_ROLE,          ROLE_BUSINESS);
            // Note: password / password hash is intentionally NOT stored in session

            response.sendRedirect("business-dashboard.jsp");

        } catch (BusinessDAO.AccountNotActiveException e) {
            // Account exists and password is correct but account is not ACTIVE.
            // Show a specific but safe message that doesn't expose the email.
            String msg;
            switch (e.getStatus()) {
                case "PENDING":
                    msg = "Your account is pending review. Please check back later.";
                    break;
                case "SUSPENDED":
                    msg = "Your account has been suspended. Please contact support.";
                    break;
                case "REJECTED":
                    msg = "Your registration was not approved. Please contact support.";
                    break;
                default:
                    msg = "Your account is currently inactive. Please contact support.";
            }
            fail(request, response, msg, loginEmail);

        } catch (Exception e) {
            fail(request, response, "A server error occurred. Please try again.", loginEmail);
        }
    }

    // -----------------------------------------------------------------------
    // Utility helpers
    // -----------------------------------------------------------------------

    /** Forwards back to the login JSP with an error attribute. */
    private void fail(HttpServletRequest request, HttpServletResponse response,
                      String errorMsg, String loginEmail)
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        // Repopulate email field so the user does not have to retype it
        if (loginEmail != null && !loginEmail.isEmpty()) {
            request.setAttribute("f_loginEmail", loginEmail);
        }
        request.getRequestDispatcher("business-login.jsp").forward(request, response);
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean blank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
