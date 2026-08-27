package com.servlet;

import java.security.SecureRandom;

public class UserIdGenerator {
	private static final String CHARACTERS =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    private static final SecureRandom random = new SecureRandom();

    public static String generateUserId(int length) {

        StringBuilder userId = new StringBuilder(length);

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(CHARACTERS.length());
            userId.append(CHARACTERS.charAt(index));
        }

        return userId.toString();
    }
}
