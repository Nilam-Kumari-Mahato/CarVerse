package com.servlet;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Year;

/**
 * Data-access object for BUSINESS_PARTNERS table.
 *
 * Password security approach:
 *   - A random 16-byte salt is generated per registration (SecureRandom).
 *   - SHA-256 is applied to (salt + password).
 *   - The stored value is  saltHex:sha256Hex  — both parts needed to verify.
 *
 * This approach requires no new Maven dependency and is safe for a college
 * project.  BCrypt can be dropped in later by swapping hashPassword() and
 * verifyPassword() without touching the rest of the code.
 */
public class BusinessDAO {

    // -----------------------------------------------------------------------
    // DB connection constants — matches the pattern used across the project
    // -----------------------------------------------------------------------

    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String URL    = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DB_USER = "CARVERSE";
    private static final String DB_PASS = "manager";

    // -----------------------------------------------------------------------
    // Connection helper
    // -----------------------------------------------------------------------

    private Connection getConnection() throws Exception {
        Class.forName(DRIVER);
        return DriverManager.getConnection(URL, DB_USER, DB_PASS);
    }

    // -----------------------------------------------------------------------
    // Password hashing  (salt:hash stored in DB)
    // -----------------------------------------------------------------------

    /**
     * Generates a salted SHA-256 hash of the given plain-text password.
     * Returns the string  "<saltHex>:<hashHex>"  for storage.
     */
    public String hashPassword(String plainPassword) {
        try {
            SecureRandom sr = new SecureRandom();
            byte[] saltBytes = new byte[16];
            sr.nextBytes(saltBytes);
            String saltHex = bytesToHex(saltBytes);

            String hashHex = sha256Hex(saltHex + plainPassword);
            return saltHex + ":" + hashHex;

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored "<saltHex>:<hashHex>"
     * value.  Returns true only if they match.
     */
    public boolean verifyPassword(String plainPassword, String storedHash) {
        try {
            if (storedHash == null || !storedHash.contains(":")) return false;
            String[] parts = storedHash.split(":", 2);
            String saltHex = parts[0];
            String expectedHash = parts[1];
            String actualHash = sha256Hex(saltHex + plainPassword);
            return actualHash.equals(expectedHash);

        } catch (NoSuchAlgorithmException e) {
            return false;
        }
    }

    private String sha256Hex(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] digest = md.digest(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        return bytesToHex(digest);
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    // -----------------------------------------------------------------------
    // ID generation — follows the timestamp pattern used by the project
    // -----------------------------------------------------------------------

    public String generateBusinessId() {
        return "bp_" + Year.now().getValue() + "_" + System.currentTimeMillis();
    }

    // -----------------------------------------------------------------------
    // Registration
    // -----------------------------------------------------------------------

    /**
     * Inserts a new Business Partner row.
     *
     * @param b  Business bean with all fields populated (except businessId,
     *           which is generated here, and createdAt / updatedAt which are
     *           set by the DB via SYSDATE).
     * @return   The generated businessId on success.
     * @throws   DuplicateEmailException if the login email already exists.
     * @throws   Exception for any other DB / unexpected error.
     */
    public String register(Business b) throws DuplicateEmailException, Exception {

        String id = generateBusinessId();

        String sql =
            "INSERT INTO BUSINESS_PARTNERS (" +
            "  BUSINESS_ID, BUSINESS_NAME, BRAND_NAME, REGISTRATION_NO," +
            "  GSTIN, PAN, BUSINESS_EMAIL, BUSINESS_PHONE, WEBSITE," +
            "  ADDRESS, CITY, STATE, PIN_CODE," +
            "  CONTACT_PERSON_NAME, CONTACT_PERSON_DESIGNATION," +
            "  CONTACT_PERSON_EMAIL, CONTACT_PERSON_PHONE," +
            "  LOGIN_EMAIL, PASSWORD_HASH, ACCOUNT_STATUS," +
            "  CREATED_AT, UPDATED_AT" +
            ") VALUES (" +
            "  ?,?,?,?,  ?,?,?,?,?,  ?,?,?,?," +
            "  ?,?,  ?,?," +
            "  ?,?,?," +
            "  SYSDATE, SYSDATE" +
            ")";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1,  id);
            ps.setString(2,  b.getBusinessName());
            ps.setString(3,  b.getBrandName());
            ps.setString(4,  nullIfBlank(b.getRegistrationNo()));
            ps.setString(5,  nullIfBlank(b.getGstin()));
            ps.setString(6,  nullIfBlank(b.getPan()));
            ps.setString(7,  b.getBusinessEmail());
            ps.setString(8,  b.getBusinessPhone());
            ps.setString(9,  nullIfBlank(b.getWebsite()));
            ps.setString(10, b.getAddress());
            ps.setString(11, b.getCity());
            ps.setString(12, b.getState());
            ps.setString(13, b.getPinCode());
            ps.setString(14, b.getContactPersonName());
            ps.setString(15, nullIfBlank(b.getContactPersonDesignation()));
            ps.setString(16, b.getContactPersonEmail());
            ps.setString(17, b.getContactPersonPhone());
            ps.setString(18, b.getLoginEmail());
            ps.setString(19, b.getPasswordHash());
            ps.setString(20, "ACTIVE"); // set to ACTIVE for college project simplicity

            ps.executeUpdate();
            return id;

        } catch (SQLException e) {
            // ORA-00001: unique constraint violated  → duplicate login email
            if (e.getErrorCode() == 1) {
                throw new DuplicateEmailException(
                    "An account with this login email already exists.");
            }
            throw e;
        }
    }

    // -----------------------------------------------------------------------
    // Login
    // -----------------------------------------------------------------------

    /**
     * Looks up a business partner by login email and verifies the password.
     *
     * @return  A Business bean (id, names, status populated) on success,
     *          or null if credentials are wrong / account not found.
     * @throws  AccountNotActiveException if the account exists but is not ACTIVE.
     * @throws  Exception for DB errors.
     */
    public Business login(String loginEmail, String plainPassword)
            throws AccountNotActiveException, Exception {

        String sql =
            "SELECT BUSINESS_ID, BUSINESS_NAME, BRAND_NAME," +
            "       PASSWORD_HASH, ACCOUNT_STATUS" +
            "  FROM BUSINESS_PARTNERS" +
            " WHERE LOGIN_EMAIL = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, loginEmail);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    // Email not found — return null; servlet will show generic error
                    return null;
                }

                String storedHash = rs.getString("PASSWORD_HASH");
                String status     = rs.getString("ACCOUNT_STATUS");

                // Verify password before revealing account status
                if (!verifyPassword(plainPassword, storedHash)) {
                    return null; // wrong password
                }

                if (!"ACTIVE".equals(status)) {
                    throw new AccountNotActiveException(status);
                }

                Business b = new Business();
                b.setBusinessId(rs.getString("BUSINESS_ID"));
                b.setBusinessName(rs.getString("BUSINESS_NAME"));
                b.setBrandName(rs.getString("BRAND_NAME"));
                b.setLoginEmail(loginEmail);
                b.setAccountStatus(status);
                return b;
            }
        }
    }

    // -----------------------------------------------------------------------
    // Duplicate-check helpers (used by servlet for early client-friendly error)
    // -----------------------------------------------------------------------

    /** Returns true if a row with this login email already exists. */
    public boolean loginEmailExists(String loginEmail) throws Exception {
        String sql = "SELECT 1 FROM BUSINESS_PARTNERS WHERE LOGIN_EMAIL = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, loginEmail);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // -----------------------------------------------------------------------
    // Utility
    // -----------------------------------------------------------------------

    /** Converts blank / whitespace-only strings to null for optional fields. */
    private String nullIfBlank(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    // -----------------------------------------------------------------------
    // Inner exception classes — kept here to avoid extra files
    // -----------------------------------------------------------------------

    /** Thrown when a duplicate login email is detected. */
    public static class DuplicateEmailException extends Exception {
        public DuplicateEmailException(String message) { super(message); }
    }

    /**
     * Thrown when the account exists and the password matches, but the
     * account is not ACTIVE (PENDING / SUSPENDED / REJECTED).
     */
    public static class AccountNotActiveException extends Exception {
        private final String status;
        public AccountNotActiveException(String status) {
            super("Account status: " + status);
            this.status = status;
        }
        public String getStatus() { return status; }
    }
}
