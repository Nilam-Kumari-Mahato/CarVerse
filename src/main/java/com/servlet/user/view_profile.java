package com.servlet.user;
import com.carverse.security.PasswordUtil;
import com.servlet.businesspartners.BusinessDAO;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/view_profile")
public class view_profile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public view_profile() {
        // default constructor
    }

    // Handle GET, since the profile link is a simple navigation <a> tag
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter pw1 = response.getWriter();

        load_user user = null;
        List<BookingDetail> bookingList = new ArrayList<>();

        try {
            HttpSession ses = request.getSession(false); // don't create a new session if none exists
            String u_id = (ses != null) ? (String) ses.getAttribute("USERID") : null;

            if (u_id == null) {
                // no logged-in user; send them to login instead of querying with a null id
                response.sendRedirect("login.html");
                return;
            }

            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1521:XE", "CARVERSE", "manager")) {

                String q1 = "SELECT * FROM USER_REGISTRATION WHERE USER_ID = ?";

                String q2 = "SELECT booking_id, user_id, car_id, pickup_location, drop_location, total_amount, " +
                           "booking_status, NVL(cancellation_status,'NONE') AS cancellation_status " +
                           "FROM BOOKING_DETAILS WHERE user_id = ? ORDER BY BOOKING_DATE DESC";

                // ---- Fetch user profile ----
                try (PreparedStatement pstmt = con.prepareStatement(q1)) {
                    pstmt.setString(1, u_id);

                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            user = new load_user();
                            user.setU_id(rs.getString(1));
                            user.setU_name(rs.getString(2));
                            user.setU_email(rs.getString(3));
                            user.setU_cont(rs.getString(5));
                            user.setU_add(rs.getString(6));
                            user.setU_createdat(rs.getString(7));
                        }
                    }
                }

                // ---- Fetch booked car details ----
                try (PreparedStatement pstmt2 = con.prepareStatement(q2)) {
                    pstmt2.setString(1, u_id);

                    try (ResultSet rs2 = pstmt2.executeQuery()) {
                        while (rs2.next()) {
                            BookingDetail bd = new BookingDetail();
                            bd.setBookingId(rs2.getString("booking_id"));
                            bd.setUserId(rs2.getString("user_id"));
                            bd.setCarId(rs2.getString("car_id"));
                            bd.setPickupLocation(rs2.getString("pickup_location"));
                            bd.setDropLocation(rs2.getString("drop_location"));
                            bd.setTotalAmount(rs2.getDouble("total_amount"));
                            bd.setBookingStatus(rs2.getString("booking_status"));
                            bd.setCancellationStatus(rs2.getString("cancellation_status"));
                            bookingList.add(bd);
                        }
                    }
                }
            }
        } catch (Exception e) {
            pw1.println(e);
            return; // don't forward if something failed, to avoid a half-broken page
        }

        request.setAttribute("user", user);
        request.setAttribute("bookings", bookingList);
        request.getRequestDispatcher("/user/profile_view.jsp").forward(request, response);
    }

    // POST — handle cancel booking request submitted from profile_view.jsp
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession ses = request.getSession(false);
        String u_id = (ses != null) ? (String) ses.getAttribute("USERID") : null;

        if (u_id == null) {
            response.sendRedirect("login.html");
            return;
        }

        String action    = request.getParameter("action");
        String bookingId = request.getParameter("bookingId");

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, ses, u_id);
            return;
        }
        if ("deleteAccount".equals(action)) {
            deleteAccount(request, response, ses, u_id);
            return;
        }

        if ("cancelBooking".equals(action) && bookingId != null && !bookingId.trim().isEmpty()) {
            try {
                BusinessDAO dao = new BusinessDAO();
                boolean ok = dao.requestCancellation(bookingId.trim(), u_id);
                if (ok) {
                    response.sendRedirect("view_profile?cancel=success&bid=" + bookingId.trim());
                } else {
                    // Booking already has an active/processed cancellation, or doesn't belong to user
                    response.sendRedirect("view_profile?cancel=already&bid=" + bookingId.trim());
                }
            } catch (Exception e) {
                response.sendRedirect("view_profile?cancel=error");
            }
        } else {
            doGet(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response,
                               HttpSession session, String userId) throws IOException {
        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String contact = trim(request.getParameter("contact"));
        String address = trim(request.getParameter("address"));
        if (name.isEmpty() || name.length() > 100 || email.length() > 200
                || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")
                || contact.isEmpty() || contact.length() > 40
                || address.isEmpty() || address.length() > 500) {
            response.sendRedirect("view_profile?profile=invalid");
            return;
        }

        String sql = "UPDATE USER_REGISTRATION SET USERNAME = ?, EMAIL = ?, CONTACT = ?, ADDRESS = ? "
                + "WHERE USER_ID = ?";
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE", "CARVERSE", "manager");
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, contact);
                ps.setString(4, address);
                ps.setString(5, userId);
                if (ps.executeUpdate() != 1) {
                    response.sendRedirect("view_profile?profile=error");
                    return;
                }
            }
            session.setAttribute("USERNAME", name);
            session.setAttribute("USER_NAME", name);
            session.setAttribute("EMAIL", email);
            response.sendRedirect("view_profile?profile=updated");
        } catch (SQLException e) {
            getServletContext().log("User profile update failed.", e);
            response.sendRedirect("view_profile?profile="
                    + (e.getErrorCode() == 1 ? "duplicate-email" : "error"));
        } catch (Exception e) {
            getServletContext().log("User profile update failed.", e);
            response.sendRedirect("view_profile?profile=error");
        }
    }

    private void deleteAccount(HttpServletRequest request, HttpServletResponse response,
                               HttpSession session, String userId) throws IOException {
        String anonymizedEmail = "deleted+" + UUID.randomUUID() + "@deleted.invalid";
        String unusablePassword = UUID.randomUUID().toString();
        String update = "UPDATE USER_REGISTRATION SET USERNAME = 'Deleted User', EMAIL = ?, "
                + "PASSWORD = ?, CONTACT = '0', ADDRESS = 'Removed' WHERE USER_ID = ?";
        try {
            String passwordHash = PasswordUtil.hashPassword(unusablePassword);
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE", "CARVERSE", "manager")) {
                con.setAutoCommit(false);
                try {
                    try (PreparedStatement ps = con.prepareStatement(update)) {
                        ps.setString(1, anonymizedEmail);
                        ps.setString(2, passwordHash);
                        ps.setString(3, userId);
                        if (ps.executeUpdate() != 1) {
                            con.rollback();
                            response.sendRedirect("view_profile?profile=delete-error");
                            return;
                        }
                    }
                    con.commit();
                } catch (Exception e) {
                    con.rollback();
                    throw e;
                }
            }
            session.invalidate();
            response.sendRedirect("login.html?accountDeleted=true");
        } catch (Exception e) {
            getServletContext().log("User account anonymization failed.", e);
            response.sendRedirect("view_profile?profile=delete-error");
        }
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
