package com.carverse.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Locale;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/** Password hashing and legacy password verification for CarVerse accounts. */
public final class PasswordUtil {
    private static final String PREFIX = "pbkdf2-sha256";
    private static final int ITERATIONS = 600_000;
    private static final int MAX_STORED_ITERATIONS = 1_000_000;
    private static final int SALT_BYTES = 16;
    private static final int HASH_BYTES = 32;
    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordUtil() { }

    public static String hashPassword(String password) {
        if (password == null) throw new IllegalArgumentException("Password is required.");
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] hash = derive(password, salt, ITERATIONS);
        return PREFIX + "$" + ITERATIONS + "$" + toHex(salt) + "$" + toHex(hash);
    }

    /** Verify current PBKDF2 hashes and support one-time migration from legacy values. */
    public static boolean verifyPassword(String password, String stored) {
        if (password == null || stored == null) return false;
        if (stored.startsWith(PREFIX + "$")) return verifyPbkdf2(password, stored);

        // Business accounts previously used SHA-256(saltHex + password).
        String[] legacyParts = stored.split(":", -1);
        if (legacyParts.length == 2
                && legacyParts[0].matches("(?i)[0-9a-f]{32}")
                && legacyParts[1].matches("(?i)[0-9a-f]{64}")) {
            byte[] expected = legacyParts[1].toLowerCase(Locale.ROOT)
                    .getBytes(StandardCharsets.US_ASCII);
            byte[] actual = sha256Hex((legacyParts[0] + password)
                    .getBytes(StandardCharsets.UTF_8)).getBytes(StandardCharsets.US_ASCII);
            return MessageDigest.isEqual(expected, actual);
        }

        // Existing customer rows stored plaintext; successful login upgrades them.
        return MessageDigest.isEqual(password.getBytes(StandardCharsets.UTF_8),
                stored.getBytes(StandardCharsets.UTF_8));
    }

    public static boolean needsRehash(String stored) {
        if (stored == null || !stored.startsWith(PREFIX + "$")) return true;
        String[] parts = stored.split("\\$", -1);
        if (parts.length != 4) return true;
        try {
            return Integer.parseInt(parts[1]) < ITERATIONS;
        } catch (NumberFormatException e) {
            return true;
        }
    }

    public static String sha256Hex(String value) {
        return sha256Hex(value.getBytes(StandardCharsets.UTF_8));
    }

    private static boolean verifyPbkdf2(String password, String stored) {
        String[] parts = stored.split("\\$", -1);
        if (parts.length != 4) return false;
        try {
            int rounds = Integer.parseInt(parts[1]);
            byte[] salt = fromHex(parts[2]);
            byte[] expected = fromHex(parts[3]);
            if (rounds < 100_000 || rounds > MAX_STORED_ITERATIONS
                    || salt.length != SALT_BYTES || expected.length != HASH_BYTES) return false;
            return MessageDigest.isEqual(expected, derive(password, salt, rounds));
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    private static byte[] derive(String password, byte[] salt, int rounds) {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, rounds, HASH_BYTES * 8);
        try {
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                    .generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new IllegalStateException("PBKDF2-HMAC-SHA256 is unavailable.", e);
        } finally {
            spec.clearPassword();
        }
    }

    private static String sha256Hex(byte[] value) {
        try {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(value);
            return toHex(digest);
        } catch (Exception e) {
            throw new IllegalStateException("SHA-256 is unavailable.", e);
        }
    }

    private static String toHex(byte[] bytes) {
        StringBuilder out = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) out.append(String.format(Locale.ROOT, "%02x", b & 0xff));
        return out.toString();
    }

    private static byte[] fromHex(String text) {
        if (text == null || (text.length() & 1) != 0) throw new IllegalArgumentException();
        byte[] out = new byte[text.length() / 2];
        for (int i = 0; i < out.length; i++) {
            int hi = Character.digit(text.charAt(i * 2), 16);
            int lo = Character.digit(text.charAt(i * 2 + 1), 16);
            if (hi < 0 || lo < 0) throw new IllegalArgumentException();
            out[i] = (byte) ((hi << 4) | lo);
        }
        return out;
    }
}
