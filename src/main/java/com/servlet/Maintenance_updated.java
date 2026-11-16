package com.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/MaintenanceUpdate")
public class Maintenance_updated extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_URL      = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER     = "CARVERSE";
    private static final String DB_PASSWORD = "manager";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String maintenanceId = request.getParameter("maintenanceId");
        String status        = request.getParameter("status");

        if (maintenanceId == null || maintenanceId.trim().isEmpty()
                || status == null || status.trim().isEmpty()) {
            response.sendRedirect("Admin?action=maintenance");
            return;
        }

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(
                         "UPDATE MAINTENANCE_DETAILS SET MAINTENANCE_STATUS = ? WHERE MAINTENANCE_ID = ?")) {

                ps.setString(1, status.trim());
                ps.setString(2, maintenanceId.trim());
                ps.executeUpdate();
            }

            response.sendRedirect("Admin?action=maintenance&updated=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Admin?action=maintenance&error=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("Admin?action=maintenance");
    }
}
