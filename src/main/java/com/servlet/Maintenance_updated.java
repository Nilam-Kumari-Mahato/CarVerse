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

    // Database connection details (adjust to match your local setup)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/carverse_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // 1. Read input values from the JSP form
        String recordIdStr = request.getParameter("recordId");
        String status = request.getParameter("status");
        String notes = request.getParameter("technicianNotes");
        String newFeature = request.getParameter("newFeatures");
        String costStr = request.getParameter("cost");

        int recordId = 0;
        double cost = 0.0;

        try {
            if (recordIdStr != null && !recordIdStr.trim().isEmpty()) {
                recordId = Integer.parseInt(recordIdStr.trim());
            }
            if (costStr != null && !costStr.trim().isEmpty()) {
                cost = Double.parseDouble(costStr.trim());
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // 2. Database operations using try-with-resources for automatic closing
        String updateQuery = "UPDATE maintenance SET status = ?, technician_notes = ?, cost = ? WHERE id = ?";
        String featureQuery = "INSERT INTO car_features (maintenance_id, feature_name) VALUES (?, ?)";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                
                // Update maintenance record
                try (PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {
                    psUpdate.setString(1, status);
                    psUpdate.setString(2, notes);
                    psUpdate.setDouble(3, cost);
                    psUpdate.setInt(4, recordId);
                    psUpdate.executeUpdate();
                }

                // Add newly verified feature if provided
                if (newFeature != null && !newFeature.trim().isEmpty()) {
                    try (PreparedStatement psFeature = conn.prepareStatement(featureQuery)) {
                        psFeature.setInt(1, recordId);
                        psFeature.setString(2, newFeature.trim());
                        psFeature.executeUpdate();
                    }
                }
            }

            // 3. Success redirect
            response.sendRedirect("Admin?action=maintenanceDetails&recordId=" + recordId + "&success=true");

        } catch (Exception e) {
            e.printStackTrace();
            // Failure redirect
            response.sendRedirect("Admin?action=maintenanceDetails&recordId=" + recordId + "&error=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Prevent direct GET requests and return to dashboard/maintenance
        response.sendRedirect("Admin?action=maintenance");
    }
}