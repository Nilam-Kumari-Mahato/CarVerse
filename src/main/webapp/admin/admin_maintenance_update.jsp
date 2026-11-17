<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Maintenance Status</title>
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
            width: 420px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }

        .popup-card .label-tag {
            font-size: 10px;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: #82b91e;
            margin-bottom: 8px;
        }

        .popup-card h2 {
            font-size: 20px;
            color: #1f3a32;
            margin-bottom: 6px;
        }

        .popup-card .sub {
            font-size: 12px;
            color: #8a9691;
            margin-bottom: 28px;
        }

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
        String maintenanceId = request.getParameter("maintenanceId");
        if (maintenanceId == null || maintenanceId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Admin?action=maintenance");
            return;
        }
    %>

    <div class="popup-card">

        <div class="label-tag">Admin Access Only</div>
        <h2>Update Maintenance Status</h2>
        <p class="sub">Record ID: <strong><%= maintenanceId %></strong></p>

        <form action="<%= request.getContextPath() %>/MaintenanceUpdate" method="POST">
            <input type="hidden" name="maintenanceId" value="<%= maintenanceId %>">

            <label for="status">Maintenance Status</label>
            <select id="status" name="status">
                <option value="Pending">Pending</option>
                <option value="In Progress">In Progress</option>
                <option value="Completed">Completed</option>
            </select>

            <div class="form-footer">
                <a href="<%= request.getContextPath() %>/Admin?action=maintenance" class="btn-back">← Back</a>
                <button type="submit" class="btn-save">Update</button>
            </div>
        </form>

    </div>

</body>
</html>
