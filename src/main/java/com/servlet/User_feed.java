package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.*;
import java.sql.*;

/**
 * Servlet implementation class User_feed
 */
@WebServlet("/User_feed")
public class User_feed extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public User_feed() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
            response.setContentType("text/html");
            PrintWriter pw1 = response.getWriter();
            
            String cf_title = request.getParameter("title");
            String cf_content = request.getParameter("content");
            
            FeedbackIdGenerator ob = new FeedbackIdGenerator();
            String f_id = ob.generateFeedbackId();
            
            HttpSession session = request.getSession();
            String u_id = (String) session.getAttribute("USERID");
            
            try{
                Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE" , "CARVERSE" , "manager");
			Statement stmt = con.createStatement();
			
			String q1 =  "INSERT INTO CAR_FEED " +
		            "(FEED_ID, USER_ID, COMPANY_ID, CAR_ID, TITLE, CONTENT) " +
		            "VALUES ('" + f_id + "', '" + u_id + "', '" + "com_@def" + "', '" +
		            "car_@def" + "', '" + cf_title + "', '" + cf_content + "')";
			
			int x = stmt.executeUpdate(q1);
                        
                        if(x>0){
                            pw1.println("success");
                        }else{
                            pw1.println("unsuccess");
                        }
                        con.close();
            }catch(Exception e){
                pw1.println(e);
            }
	}

}
