<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Booking Status</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(rgba(15,35,29,0.88), rgba(15,35,29,0.88)), url("car-bg.jpg");
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .popup-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 36px 40px;
            width: 460px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }

        .label-tag {
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #82b91e;
            margin-bottom: 8px;
        }

        h2 {
            font-size: 20px;
            color: #1f3a32;
            margin-bottom: 6px;
        }

        .sub {
            font-size: 12px;
            color: #8a9691;
            margin-bottom: 22px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #edf0ee;
            margin-bottom: 4px;
            font-size: 12px;
        }

        .info-row .info-label {
            color: #8a9691;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .6px;
            font-size: 10px;
        }

        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .5px;
        }

        .badge-none      { background:#f1f3f0; color:#747980; }
        .badge-requested { background:#fff3cd; color:#856404; }
        .badge-approved  { background:#d1e7dd; color:#0a3622; }
        .badge-rejected  { background:#f8d7da; color:#58151c; }
        .badge-cancelled { background:#f8d7da; color:#58151c; }
        .badge-pending   { background:#fff3cd; color:#856404; }
        .badge-confirmed { background:#cfe2ff; color:#084298; }
        .badge-completed { background:#d1e7dd; color:#0a3622; }

        .divider { border: none; border-top: 1px solid #edf0ee; margin: 20px 0; }

        label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: #354246;
            margin-bottom: 8px;
        }

        select {
            width: 100%;
            padding: 13px 14px;
            border: 1px solid #d9e0dc;
            border-radius: 8px;
            background: #fbfcfb;
            color: #2d393d;
            font-size: 14px;
            font-family: inherit;
            outline: none;
            margin-bottom: 28px;
        }

        select:focus {
            border-color: #9bd126;
            box-shadow: 0 0 0 4px rgba(155,209,38,0.12);
        }

        .cancel-note {
            background: #fff8e1;
            border-left: 3px solid #f0ad4e;
            padding: 10px 14px;
            font-size: 11px;
            color: #856404;
            border-radius: 0 6px 6px 0;
            margin-top: -18px;
            margin-bottom: 24px;
        }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #edf0ee;
            padding-top: 20px;
        }

        .btn-back {
            text-decoration: none;
            color: #263238;
            font-size: 13px;
            font-weight: bold;
            padding: 11px 16px;
            border: 1px solid #ccd4d0;
            border-radius: 8px;
            background: #ffffff;
        }

        .btn-back:hover { background: #1f3a32; color: #ffffff; }

        .btn-save {
            border: none;
            background: #9bd126;
            color: #202b2e;
            padding: 13px 26px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 700;
        }

        .btn-save:hover { background: #8ac01b; }
    </style>
</head>
<body>

    <%
        String bookingId = request.getParameter("bookingId");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Admin?action=bookings");
            return;
        }

        // Fetch current booking row so we can show context and pre-select status
        String currentBookingStatus      = "Pending";
        String currentCancellationStatus = "NONE";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            try (Connection con = DriverManager.getConnection(
                        "jdbc:oracle:thin:@localhost:1521:XE", "CARVERSE", "manager");
                 PreparedStatement ps = con.prepareStatement(
                        "SELECT booking_status, NVL(cancellation_status,'NONE') AS cancellation_status " +
                        "FROM booking_details WHERE booking_id = ?")) {
                ps.setString(1, bookingId.trim());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentBookingStatus      = rs.getString("booking_status");
                        currentCancellationStatus = rs.getString("cancellation_status");
                    }
                }
            }
        } catch (Exception e) {
            // non-fatal — form still works without pre-selection
        }

        String csBadgeClass;
        switch (currentCancellationStatus.toUpperCase()) {
            case "REQUESTED": csBadgeClass = "badge-requested"; break;
            case "APPROVED":  csBadgeClass = "badge-approved";  break;
            case "REJECTED":  csBadgeClass = "badge-rejected";  break;
            default:          csBadgeClass = "badge-none";       break;
        }

        String bsBadgeClass = "badge-" + currentBookingStatus.toLowerCase();
        boolean hasPendingCancelRequest = "REQUESTED".equalsIgnoreCase(currentCancellationStatus);
    %>

    <div class="popup-card">

        <div class="label-tag">Admin Access Only</div>
        <h2>Update Booking Status</h2>
        <p class="sub">Booking ID: <strong><%= bookingId %></strong></p>

        <!-- Current state summary -->
        <div class="info-row">
            <span class="info-label">Current Booking Status</span>
            <span class="badge <%= bsBadgeClass %>"><%= currentBookingStatus %></span>
        </div>
        <div class="info-row" style="margin-bottom:16px;">
            <span class="info-label">Cancellation Status</span>
            <span class="badge <%= csBadgeClass %>"><%= currentCancellationStatus %></span>
        </div>

        <hr class="divider">

        <form action="<%= request.getContextPath() %>/BookingStatusUpdate" method="POST">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">

            <label for="status">New Booking Status</label>
            <select id="status" name="status">
                <option value="PENDING"   <%= "PENDING".equalsIgnoreCase(currentBookingStatus)   ? "selected" : "" %>>Pending</option>
                <option value="CONFIRMED" <%= "CONFIRMED".equalsIgnoreCase(currentBookingStatus) ? "selected" : "" %>>Confirmed</option>
                <option value="COMPLETED" <%= "COMPLETED".equalsIgnoreCase(currentBookingStatus) ? "selected" : "" %>>Completed</option>
                <option value="CANCELLED" <%= "CANCELLED".equalsIgnoreCase(currentBookingStatus) ? "selected" : "" %>>Cancelled</option>
            </select>

            <% if (hasPendingCancelRequest) { %>
            <div class="cancel-note">
                This booking has a pending cancellation request. Pending keeps it requested;
                Confirmed or Completed rejects it; Cancelled approves it.
            </div>
            <% } %>

            <div class="form-footer">
                <a href="<%= request.getContextPath() %>/Admin?action=bookings" class="btn-back">← Back</a>
                <button type="submit" class="btn-save">Update</button>
            </div>
        </form>

    </div>

</body>
</html>
