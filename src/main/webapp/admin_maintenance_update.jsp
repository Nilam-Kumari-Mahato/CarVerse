<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin - Maintenance Status & Feature Update</title>
        <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #0f231d;
            background-image: linear-gradient(rgba(15, 35, 29, 0.88), rgba(15, 35, 29, 0.88)), url("car-bg.jpg");
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            color: #263238;
            padding: 40px 20px;
        }

        .admin-card {
            max-width: 850px;
            margin: auto;
            background: #ffffff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.35);
        }

        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #edf0ee;
            padding-bottom: 16px;
            margin-bottom: 24px;
        }

        .header-bar h2 {
            font-size: 22px;
            color: #1f3a32;
        }

        .header-bar h2 span {
            color: #82b91e;
        }

        .badge-status {
            background: #eaf5d1;
            color: #4f6b0b;
            font-size: 11px;
            font-weight: 800;
            padding: 6px 14px;
            border-radius: 20px;
            text-transform: uppercase;
        }

        .features-panel {
            background: #fbfcfb;
            border: 1px solid #e5eae7;
            border-radius: 10px;
            padding: 18px 20px;
            margin-bottom: 25px;
        }

        .features-panel h3 {
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #607279;
            margin-bottom: 12px;
        }

        .tag-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .tag {
            background: #ffffff;
            border: 1px solid #d5ded9;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            color: #2d393d;
        }

        .tag span {
            color: #82b91e;
            font-weight: 800;
            margin-right: 4px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #354246;
            margin-bottom: 8px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            border: 1px solid #d9e0dc;
            background: #fbfcfb;
            color: #2d393d;
            font-size: 14px;
            border-radius: 8px;
            padding: 12px 14px;
            outline: none;
            font-family: inherit;
        }

        .form-group textarea {
            resize: vertical;
            line-height: 1.6;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #9bd126;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(155, 209, 38, 0.12);
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
            padding: 12px 18px;
            border: 1px solid #ccd4d0;
            border-radius: 8px;
            background: #ffffff;
        }

        .btn-back:hover {
            background: #1f3a32;
            color: #ffffff;
        }

        .btn-save {
            border: none;
            background: #9bd126;
            color: #202b2e;
            padding: 14px 28px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            transition: 0.2s;
        }

        .btn-save:hover {
            background: #8ac01b;
            transform: translateY(-2px);
        }
        </style>
    </head>
    <body>

        <div class="admin-card">

            <div class="header-bar">
                <div>
                    <h2>Maintenance Details & <span>Status Update</span></h2>
                    <p style="font-size: 13px; color: #718084; margin-top: 4px;">Ticket ID: <strong>#MNT-101</strong> (Admin Access Only)</p>
                </div>
                <span class="badge-status">Status: In Progress</span>
            </div>

            <!-- FEATURES UPDATED BY USER -->
            <div class="features-panel">
                <h3>Features & Parts Selected by User</h3>
                <div class="tag-list">
                    <div class="tag"><span>✓</span> Ceramic Brake Pads</div>
                    <div class="tag"><span>✓</span> Sport Alloy Wheels</div>
                    <div class="tag"><span>✓</span> Stage-1 ECU Tuning</div>
                    <div class="tag"><span>✓</span> Synthetic Oil Replacement</div>
                </div>
            </div>

            <!-- ADMIN FORM (Calls your MaintenanceUpdate servlet) -->
            <form action="MaintenanceUpdate" method="POST">
                <input type="hidden" name="recordId" value="101">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="status">Update Maintenance Status</label>
                        <select id="status" name="status">
                            <option value="Pending">Pending Inspection</option>
                            <option value="In Progress" selected>In Progress</option>
                            <option value="Parts Ordered">Parts Ordered / Awaiting Dispatch</option>
                            <option value="Testing">Road Test / Diagnostics</option>
                            <option value="Completed">Completed & Delivered</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="cost">Updated Cost ($)</label>
                        <input type="number" id="cost" name="cost" value="450.00" step="0.01" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="newFeatures">Add New Feature / Part Verified</label>
                    <input type="text" id="newFeatures" name="newFeatures" placeholder="e.g. High-Flow Air Filter, Custom Exhaust">
                </div>

                <div class="form-group">
                    <label for="technicianNotes">Service / Technician Notes</label>
                    <textarea id="technicianNotes" name="technicianNotes" rows="4" placeholder="Inspection notes, diagnostic codes, etc...">Brake pads verified at 80% life. Engine diagnostics running normal.</textarea>
                </div>

                <div class="form-footer">
                    <a href="admin_dashboard.jsp" class="btn-back">← Back to Dashboard</a>
                    <button type="submit" class="btn-save">Save & Update Status →</button>
                </div>
            </form>

        </div>

    </body>
</html>
