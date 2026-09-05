<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Business Partner Sign In | CarVerse</title>
  <link rel="stylesheet" href="assets/css/carverse.css">
  <style>
    .sr-only {
      position: absolute; width: 1px; height: 1px;
      padding: 0; margin: -1px; overflow: hidden;
      clip: rect(0,0,0,0); white-space: nowrap; border: 0;
    }
    .alert-error {
      background: #fff0f0;
      border-left: 4px solid #e74c3c;
      color: #7b1e1e;
      border-radius: 7px;
      padding: 11px 14px;
      font-size: 13px;
      margin-bottom: 18px;
    }
    .alert-success {
      background: var(--mint);
      border-left: 4px solid var(--green);
      color: #2d5016;
      border-radius: 7px;
      padding: 11px 14px;
      font-size: 13px;
      margin-bottom: 18px;
    }
    /* Role badge in auth-copy */
    .role-badge {
      display: inline-block;
      background: rgba(169,232,44,.18);
      border: 1px solid rgba(169,232,44,.45);
      color: var(--green);
      font-size: 11px;
      font-weight: 900;
      letter-spacing: 1.2px;
      text-transform: uppercase;
      border-radius: 99px;
      padding: 4px 12px;
      margin-bottom: 22px;
    }
    .divider {
      border: none;
      border-top: 1px solid var(--line);
      margin: 20px 0;
    }
  </style>
</head>
<body>

<%
  // If the user is already logged in as a business partner, redirect to dashboard
  String bpId = (String) session.getAttribute("BUSINESS_ID");
  if (bpId != null) {
    response.sendRedirect("business-dashboard.jsp");
    return;
  }

  // Query-string flags set by other servlets
  String registered = request.getParameter("registered");
  String loggedOut  = request.getParameter("logout");

  // Error / repopulated fields set by BusinessLoginServlet on forward
  String error      = (String) request.getAttribute("error");
  String fEmail     = (String) request.getAttribute("f_loginEmail");
  if (fEmail == null) fEmail = "";
  // HTML-escape the repopulated email value
  fEmail = fEmail.replace("&","&amp;").replace("<","&lt;")
                 .replace(">","&gt;").replace("\"","&quot;");
%>

<main class="auth-page">
  <section class="auth-card" aria-labelledby="bp-signin-title">

    <!-- ── Left panel — copy ──────────────────────────────────────────── -->
    <header class="auth-copy">
      <a class="brand" href="index.jsp" aria-label="CarVerse home">CARVERSE</a>
      <div class="role-badge">Business Partner</div>
      <p class="eyebrow">Partner portal</p>
      <h1>Your business,<br><span>in the fast lane.</span></h1>
      <p>Manage your car listings, track bookings, and grow your reach through
         the CarVerse platform.</p>
    </header>

    <!-- ── Right panel — form ────────────────────────────────────────── -->
    <form class="auth-form" action="BusinessLogin" method="post"
          aria-labelledby="bp-signin-title" novalidate>

      <h2 id="bp-signin-title">Business Sign In</h2>
      <p class="sub">Enter your business account credentials to continue.</p>

      <%-- Success / info banners --%>
      <% if ("true".equals(registered)) { %>
        <div class="alert-success" role="status">
          ✓ &nbsp;Registration successful! Your account is active. Please sign in.
        </div>
      <% } else if ("true".equals(loggedOut)) { %>
        <div class="alert-success" role="status">
          You have been signed out successfully.
        </div>
      <% } %>

      <%-- Error banner --%>
      <% if (error != null && !error.isEmpty()) { %>
        <div class="alert-error" role="alert"><%= error %></div>
      <% } %>

      <div>
        <label class="sr-only" for="loginEmail">Business login email</label>
        <input class="input" id="loginEmail" name="loginEmail" type="email"
               placeholder="Business login email"
               value="<%= fEmail %>"
               autocomplete="username" required>
      </div>

      <div>
        <label class="sr-only" for="password">Password</label>
        <input class="input" id="password" name="password" type="password"
               placeholder="Password"
               autocomplete="current-password" required>
      </div>

      <p class="form-note" style="text-align:right; margin-top:10px;">
        <a href="#" aria-label="Forgot password — coming soon" title="Coming soon">
          Forgot password?
        </a>
      </p>

      <button class="btn btn-primary" type="submit">
        Sign in &nbsp;→
      </button>

      <hr class="divider">

      <p class="form-note">
        New business partner?
        <a href="business-register.jsp">Register your business</a>
      </p>
      <p class="form-note" style="margin-top:8px;">
        <a href="index.jsp">← Back to CarVerse home</a>
      </p>

    </form>

  </section>
</main>

</body>
</html>
