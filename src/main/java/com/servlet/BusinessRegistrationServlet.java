package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * Handles POST from business-register.jsp.
 *
 * Flow:
 *   1. Read & trim all form parameters.
 *   2. Server-side validation (required fields, formats, password strength,
 *      password match, duplicate email).
 *   3. Hash password via BusinessDAO.
 *   4. Persist via BusinessDAO.register().
 *   5. Redirect to business-login.jsp with a success flag.
 *
 * On any validation failure the servlet forwards back to business-register.jsp
 * with an "error" request attribute and repopulates form fields.
 */
@WebServlet("/BusinessRegistration")
public class BusinessRegistrationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // -----------------------------------------------------------------------
    // Compiled validation patterns
    // -----------------------------------------------------------------------

    // Standard email
    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[\\w.+\\-]+@[\\w\\-]+\\.[a-zA-Z]{2,}$");

    // 10-digit Indian mobile number (optionally prefixed with +91 or 0)
    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^(\\+91|0)?[6-9]\\d{9}$");

    // 6-digit Indian PIN code
    private static final Pattern PIN_PATTERN =
        Pattern.compile("^[1-9][0-9]{5}$");

    // Password: min 8 chars, at least 1 letter, 1 digit, 1 special character
    private static final Pattern PASSWORD_PATTERN =
        Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,}$");

    // -----------------------------------------------------------------------
    // POST handler
    // -----------------------------------------------------------------------

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // --- Section A: Business Information ---
        String businessName   = trim(request.getParameter("businessName"));
        String brandName      = trim(request.getParameter("brandName"));
        String registrationNo = trim(request.getParameter("registrationNo"));
        String gstin          = trim(request.getParameter("gstin"));
        String pan            = trim(request.getParameter("pan"));
        String businessEmail  = trim(request.getParameter("businessEmail"));
        String businessPhone  = trim(request.getParameter("businessPhone"));
        String website        = trim(request.getParameter("website"));
        String address        = trim(request.getParameter("address"));
        String city           = trim(request.getParameter("city"));
        String state          = trim(request.getParameter("state"));
        String pinCode        = trim(request.getParameter("pinCode"));

        // --- Section B: Authorized Contact ---
        String contactName    = trim(request.getParameter("contactName"));
        String contactDesig   = trim(request.getParameter("contactDesig"));
        String contactEmail   = trim(request.getParameter("contactEmail"));
        String contactPhone   = trim(request.getParameter("contactPhone"));

        // --- Section C: Login Credentials ---
        String loginEmail     = trim(request.getParameter("loginEmail"));
        String password       = request.getParameter("password");       // do not trim passwords
        String confirmPassword = request.getParameter("confirmPassword");

        // -----------------------------------------------------------------------
        // Server-side validation
        // -----------------------------------------------------------------------

        String error = validate(
            businessName, brandName, businessEmail, businessPhone,
            address, city, state, pinCode,
            contactName, contactEmail, contactPhone,
            loginEmail, password, confirmPassword
        );

        if (error == null) {
            // Duplicate email check (explicit, before hitting the DB unique constraint)
            try {
                BusinessDAO dao = new BusinessDAO();
                if (dao.loginEmailExists(loginEmail)) {
                    error = "An account with this login email already exists. Please sign in or use a different email.";
                }
            } catch (Exception e) {
                error = "A database error occurred. Please try again.";
            }
        }

        if (error != null) {
            // Forward back to form with error message and repopulated fields
            request.setAttribute("error", error);
            repopulate(request,
                businessName, brandName, registrationNo, gstin, pan,
                businessEmail, businessPhone, website, address, city, state, pinCode,
                contactName, contactDesig, contactEmail, contactPhone, loginEmail);
            request.getRequestDispatcher("business-register.jsp").forward(request, response);
            return;
        }

        // -----------------------------------------------------------------------
        // Build bean, hash password, persist
        // -----------------------------------------------------------------------
        try {
            BusinessDAO dao = new BusinessDAO();

            Business b = new Business();
            b.setBusinessName(businessName);
            b.setBrandName(brandName);
            b.setRegistrationNo(registrationNo);
            b.setGstin(gstin);
            b.setPan(pan);
            b.setBusinessEmail(businessEmail);
            b.setBusinessPhone(businessPhone);
            b.setWebsite(website);
            b.setAddress(address);
            b.setCity(city);
            b.setState(state);
            b.setPinCode(pinCode);
            b.setContactPersonName(contactName);
            b.setContactPersonDesignation(contactDesig);
            b.setContactPersonEmail(contactEmail);
            b.setContactPersonPhone(contactPhone);
            b.setLoginEmail(loginEmail);
            b.setPasswordHash(dao.hashPassword(password)); // hash before storing

            dao.register(b);

            // Success — redirect to login page with a flag so JSP can show a banner
            response.sendRedirect("business-login.jsp?registered=true");

        } catch (BusinessDAO.DuplicateEmailException e) {
            request.setAttribute("error", "An account with this login email already exists.");
            repopulate(request,
                businessName, brandName, registrationNo, gstin, pan,
                businessEmail, businessPhone, website, address, city, state, pinCode,
                contactName, contactDesig, contactEmail, contactPhone, loginEmail);
            request.getRequestDispatcher("business-register.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Registration failed due to a server error. Please try again.");
            repopulate(request,
                businessName, brandName, registrationNo, gstin, pan,
                businessEmail, businessPhone, website, address, city, state, pinCode,
                contactName, contactDesig, contactEmail, contactPhone, loginEmail);
            request.getRequestDispatcher("business-register.jsp").forward(request, response);
        }
    }

    // -----------------------------------------------------------------------
    // Validation helper — returns null if everything is fine, else the first
    // human-readable error message found.
    // -----------------------------------------------------------------------

    private String validate(
            String businessName, String brandName,
            String businessEmail, String businessPhone,
            String address, String city, String state, String pinCode,
            String contactName, String contactEmail, String contactPhone,
            String loginEmail, String password, String confirmPassword) {

        // Required — Section A
        if (blank(businessName))   return "Business / Company Name is required.";
        if (blank(brandName))      return "Brand Name is required.";
        if (blank(businessEmail))  return "Official Business Email is required.";
        if (!EMAIL_PATTERN.matcher(businessEmail).matches())
                                   return "Official Business Email is not a valid email address.";
        if (blank(businessPhone))  return "Business Contact Number is required.";
        if (!PHONE_PATTERN.matcher(businessPhone.replaceAll("\\s+", "")).matches())
                                   return "Business Contact Number must be a valid 10-digit mobile number.";
        if (blank(address))        return "Address is required.";
        if (blank(city))           return "City is required.";
        if (blank(state))          return "State is required.";
        if (blank(pinCode))        return "PIN Code is required.";
        if (!PIN_PATTERN.matcher(pinCode).matches())
                                   return "PIN Code must be a valid 6-digit Indian PIN code.";

        // Required — Section B
        if (blank(contactName))    return "Contact Person Name is required.";
        if (blank(contactEmail))   return "Contact Email is required.";
        if (!EMAIL_PATTERN.matcher(contactEmail).matches())
                                   return "Contact Email is not a valid email address.";
        if (blank(contactPhone))   return "Contact Phone is required.";
        if (!PHONE_PATTERN.matcher(contactPhone.replaceAll("\\s+", "")).matches())
                                   return "Contact Phone must be a valid 10-digit mobile number.";

        // Required — Section C
        if (blank(loginEmail))     return "Login Email is required.";
        if (!EMAIL_PATTERN.matcher(loginEmail).matches())
                                   return "Login Email is not a valid email address.";
        if (blank(password))       return "Password is required.";
        if (!PASSWORD_PATTERN.matcher(password).matches())
                                   return "Password must be at least 8 characters and include a letter, a number, and a special character.";
        if (blank(confirmPassword)) return "Please confirm your password.";
        if (!password.equals(confirmPassword))
                                   return "Password and Confirm Password do not match.";

        return null; // all good
    }

    // -----------------------------------------------------------------------
    // Utility helpers
    // -----------------------------------------------------------------------

    /** Trims a parameter; returns empty string if null. */
    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    /** True if the string is null or contains only whitespace. */
    private boolean blank(String s) {
        return s == null || s.trim().isEmpty();
    }

    /**
     * Sets request attributes so the JSP can repopulate the form on error.
     * Passwords are deliberately never sent back.
     */
    private void repopulate(HttpServletRequest req,
            String businessName, String brandName, String registrationNo,
            String gstin, String pan, String businessEmail, String businessPhone,
            String website, String address, String city, String state, String pinCode,
            String contactName, String contactDesig, String contactEmail,
            String contactPhone, String loginEmail) {

        req.setAttribute("f_businessName",   businessName);
        req.setAttribute("f_brandName",      brandName);
        req.setAttribute("f_registrationNo", registrationNo);
        req.setAttribute("f_gstin",          gstin);
        req.setAttribute("f_pan",            pan);
        req.setAttribute("f_businessEmail",  businessEmail);
        req.setAttribute("f_businessPhone",  businessPhone);
        req.setAttribute("f_website",        website);
        req.setAttribute("f_address",        address);
        req.setAttribute("f_city",           city);
        req.setAttribute("f_state",          state);
        req.setAttribute("f_pinCode",        pinCode);
        req.setAttribute("f_contactName",    contactName);
        req.setAttribute("f_contactDesig",   contactDesig);
        req.setAttribute("f_contactEmail",   contactEmail);
        req.setAttribute("f_contactPhone",   contactPhone);
        req.setAttribute("f_loginEmail",     loginEmail);
    }
}
