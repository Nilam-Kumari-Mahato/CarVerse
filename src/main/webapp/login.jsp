<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    // Authentication is handled by UserLogin servlet (/UserLogin)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.getRequestDispatcher("/UserLogin").forward(request, response);
    } else {
        response.sendRedirect("login.html");
    }
%>
