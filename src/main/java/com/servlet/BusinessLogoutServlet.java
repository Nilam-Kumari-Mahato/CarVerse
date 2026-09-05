package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Invalidates the current business partner session and redirects to the
 * business login page.
 *
 * Accessible via both GET (from a nav link) and POST (from a logout button
 * inside a form, which is the CSRF-safer option).
 */
@WebServlet("/BusinessLogout")
public class BusinessLogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logout(request, response);
    }

    // -----------------------------------------------------------------------

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // clear all session attributes and invalidate token
        }

        // Redirect to business login with a logout indicator so the JSP can
        // show a "You have been signed out" confirmation message.
        response.sendRedirect("business-login.jsp?logout=true");
    }
}
