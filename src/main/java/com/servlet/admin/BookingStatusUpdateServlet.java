package com.servlet.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BookingStatusUpdate")
public class BookingStatusUpdateServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL      = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER     = "CARVERSE";
    private static final String DB_PASSWORD = "manager";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String bookingId = request.getParameter("bookingId");
        String status    = request.getParameter("status");

        if (bookingId == null || bookingId.trim().isEmpty()
                || status == null || status.trim().isEmpty()) {
            response.sendRedirect("Admin?action=bookings");
            return;
        }

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                // Update booking status
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE BOOKING_DETAILS SET BOOKING_STATUS = ? WHERE BOOKING_ID = ?")) {
                    ps.setString(1, status.trim());
                    ps.setString(2, bookingId.trim());
                    ps.executeUpdate();
                }

                // If admin manually sets status to CANCELLED and a cancellation was
                // REQUESTED by the user, automatically promote it to APPROVED.
                if ("CANCELLED".equalsIgnoreCase(status.trim())) {
                    try (PreparedStatement ps2 = conn.prepareStatement(
                            "UPDATE BOOKING_DETAILS" +
                            "   SET CANCELLATION_STATUS = 'APPROVED'," +
                            "       CANCELLATION_DATE   = SYSDATE" +
                            " WHERE BOOKING_ID = ? AND CANCELLATION_STATUS = 'REQUESTED'")) {
                        ps2.setString(1, bookingId.trim());
                        ps2.executeUpdate();
                    }
                }
            }

            response.sendRedirect("Admin?action=bookings&updated=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Admin?action=bookings&error=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Admin?action=bookings");
    }
}
