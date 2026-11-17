package com.carverse.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/PasswordReset")
public class PasswordResetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String FORGOT_PAGE = "/user/forgot-password.jsp";
    private static final Pattern BUSINESS_PASSWORD =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,128}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Referrer-Policy", "no-referrer");
        PasswordResetDAO.AccountType type = PasswordResetDAO.AccountType.parse(
                request.getParameter("accountType"));
        response.sendRedirect(request.getContextPath() + FORGOT_PAGE + "?accountType="
                + (type == null ? "USER" : type.name()));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Referrer-Policy", "no-referrer");
        request.setCharacterEncoding("UTF-8");
        PasswordResetDAO.AccountType type = PasswordResetDAO.AccountType.parse(
                request.getParameter("accountType"));
        if (type == null) {
            redirectForgot(request, response, PasswordResetDAO.AccountType.USER, "invalid");
            return;
        }

        if (!"reset".equals(request.getParameter("action"))) {
            redirectForgot(request, response, type, "invalid");
            return;
        }
        resetPassword(request, response, type);
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response,
                               PasswordResetDAO.AccountType type)
            throws ServletException, IOException {
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");
        String error = null;
        if (email.isEmpty() || email.length() > 200 || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"))
            error = "Enter a valid email address.";
        else if (password == null || password.length() < 8 || password.length() > 128)
            error = "Password must contain 8 to 128 characters.";
        else if (type == PasswordResetDAO.AccountType.BUSINESS
                && !BUSINESS_PASSWORD.matcher(password).matches())
            error = "Business password needs a letter, number, and special character.";
        else if (!password.equals(confirm)) error = "Passwords do not match.";

        if (error != null) {
            request.setAttribute("accountType", type.name());
            request.setAttribute("resetError", error);
            request.setAttribute("email", email);
            request.getRequestDispatcher(FORGOT_PAGE).forward(request, response);
            return;
        }

        try {
            boolean changed = new PasswordResetDAO().resetPasswordByEmail(
                    type, email, PasswordUtil.hashPassword(password));
            if (!changed) {
                request.setAttribute("accountType", type.name());
                request.setAttribute("email", email);
                request.setAttribute("resetError", "No matching account found.");
                request.getRequestDispatcher(FORGOT_PAGE).forward(request, response);
                return;
            }
            request.setAttribute("accountType", type.name());
            request.setAttribute("email", email);
            request.setAttribute("resetSuccess", Boolean.TRUE);
            request.getRequestDispatcher(FORGOT_PAGE).forward(request, response);
        } catch (Exception e) {
            getServletContext().log("Password reset failed.", e);
            request.setAttribute("accountType", type.name());
            request.setAttribute("email", email);
            request.setAttribute("resetError", "Password reset failed. Please try again.");
            request.getRequestDispatcher(FORGOT_PAGE).forward(request, response);
        }
    }

    private void redirectForgot(HttpServletRequest request, HttpServletResponse response,
                                PasswordResetDAO.AccountType type, String flag) throws IOException {
        if (type == null) type = PasswordResetDAO.AccountType.USER;
        response.sendRedirect(request.getContextPath() + FORGOT_PAGE + "?accountType="
                + type.name() + "&" + flag + "=true");
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
