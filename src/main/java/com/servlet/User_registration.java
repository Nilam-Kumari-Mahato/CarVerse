package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.*;
import java.sql.*;


@WebServlet("/User_registration")
public class User_registration extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public User_registration() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		response.setContentType("text/html");
		PrintWriter pw1 = response.getWriter();
		String user_name = request.getParameter("n1");
		String email = request.getParameter("n2");
		String password = request.getParameter("n3");
		String contact = request.getParameter("n4");
		String address = request.getParameter("n5");
		
		int num = (int)(Math.random() * 16) + 5;
		
		UserIdGenerator user = new UserIdGenerator();
		String u_id = user.generateUserId(num);
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE" , "CARVERSE" , "manager");
			Statement stmt = con.createStatement();
			
			String q1 =  "INSERT INTO USER_REGISTRATION " +
		            "(USER_ID, USERNAME, EMAIL, PASSWORD, CONTACT, ADDRESS) " +
		            "VALUES ('" + u_id + "', '" + user_name + "', '" + email + "', '" +
		            password + "', '" + contact + "', '" + address + "')";
			
			int x = stmt.executeUpdate(q1);
			
			if (x > 0) {
                // *** This is the key part for your question ***
                HttpSession session = request.getSession(); // creates a new session
                session.setAttribute("USER_ID", u_id);
                session.setAttribute("USER_NAME", user_name);

                response.sendRedirect("index.jsp");
                // or forward to a "registration successful" page that shows u_id, your choice
                return;
            } else {
                pw1.println("<html><body><h1>Registration not Successful</h1></body></html>");
            }

			
		}catch(Exception e) {
			pw1.println("<html><body>"+e+"</body></html>");
		}
		
	}

}
