package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/User_feed")
public class User_feed extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public User_feed() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        PrintWriter pw1 = response.getWriter();

        String cf_title = request.getParameter("title");
        String cf_content = request.getParameter("content");

        HttpSession session = request.getSession(false);
        String u_id = (session != null) ? (String) session.getAttribute("USERID") : null;

        // basic validation before touching the database
        if (u_id == null) {
            pw1.println("unsuccess");
            return;
        }

        if (cf_title == null || cf_title.trim().isEmpty()
                || cf_content == null || cf_content.trim().isEmpty()) {
            pw1.println("unsuccess");
            return;
        }

        try {
            FeedbackIdGenerator ob = new FeedbackIdGenerator();
            String f_id = ob.generateFeedbackId();

            Class.forName("oracle.jdbc.driver.OracleDriver");

            try (Connection con = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1521:XE", "CARVERSE", "manager")) {

                String q1 = "INSERT INTO PLATFORM_FEED (FEED_ID, USER_ID, TITLE, CONTENT) "
                           + "VALUES (?, ?, ?, ?)";

                try (PreparedStatement pstmt = con.prepareStatement(q1)) {
                    pstmt.setString(1, f_id);
                    pstmt.setString(2, u_id);
                    pstmt.setString(3, cf_title);
                    pstmt.setString(4, cf_content);

                    int x = pstmt.executeUpdate();

                    if (x > 0) {
                        pw1.println("success");
                    } else {
                        pw1.println("unsuccess");
                    }
                }
            }
        } catch (Exception e) {
            pw1.println("unsuccess");
            e.printStackTrace(); // goes to server log, not the client response
        }
    }
}