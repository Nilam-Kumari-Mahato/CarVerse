package com.servlet.user;

import com.carverse.security.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


@WebServlet("/User_registration")
public class User_registration extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public User_registration() {
        super();
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		String user_name = request.getParameter("n1");
		String email = request.getParameter("n2");
		String password = request.getParameter("n3");
		String contact = request.getParameter("n4");
		String address = request.getParameter("n5");
		if (password == null || password.trim().isEmpty() || password.length() < 8 || password.length() > 128) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Password must contain 8 to 128 characters.");
			return;
		}

		int num = (int)(Math.random() * 16) + 5;
		
		UserIdGenerator user = new UserIdGenerator();
		String u_id = user.generateUserId(num);
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String hashedPassword = PasswordUtil.hashPassword(password);
			String sql = "INSERT INTO USER_REGISTRATION " +
			        "(USER_ID, USERNAME, EMAIL, PASSWORD, CONTACT, ADDRESS) VALUES (?, ?, ?, ?, ?, ?)";
			try (Connection con = DriverManager.getConnection(
					"jdbc:oracle:thin:@localhost:1521:XE", "CARVERSE", "manager");
			     PreparedStatement stmt = con.prepareStatement(sql)) {
				stmt.setString(1, u_id);
				stmt.setString(2, user_name);
				stmt.setString(3, email);
				stmt.setString(4, hashedPassword);
				stmt.setString(5, contact);
				stmt.setString(6, address);
				if (stmt.executeUpdate() > 0) {
                
                HttpSession session = request.getSession(); // creates a new session
                session.setAttribute("USER_ID", u_id);
                session.setAttribute("USER_NAME", user_name);
				session.setAttribute("USERID", u_id);
                session.setAttribute("USERNAME", user_name);


                response.sendRedirect(getServletContext().getContextPath() + "/user/index.jsp");
                return;
				}
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
						"Registration failed. Please try again.");
			}
		} catch(Exception e) {
			getServletContext().log("User registration failed.", e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Registration failed. Please try again.");
		}
		
	}

}
