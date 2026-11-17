package com.carverse.security;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/** Database operations for one-time password reset tokens. */
public final class PasswordResetDAO {
    private static final String DRIVER = "oracle.jdbc.driver.OracleDriver";
    private static final String DEFAULT_URL = "jdbc:oracle:thin:@localhost:1521:XE";
    private static final String DEFAULT_USER = "CARVERSE";

    public enum AccountType {
        USER, BUSINESS;

        public static AccountType parse(String value) {
            if (value == null) return null;
            try {
                return valueOf(value.trim().toUpperCase(java.util.Locale.ROOT));
            } catch (IllegalArgumentException e) {
                return null;
            }
        }
    }

    /** Demo-only direct reset. Caller must hash password before calling. */
    public boolean resetPasswordByEmail(AccountType type, String email, String passwordHash)
            throws Exception {
        if (type == null) throw new IllegalArgumentException("Account type is required.");
        String lookup = type == AccountType.USER
                ? "SELECT USER_ID FROM USER_REGISTRATION WHERE LOWER(TRIM(EMAIL)) = LOWER(?) FOR UPDATE"
                : "SELECT BUSINESS_ID FROM BUSINESS_PARTNERS WHERE LOWER(TRIM(LOGIN_EMAIL)) = LOWER(?) FOR UPDATE";
        String idColumn = type == AccountType.USER ? "USER_ID" : "BUSINESS_ID";
        String update = type == AccountType.USER
                ? "UPDATE USER_REGISTRATION SET PASSWORD = ? WHERE USER_ID = ?"
                : "UPDATE BUSINESS_PARTNERS SET PASSWORD_HASH = ? WHERE BUSINESS_ID = ?";

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                String accountId;
                try (PreparedStatement find = con.prepareStatement(lookup)) {
                    find.setString(1, email);
                    try (ResultSet rs = find.executeQuery()) {
                        if (!rs.next()) { con.rollback(); return false; }
                        accountId = rs.getString(idColumn);
                        if (rs.next()) {
                            con.rollback();
                            throw new SQLException("More than one account matches this email.");
                        }
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(update)) {
                    ps.setString(1, passwordHash);
                    ps.setString(2, accountId);
                    if (ps.executeUpdate() != 1) { con.rollback(); return false; }
                }
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        }
    }

    /** Store hash only; return verified destination email, or null if no account exists. */
    public String issueToken(AccountType type, String email, String tokenHash) throws Exception {
        String lookup = type == AccountType.USER
                ? "SELECT USER_ID, EMAIL FROM USER_REGISTRATION WHERE LOWER(TRIM(EMAIL)) = LOWER(?) FOR UPDATE"
                : "SELECT BUSINESS_ID, LOGIN_EMAIL FROM BUSINESS_PARTNERS WHERE LOWER(TRIM(LOGIN_EMAIL)) = LOWER(?) FOR UPDATE";
        String idColumn = type == AccountType.USER ? "USER_ID" : "BUSINESS_ID";
        String emailColumn = type == AccountType.USER ? "EMAIL" : "LOGIN_EMAIL";

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                String accountId;
                String destination;
                try (PreparedStatement find = con.prepareStatement(lookup)) {
                    find.setString(1, email);
                    try (ResultSet rs = find.executeQuery()) {
                        if (!rs.next()) { con.rollback(); return null; }
                        accountId = rs.getString(idColumn);
                        destination = rs.getString(emailColumn);
                    }
                }
                try (PreparedStatement recent = con.prepareStatement(
                        "SELECT 1 FROM PASSWORD_RESET_TOKENS WHERE ACCOUNT_TYPE = ? " +
                        "AND ACCOUNT_ID = ? AND CREATED_AT > SYSTIMESTAMP - INTERVAL '1' MINUTE")) {
                    recent.setString(1, type.name());
                    recent.setString(2, accountId);
                    try (ResultSet rs = recent.executeQuery()) {
                        if (rs.next()) { con.rollback(); return null; }
                    }
                }
                try (PreparedStatement removeOld = con.prepareStatement(
                            "DELETE FROM PASSWORD_RESET_TOKENS WHERE ACCOUNT_TYPE = ? AND ACCOUNT_ID = ?");
                     PreparedStatement insert = con.prepareStatement(
                            "INSERT INTO PASSWORD_RESET_TOKENS " +
                            "(TOKEN_HASH, ACCOUNT_TYPE, ACCOUNT_ID, EXPIRES_AT, CREATED_AT) " +
                            "VALUES (?, ?, ?, SYSTIMESTAMP + INTERVAL '30' MINUTE, SYSTIMESTAMP)")) {
                    removeOld.setString(1, type.name());
                    removeOld.setString(2, accountId);
                    removeOld.executeUpdate();
                    insert.setString(1, tokenHash);
                    insert.setString(2, type.name());
                    insert.setString(3, accountId);
                    insert.executeUpdate();
                }
                con.commit();
                return destination;
            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        }
    }

    public boolean isTokenValid(AccountType type, String tokenHash) throws Exception {
        String sql = "SELECT 1 FROM PASSWORD_RESET_TOKENS " +
                "WHERE TOKEN_HASH = ? AND ACCOUNT_TYPE = ? AND USED_AT IS NULL " +
                "AND EXPIRES_AT > SYSTIMESTAMP";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, tokenHash);
            ps.setString(2, type.name());
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        }
    }

    /** Atomically update password and consume every outstanding token for account. */
    public boolean resetPassword(AccountType type, String tokenHash, String passwordHash)
            throws Exception {
        String lock = "SELECT ACCOUNT_ID FROM PASSWORD_RESET_TOKENS " +
                "WHERE TOKEN_HASH = ? AND ACCOUNT_TYPE = ? AND USED_AT IS NULL " +
                "AND EXPIRES_AT > SYSTIMESTAMP FOR UPDATE";
        String update = type == AccountType.USER
                ? "UPDATE USER_REGISTRATION SET PASSWORD = ? WHERE USER_ID = ?"
                : "UPDATE BUSINESS_PARTNERS SET PASSWORD_HASH = ? WHERE BUSINESS_ID = ?";

        try (Connection con = getConnection()) {
            con.setAutoCommit(false);
            try {
                String accountId;
                try (PreparedStatement ps = con.prepareStatement(lock)) {
                    ps.setString(1, tokenHash);
                    ps.setString(2, type.name());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) { con.rollback(); return false; }
                        accountId = rs.getString("ACCOUNT_ID");
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(update)) {
                    ps.setString(1, passwordHash);
                    ps.setString(2, accountId);
                    if (ps.executeUpdate() != 1) { con.rollback(); return false; }
                }
                try (PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM PASSWORD_RESET_TOKENS WHERE ACCOUNT_TYPE = ? AND ACCOUNT_ID = ?")) {
                    ps.setString(1, type.name());
                    ps.setString(2, accountId);
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        }
    }

    public void removeToken(String tokenHash) throws Exception {
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "DELETE FROM PASSWORD_RESET_TOKENS WHERE TOKEN_HASH = ?")) {
            ps.setString(1, tokenHash);
            ps.executeUpdate();
        }
    }

    private Connection getConnection() throws Exception {
        Class.forName(DRIVER);
        String url = envOrDefault("DB_URL", DEFAULT_URL);
        String user = envOrDefault("DB_USER", DEFAULT_USER);
        String password = System.getenv("DB_PASSWORD");
        if (password != null && !password.trim().isEmpty())
            return DriverManager.getConnection(url, user, password);
        try {
            return DriverManager.getConnection(url, user, "manager");
        } catch (SQLException first) {
            return DriverManager.getConnection(url, user, "oracle26");
        }
    }

    private static String envOrDefault(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
