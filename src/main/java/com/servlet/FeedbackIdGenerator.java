package com.servlet;

import java.time.Year;

public class FeedbackIdGenerator {

    public static String generateFeedbackId() {

        int currentYear = Year.now().getValue();
        long timestamp = System.currentTimeMillis();

        return "f_" + currentYear + "_" + timestamp;
    }

}