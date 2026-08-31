package com.servlet;

import java.time.Year;

public class MaintenanceIdGenerator {

    public static String generateMaintenanceId() {

        int currentYear = Year.now().getValue();

        long currentTimestamp = System.currentTimeMillis();

        return "m_" + currentYear + "_" + currentTimestamp;
    }

}