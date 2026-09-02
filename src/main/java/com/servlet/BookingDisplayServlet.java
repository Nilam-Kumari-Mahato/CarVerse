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
/**
 * Servlet implementation class BookingDisplayServlet
 */
@WebServlet("/BookingDisplayServlet")
public class BookingDisplayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingDisplayServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
                PrintWriter pw1 = response.getWriter();
                
                car c = null;
                
                try{
                    HttpSession ses = request.getSession();
                    String carid = (String)ses.getAttribute("CARID");
                    
                    
                    // Load Oracle Driver
                    Class.forName("oracle.jdbc.driver.OracleDriver");

                    Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE" , "CARVERSE" , "manager");
                    Statement stmt = con.createStatement(); 
                    
                    String q1 = "Select * from CAR_DETAILS where car_id == '"+carid+"'";
                    
                    ResultSet rs= stmt.executeQuery(q1);
                    
                    if(rs.next()){
                        c = new car();
                        c.setCarid(rs.getString(1));
                        c.setModel_name(rs.getString(2));
                        c.setBrand(rs.getString(3));
                        c.setBody_type(rs.getString(4));
                        c.setPrice_range(rs.getString(5));
                        c.setHeight(rs.getString(17));
                        c.setLength(rs.getString(15));
                        c.setWidth(rs.getString(16));
                        
                        
                    }
                } catch (Exception e) {
                    pw1.println(e);
                    // optionally forward to an error page
                }

                request.setAttribute("car", c);
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                         
	}

}
