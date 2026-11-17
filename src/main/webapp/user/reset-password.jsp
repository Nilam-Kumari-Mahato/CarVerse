<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    String accountType = (String) request.getAttribute("accountType");
    String resetToken = (String) request.getAttribute("resetToken");
    String resetError = (String) request.getAttribute("resetError");
    if (!"BUSINESS".equals(accountType)) accountType = "USER";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Set new password | CarVerse</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/common.css">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/auth.css">
</head>
<body>
  <main class="auth-page">
    <section class="auth-card" aria-labelledby="new-password-title">
      <header class="auth-copy">
        <a class="brand" href="<%= request.getContextPath() %>/user/index.jsp">CARVERSE</a>
        <p class="eyebrow" style="margin-top:80px">Secure your account</p>
        <h1>Choose a <span>new password.</span></h1>
        <p>Use 8 to 128 characters. Business passwords also need a letter, number, and special character.</p>
      </header>
      <div class="auth-form">
        <h2 id="new-password-title">Reset password</h2>
        <% if (resetError != null) { %>
          <p class="alert-error" role="alert"><%= resetError %></p>
        <% } %>
        <form action="<%= request.getContextPath() %>/PasswordReset" method="post">
          <input type="hidden" name="action" value="reset">
          <input type="hidden" name="accountType" value="<%= accountType %>">
          <input type="hidden" name="token" value="<%= resetToken == null ? "" : resetToken %>">
          <label for="password">New password</label>
          <input class="input" id="password" name="password" type="password" minlength="8" maxlength="128" autocomplete="new-password" required>
          <label for="confirmPassword">Confirm new password</label>
          <input class="input" id="confirmPassword" name="confirmPassword" type="password" minlength="8" maxlength="128" autocomplete="new-password" required>
          <button class="btn btn-primary" type="submit">Save new password</button>
        </form>
        <p class="form-note">
          <a href="<%= request.getContextPath() %>/user/forgot-password.jsp?accountType=<%= accountType %>">Request another reset link</a>
        </p>
      </div>
    </section>
  </main>
</body>
</html>
