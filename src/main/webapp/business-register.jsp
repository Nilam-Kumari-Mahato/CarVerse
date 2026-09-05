<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Business Partner Registration | CarVerse</title>
  <link rel="stylesheet" href="assets/css/carverse.css">
  <style>
    /* ── Page shell ─────────────────────────────────────────────────────── */
    .bp-page {
      min-height: 100vh;
      background: linear-gradient(115deg, rgba(10,26,19,.76), rgba(18,46,33,.55)),
                  url('https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=1800&q=85')
                  center / cover;
      display: grid;
      place-items: center;
      padding: 40px 24px;
    }

    /* ── Registration card ───────────────────────────────────────────────── */
    .bp-card {
      width: min(860px, 100%);
      background: rgba(255,255,255,.96);
      border-radius: 21px;
      overflow: hidden;
      box-shadow: 0 25px 80px rgba(0,0,0,.28);
    }

    /* ── Card header ─────────────────────────────────────────────────────── */
    .bp-header {
      background: var(--deep);
      color: #fff;
      padding: 36px 48px 30px;
    }
    .bp-header .brand { font-size: 23px; font-weight: 900; letter-spacing: -1px; color: #fff; }
    .bp-header .eyebrow { margin-top: 18px; }
    .bp-header h1 { font-size: 30px; margin: 8px 0 6px; line-height: 1.15; }
    .bp-header h1 span { color: var(--green); }
    .bp-header p { color: #aec5b5; font-size: 14px; margin: 0; }

    /* ── Form body ───────────────────────────────────────────────────────── */
    .bp-body { padding: 40px 48px 48px; }

    /* ── Section divider ─────────────────────────────────────────────────── */
    .form-section {
      border-top: 2px solid var(--line);
      margin-top: 32px;
      padding-top: 24px;
    }
    .form-section:first-child { border-top: none; margin-top: 0; padding-top: 0; }
    .form-section-title {
      font-size: 11px;
      font-weight: 900;
      letter-spacing: 1.4px;
      text-transform: uppercase;
      color: #65a914;
      margin-bottom: 18px;
    }
    .form-section-title span {
      display: inline-block;
      background: var(--mint);
      border-radius: 4px;
      padding: 3px 9px;
    }

    /* ── Field groups ────────────────────────────────────────────────────── */
    .field-group { margin-top: 14px; }
    .field-group label {
      display: block;
      font-size: 12px;
      font-weight: 700;
      color: var(--muted);
      margin-bottom: 4px;
    }
    .field-group label .req { color: #c0392b; margin-left: 2px; }
    .field-group .input { margin-top: 0; }

    /* ── Alert banner ────────────────────────────────────────────────────── */
    .alert-error {
      background: #fff0f0;
      border-left: 4px solid #e74c3c;
      color: #7b1e1e;
      border-radius: 7px;
      padding: 13px 16px;
      font-size: 14px;
      margin-bottom: 24px;
    }
    .alert-info {
      background: var(--mint);
      border-left: 4px solid var(--green);
      color: #2d5016;
      border-radius: 7px;
      padding: 13px 16px;
      font-size: 14px;
      margin-bottom: 24px;
    }

    /* ── Submit row ──────────────────────────────────────────────────────── */
    .submit-row {
      margin-top: 32px;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
    }
    .submit-row .btn { width: 100%; font-size: 15px; padding: 15px; }
    .submit-row .form-note { margin: 0; }

    /* ── Password strength hint ──────────────────────────────────────────── */
    .hint {
      font-size: 11px;
      color: var(--muted);
      margin-top: 5px;
      line-height: 1.5;
    }

    @media (max-width: 640px) {
      .bp-header, .bp-body { padding-left: 24px; padding-right: 24px; }
      .form-row { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<main class="bp-page" aria-labelledby="reg-title">

  <div class="bp-card">

    <!-- ── Card Header ───────────────────────────────────────────────────── -->
    <header class="bp-header">
      <a class="brand" href="index.jsp" aria-label="CarVerse home">CARVERSE</a>
      <p class="eyebrow">Join as a Business Partner</p>
      <h1>List your cars,<br><span>grow your reach.</span></h1>
      <p>Register your business to manage car listings, track bookings,<br>
         and connect with thousands of buyers on CarVerse.</p>
    </header>

    <!-- ── Form Body ─────────────────────────────────────────────────────── -->
    <div class="bp-body">

      <%-- Error / info banners --%>
      <% String error = (String) request.getAttribute("error");
         if (error != null && !error.isEmpty()) { %>
        <div class="alert-error" role="alert"><strong>Please fix the following:</strong> <%= error %></div>
      <% } %>

      <%-- Helper: safely print a repopulated field value --%>
      <%!
        private String val(jakarta.servlet.http.HttpServletRequest r, String key) {
          Object v = r.getAttribute(key);
          if (v == null) return "";
          // basic HTML-escape to avoid XSS in repopulated values
          return v.toString()
                  .replace("&","&amp;").replace("<","&lt;")
                  .replace(">","&gt;").replace("\"","&quot;");
        }
      %>

      <form action="BusinessRegistration" method="post" novalidate
            aria-label="Business Partner Registration Form">

        <!-- ═══════════════════════════════════════════════════════════════ -->
        <!-- SECTION A — Business Information                                -->
        <!-- ═══════════════════════════════════════════════════════════════ -->
        <div class="form-section">
          <p class="form-section-title"><span>A &nbsp;·&nbsp; Business Information</span></p>

          <div class="form-row">
            <div class="field-group">
              <label for="businessName">Business / Company Name <span class="req">*</span></label>
              <input class="input" id="businessName" name="businessName" type="text"
                     placeholder="e.g. Tata Motors Ltd."
                     value="<%= val(request, "f_businessName") %>" required>
            </div>
            <div class="field-group">
              <label for="brandName">Brand Name <span class="req">*</span></label>
              <input class="input" id="brandName" name="brandName" type="text"
                     placeholder="e.g. Tata"
                     value="<%= val(request, "f_brandName") %>" required>
            </div>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="registrationNo">Business Registration No. / CIN</label>
              <input class="input" id="registrationNo" name="registrationNo" type="text"
                     placeholder="CIN or registration number (optional)"
                     value="<%= val(request, "f_registrationNo") %>">
            </div>
            <div class="field-group">
              <label for="gstin">GSTIN</label>
              <input class="input" id="gstin" name="gstin" type="text"
                     placeholder="15-digit GST number (optional)"
                     value="<%= val(request, "f_gstin") %>">
            </div>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="pan">PAN</label>
              <input class="input" id="pan" name="pan" type="text"
                     placeholder="10-character PAN (optional)"
                     value="<%= val(request, "f_pan") %>">
            </div>
            <div class="field-group">
              <label for="website">Company Website</label>
              <input class="input" id="website" name="website" type="url"
                     placeholder="https://yourcompany.com (optional)"
                     value="<%= val(request, "f_website") %>">
            </div>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="businessEmail">Official Business Email <span class="req">*</span></label>
              <input class="input" id="businessEmail" name="businessEmail" type="email"
                     placeholder="contact@yourcompany.com"
                     value="<%= val(request, "f_businessEmail") %>" required>
            </div>
            <div class="field-group">
              <label for="businessPhone">Business Contact Number <span class="req">*</span></label>
              <input class="input" id="businessPhone" name="businessPhone" type="tel"
                     placeholder="10-digit mobile number"
                     value="<%= val(request, "f_businessPhone") %>" required>
            </div>
          </div>

          <div class="field-group">
            <label for="address">Address <span class="req">*</span></label>
            <input class="input" id="address" name="address" type="text"
                   placeholder="Street address, building, area"
                   value="<%= val(request, "f_address") %>" required>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="city">City <span class="req">*</span></label>
              <input class="input" id="city" name="city" type="text"
                     placeholder="City"
                     value="<%= val(request, "f_city") %>" required>
            </div>
            <div class="field-group">
              <label for="state">State <span class="req">*</span></label>
              <input class="input" id="state" name="state" type="text"
                     placeholder="State"
                     value="<%= val(request, "f_state") %>" required>
            </div>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="pinCode">PIN Code <span class="req">*</span></label>
              <input class="input" id="pinCode" name="pinCode" type="text"
                     placeholder="6-digit PIN code"
                     maxlength="6" pattern="[1-9][0-9]{5}"
                     value="<%= val(request, "f_pinCode") %>" required>
            </div>
            <div class="field-group"><%-- spacer --%></div>
          </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════════════ -->
        <!-- SECTION B — Authorized Contact                                  -->
        <!-- ═══════════════════════════════════════════════════════════════ -->
        <div class="form-section">
          <p class="form-section-title"><span>B &nbsp;·&nbsp; Authorized Contact</span></p>

          <div class="form-row">
            <div class="field-group">
              <label for="contactName">Contact Person Name <span class="req">*</span></label>
              <input class="input" id="contactName" name="contactName" type="text"
                     placeholder="Full name"
                     value="<%= val(request, "f_contactName") %>" required>
            </div>
            <div class="field-group">
              <label for="contactDesig">Designation</label>
              <input class="input" id="contactDesig" name="contactDesig" type="text"
                     placeholder="e.g. CEO, Manager (optional)"
                     value="<%= val(request, "f_contactDesig") %>">
            </div>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="contactEmail">Contact Email <span class="req">*</span></label>
              <input class="input" id="contactEmail" name="contactEmail" type="email"
                     placeholder="person@yourcompany.com"
                     value="<%= val(request, "f_contactEmail") %>" required>
            </div>
            <div class="field-group">
              <label for="contactPhone">Contact Phone <span class="req">*</span></label>
              <input class="input" id="contactPhone" name="contactPhone" type="tel"
                     placeholder="10-digit mobile number"
                     value="<%= val(request, "f_contactPhone") %>" required>
            </div>
          </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════════════ -->
        <!-- SECTION C — Login Credentials                                   -->
        <!-- ═══════════════════════════════════════════════════════════════ -->
        <div class="form-section">
          <p class="form-section-title"><span>C &nbsp;·&nbsp; Login Credentials</span></p>

          <div class="field-group">
            <label for="loginEmail">Login Email <span class="req">*</span></label>
            <input class="input" id="loginEmail" name="loginEmail" type="email"
                   placeholder="This will be your login username"
                   value="<%= val(request, "f_loginEmail") %>" required>
          </div>

          <div class="form-row">
            <div class="field-group">
              <label for="password">Password <span class="req">*</span></label>
              <input class="input" id="password" name="password" type="password"
                     placeholder="Create a strong password"
                     autocomplete="new-password" required>
              <p class="hint">Min. 8 characters with at least one letter, one number, and one special character.</p>
            </div>
            <div class="field-group">
              <label for="confirmPassword">Confirm Password <span class="req">*</span></label>
              <input class="input" id="confirmPassword" name="confirmPassword" type="password"
                     placeholder="Re-enter your password"
                     autocomplete="new-password" required>
            </div>
          </div>
        </div>

        <!-- ── Submit ──────────────────────────────────────────────────── -->
        <div class="submit-row">
          <button class="btn btn-primary" type="submit">
            Register Business Partner &nbsp;→
          </button>
          <p class="form-note">
            Already have a business account?
            <a href="business-login.jsp">Sign in here</a>
          </p>
          <p class="form-note">
            <a href="index.jsp">← Back to CarVerse home</a>
          </p>
        </div>

      </form>
    </div><%-- .bp-body --%>
  </div><%-- .bp-card --%>

</main>

<script>
// ── Client-side validation (progressive enhancement — server also validates) ──

(function () {
  var form = document.querySelector('form[action="BusinessRegistration"]');
  if (!form) return;

  var EMAIL_RE = /^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$/;
  var PHONE_RE = /^(\+91|0)?[6-9]\d{9}$/;
  var PIN_RE   = /^[1-9][0-9]{5}$/;
  var PWD_RE   = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$/;

  form.addEventListener('submit', function (e) {
    var errors = [];

    function req(id, label) {
      var el = document.getElementById(id);
      if (!el || !el.value.trim()) errors.push(label + ' is required.');
      return el ? el.value.trim() : '';
    }
    function fmt(id, re, msg) {
      var el = document.getElementById(id);
      if (el && el.value.trim() && !re.test(el.value.trim().replace(/\s+/g,'')))
        errors.push(msg);
    }

    // Section A
    req('businessName', 'Business Name');
    req('brandName',    'Brand Name');
    var bEmail = req('businessEmail', 'Official Business Email');
    if (bEmail) fmt('businessEmail', EMAIL_RE, 'Official Business Email is not valid.');
    req('businessPhone', 'Business Contact Number');
    fmt('businessPhone', PHONE_RE, 'Business Contact Number must be a valid 10-digit number.');
    req('address', 'Address');
    req('city',    'City');
    req('state',   'State');
    var pin = req('pinCode', 'PIN Code');
    if (pin) fmt('pinCode', PIN_RE, 'PIN Code must be a valid 6-digit number.');

    // Section B
    req('contactName',  'Contact Person Name');
    var cEmail = req('contactEmail', 'Contact Email');
    if (cEmail) fmt('contactEmail', EMAIL_RE, 'Contact Email is not valid.');
    req('contactPhone', 'Contact Phone');
    fmt('contactPhone', PHONE_RE, 'Contact Phone must be a valid 10-digit number.');

    // Section C
    var lEmail = req('loginEmail', 'Login Email');
    if (lEmail) fmt('loginEmail', EMAIL_RE, 'Login Email is not valid.');

    var pwd  = document.getElementById('password');
    var cpwd = document.getElementById('confirmPassword');
    if (!pwd  || !pwd.value)  errors.push('Password is required.');
    else if (!PWD_RE.test(pwd.value))
      errors.push('Password must be at least 8 chars with a letter, number, and special character.');
    if (!cpwd || !cpwd.value) errors.push('Please confirm your password.');
    else if (pwd && pwd.value && pwd.value !== cpwd.value)
      errors.push('Password and Confirm Password do not match.');

    if (errors.length > 0) {
      e.preventDefault();
      var existing = form.querySelector('.alert-error');
      if (existing) existing.remove();
      var div = document.createElement('div');
      div.className = 'alert-error';
      div.setAttribute('role', 'alert');
      div.innerHTML = '<strong>Please fix the following:</strong> ' + errors[0];
      form.insertAdjacentElement('beforebegin', div);
      div.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  });
})();
</script>

</body>
</html>
