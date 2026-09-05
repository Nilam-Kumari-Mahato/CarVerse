package com.servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.sql.*;
import java.time.LocalDate;

/**
 * Servlet implementation class Maintenance_User
 */
@WebServlet("/Maintenance_User")
public class Maintenance_User extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public Maintenance_User() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter pw1 = response.getWriter();

        // Get form data
        String c_model = request.getParameter("carModel");
        String m_type = request.getParameter("maintenanceType");
        String p_year = request.getParameter("purchaseYear");
        String lm_date = request.getParameter("lastMaintenance");
        String m_d = request.getParameter("description");

        

        // Generate Maintenance ID
        MaintenanceIdGenerator ob = new MaintenanceIdGenerator();
        String m_id = ob.generateMaintenanceId();

        

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Get logged-in user ID from session
            HttpSession ses = request.getSession();
            String u_id = (String) ses.getAttribute("USERID");
            
            // Load Oracle Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Create database connection
            con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1521:XE",
                    "CARVERSE",
                    "manager"
            );

            // Convert HTML date (YYYY-MM-DD) to Timestamp
            LocalDate localDate = LocalDate.parse(lm_date);
            Timestamp lastMaintenanceTimestamp =
                    Timestamp.valueOf(localDate.atStartOfDay());

            // SQL Query
            String sql = "INSERT INTO MAINTENANCE_DETAILS "
                    + "(MAINTENANCE_ID, USER_ID, "
                    + "CAR_PURCHASED_YEAR, LAST_MAINTENANCE_DATE, "
                    + "CARMODEL, MAINTENANCETYPE, DESCRIPTION) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            // Create PreparedStatement
            ps = con.prepareStatement(sql);

            // Set values
            ps.setString(1, m_id);
            ps.setString(2, u_id);
            ps.setInt(3, Integer.parseInt(p_year));
            ps.setTimestamp(4, lastMaintenanceTimestamp);
            ps.setString(5, c_model);
            ps.setString(6, m_type);
            ps.setString(7, m_d);

            // Execute INSERT
            int x = ps.executeUpdate();

            if (x > 0) {
                pw1.println("Maintenance request sent successfully");
            } else {
                pw1.println("Failed !!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            pw1.println("Error: " + e.getMessage());

        } finally {

            // Close PreparedStatement
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // Close Connection
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}