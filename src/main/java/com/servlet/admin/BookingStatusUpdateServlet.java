package com.servlet.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Locale;
import java.util.Set;
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
    private static final Set<String> BOOKING_STATUSES =
            Set.of("PENDING", "CONFIRMED", "COMPLETED", "CANCELLED");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String bookingId = request.getParameter("bookingId");
        String requestedStatus = request.getParameter("status");

        if (bookingId == null || bookingId.trim().isEmpty()
                || requestedStatus == null || requestedStatus.trim().isEmpty()) {
            response.sendRedirect("Admin?action=bookings");
            return;
        }
        String status = requestedStatus.trim().toUpperCase(Locale.ROOT);
        if (!BOOKING_STATUSES.contains(status)) {
            response.sendRedirect("Admin?action=bookings&error=true");
            return;
        }

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {

                // Change cancellation status only when a request is pending.
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE BOOKING_DETAILS " +
                        "SET BOOKING_STATUS = ?, " +
                        "    CANCELLATION_STATUS = CASE " +
                        "      WHEN UPPER(NVL(CANCELLATION_STATUS, 'NONE')) = 'REQUESTED' THEN " +
                        "        CASE ? WHEN 'PENDING' THEN 'REQUESTED' " +
                        "          WHEN 'CANCELLED' THEN 'APPROVED' ELSE 'REJECTED' END " +
                        "      ELSE CANCELLATION_STATUS END, " +
                        "    CANCELLATION_DATE = CASE " +
                        "      WHEN UPPER(NVL(CANCELLATION_STATUS, 'NONE')) = 'REQUESTED' " +
                        "        AND ? = 'PENDING' THEN NULL " +
                        "      WHEN UPPER(NVL(CANCELLATION_STATUS, 'NONE')) = 'REQUESTED' THEN SYSDATE " +
                        "      ELSE CANCELLATION_DATE END " +
                        "WHERE BOOKING_ID = ?")) {
                    ps.setString(1, status);
                    ps.setString(2, status);
                    ps.setString(3, status);
                    ps.setString(4, bookingId.trim());
                    if (ps.executeUpdate() != 1) {
                        response.sendRedirect("Admin?action=bookings&error=true");
                        return;
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
