package com.carverse.security;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

/** Sends reset links through SMTP settings supplied by the deployment environment. */
public final class PasswordResetMailer {
    private PasswordResetMailer() { }

    public static void send(String recipient, String token, PasswordResetDAO.AccountType type)
            throws Exception {
        String host = requiredEnv("SMTP_HOST");
        String from = requiredEnv("SMTP_FROM");
        String appBase = validatedAppBase(requiredEnv("APP_BASE_URL"));
        String port = envOrDefault("SMTP_PORT", "587");
        String username = System.getenv("SMTP_USER");
        String password = System.getenv("SMTP_PASSWORD");
        if (username != null && !username.isEmpty() && (password == null || password.isEmpty()))
            throw new IllegalStateException("SMTP_PASSWORD is required when SMTP_USER is set.");
        boolean ssl = "true".equalsIgnoreCase(System.getenv("SMTP_SSL")) || "465".equals(port);
        boolean startTls = !ssl;

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", port);
        properties.put("mail.smtp.auth", Boolean.toString(username != null && !username.isEmpty()));
        properties.put("mail.smtp.ssl.enable", Boolean.toString(ssl));
        properties.put("mail.smtp.starttls.enable", Boolean.toString(startTls));
        properties.put("mail.smtp.starttls.required", Boolean.toString(startTls));
        properties.put("mail.smtp.connectiontimeout", "10000");
        properties.put("mail.smtp.timeout", "10000");
        properties.put("mail.smtp.writetimeout", "10000");

        Authenticator authenticator = username != null && !username.isEmpty()
                ? new Authenticator() {
                    @Override protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password == null ? "" : password);
                    }
                }
                : null;
        Session session = Session.getInstance(properties, authenticator);

        String resetUrl = appBase + "/PasswordReset?accountType=" + type.name()
                + "&token=" + URLEncoder.encode(token, StandardCharsets.UTF_8.name());
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(from, true));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient, true));
        message.setSubject("CarVerse password reset", StandardCharsets.UTF_8.name());
        message.setText("Use this one-time link to reset your CarVerse password:\n\n"
                + resetUrl + "\n\nThis link expires in 30 minutes. If you did not request "
                + "a password reset, ignore this email.", StandardCharsets.UTF_8.name());
        Transport.send(message);
    }

    private static String validatedAppBase(String value) {
        URI uri = URI.create(value.trim());
        String scheme = uri.getScheme();
        String host = uri.getHost();
        boolean localHttp = "http".equalsIgnoreCase(scheme)
                && ("localhost".equalsIgnoreCase(host) || "127.0.0.1".equals(host));
        if ((!"https".equalsIgnoreCase(scheme) && !localHttp)
                || host == null || uri.getRawUserInfo() != null
                || uri.getRawQuery() != null || uri.getRawFragment() != null) {
            throw new IllegalArgumentException("APP_BASE_URL must be an HTTPS URL (HTTP is allowed only for localhost).");
        }
        String base = value.trim();
        while (base.endsWith("/")) base = base.substring(0, base.length() - 1);
        return base;
    }

    private static String requiredEnv(String name) {
        String value = System.getenv(name);
        if (value == null || value.trim().isEmpty())
            throw new IllegalStateException("Required environment setting is missing: " + name);
        return value.trim();
    }

    private static String envOrDefault(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
