<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("\"", "&quot;")
                .replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;");
    }
%>
<%
    String accountType = (String) request.getAttribute("accountType");
    if (accountType == null) accountType = request.getParameter("accountType");
    if (!"BUSINESS".equals(accountType)) accountType = "USER";
    String resetError = (String) request.getAttribute("resetError");
    boolean resetSuccess = Boolean.TRUE.equals(request.getAttribute("resetSuccess"));
    String email = (String) request.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot password | CarVerse</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/common.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="reset-title">
      <header class="auth-copy">
        <a class="brand" href="<%= request.getContextPath() %>/user/index.jsp">CARVERSE</a>
        <p class="eyebrow" style="margin-top:80px">Account recovery</p>
        <h1>Get back <span>in the driver’s seat.</span></h1>
        <p>Enter your account email and choose a new password.</p>
      </header>
      <div class="auth-form">
        <h2 id="reset-title">Forgot password?</h2>
        <% if (resetSuccess) { %>
          <p class="alert-success" role="status">Password updated. You can sign in now.</p>
        <% } else if (resetError != null) { %>
          <p class="alert-error" role="alert"><%= escapeHtml(resetError) %></p>
        <% } %>
        <form action="<%= request.getContextPath() %>/PasswordReset" method="post">
          <input type="hidden" name="action" value="reset">
          <input type="hidden" name="accountType" value="<%= accountType %>">
          <label for="email"><%= "BUSINESS".equals(accountType) ? "Business login email" : "Account email" %></label>
          <input class="input" id="email" name="email" type="email" autocomplete="email" maxlength="200" value="<%= escapeHtml(email) %>" required>
          <label for="password">Enter new password</label>
          <input class="input" id="password" name="password" type="password" minlength="8" maxlength="128" autocomplete="new-password" required>
          <label for="confirmPassword">Confirm new password</label>
          <input class="input" id="confirmPassword" name="confirmPassword" type="password" minlength="8" maxlength="128" autocomplete="new-password" required>
          <button class="btn btn-primary" type="submit">Update password</button>
        </form>
        <p class="form-note">
          <a href="<%= request.getContextPath() %>/<%= "BUSINESS".equals(accountType) ? "business-partners/business-login.jsp" : "login.html" %>">Back to sign in</a>
        </p>
      </div>
    </section>
  </main>
</body>
</html>
