package com.servlet;

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

                String q2 = "SELECT booking_id, user_id, car_id, pickup_location, drop_location, total_amount FROM BOOKING_DETAILS "
                           + "WHERE user_id = ?";

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
        request.getRequestDispatcher("profile_view.jsp").forward(request, response);
    }

    // Optional: if you ever call this via a POST form elsewhere, delegate to doGet
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}