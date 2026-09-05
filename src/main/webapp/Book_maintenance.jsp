<%-- 
    Document   : Book_maintenance
    Created on : 31 Aug, 2026, 10:35:40 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Maintenance Page</title>
        <link rel="stylesheet" href="assets/css/carverse.css">
        <style>

        /* =========================
           GLOBAL STYLES
        ========================= */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #f6f8f7;
            color: #263238;
        }


        /* =========================
           NAVBAR
        ========================= */

        .navbar {
            width: 100%;
            height: 86px;
            background: #ffffff;
            border-bottom: 1px solid #e6e9e7;
        }

        .nav-container {
            width: 100%;
            max-width: 1100px;
            height: 100%;
            margin: auto;

            display: flex;
            align-items: center;
        }


        /* =========================
           LOGO
        ========================= */

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;

            text-decoration: none;
            color: #263238;

            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .logo-icon {
            width: 43px;
            height: 43px;

            color: #9bd126;

            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo-icon svg {
            width: 38px;
            height: 38px;
        }


        /* =========================
           NAVIGATION LINKS
        ========================= */

        .nav-links {
            display: flex;
            align-items: center;
            gap: 34px;

            margin-left: 52px;
        }

        .nav-links a {
            text-decoration: none;

            color: #303b3f;

            font-size: 14px;
            font-weight: 600;

            transition: 0.2s ease;
        }

        .nav-links a:hover {
            color: #547d1e;
        }

        .nav-links .active {
            color: #547d1e;
        }


        /* =========================
           RIGHT NAV SECTION
        ========================= */

        .nav-right {
            margin-left: auto;

            display: flex;
            align-items: center;
            gap: 24px;
        }

        .welcome-text {
            font-size: 16px;
            color: #4d585c;
        }

        .maintenance-btn {
            background: #9bd126;

            color: #1d292c;

            text-decoration: none;

            padding: 15px 21px;

            border-radius: 8px;

            font-size: 13px;
            font-weight: 700;

            letter-spacing: 0.2px;

            transition: 0.25s ease;
        }

        .maintenance-btn:hover {
            background: #8bc01c;
            transform: translateY(-1px);
        }


        /* =========================
           MAIN PAGE
        ========================= */

        .maintenance-page {
            min-height: calc(100vh - 86px);

            padding: 65px 20px 80px;

            background: linear-gradient(
                135deg,
                #f8faf9 0%,
                #f1f5f2 100%
            );
        }


        /* =========================
           BOOKING CONTAINER
        ========================= */

        .booking-container {
            max-width: 900px;
            margin: auto;
        }


        /* =========================
           PAGE HEADING
        ========================= */

        .page-heading {
            text-align: center;

            max-width: 650px;
            margin: 0 auto 38px;
        }

        .section-tag {
            color: #82b91e;

            font-size: 12px;
            font-weight: 800;

            letter-spacing: 2px;

            margin-bottom: 12px;
        }

        .page-heading h1 {
            font-size: 38px;
            color: #263238;

            margin-bottom: 14px;

            letter-spacing: -1px;
        }

        .page-heading p:not(.section-tag) {
            color: #718084;

            font-size: 16px;

            line-height: 1.7;
        }


        /* =========================
           BOOKING CARD
        ========================= */

        .booking-card {
            background: #ffffff;

            border: 1px solid #e5eae7;

            border-radius: 16px;

            padding: 42px;

            box-shadow: 0 12px 40px rgba(38, 50, 56, 0.07);
        }


        /* =========================
           FORM GRID
        ========================= */

        .form-grid {
            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 25px;
        }


        /* =========================
           FORM GROUP
        ========================= */

        .form-group {
            display: flex;
            flex-direction: column;

            margin-bottom: 28px;
        }

        .form-group label {
            font-size: 14px;

            font-weight: 700;

            color: #354246;

            margin-bottom: 10px;
        }


        /* =========================
           FORM INPUTS
        ========================= */

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;

            border: 1px solid #d9e0dc;

            background: #fbfcfb;

            color: #2d393d;

            font-size: 14px;

            border-radius: 8px;

            outline: none;

            transition: 0.25s ease;

            font-family: inherit;
        }


        .form-group input,
        .form-group select {
            height: 52px;

            padding: 0 16px;
        }


        .form-group textarea {
            padding: 16px;

            resize: vertical;

            line-height: 1.6;
        }


        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #9aa5a2;
        }


        /* =========================
           INPUT FOCUS
        ========================= */

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #9bd126;

            background: #ffffff;

            box-shadow: 0 0 0 4px rgba(155, 209, 38, 0.12);
        }

        .form-group select {
            cursor: pointer;
        }


        /* =========================
           FORM FOOTER
        ========================= */

        .form-footer {
            border-top: 1px solid #edf0ee;

            padding-top: 25px;

            display: flex;
            align-items: center;
            justify-content: space-between;

            gap: 20px;
        }

        .form-note {
            color: #87918e;

            font-size: 13px;

            line-height: 1.5;
        }


        /* =========================
           SUBMIT BUTTON
        ========================= */

        .submit-btn {
            border: none;

            background: #9bd126;

            color: #202b2e;

            padding: 15px 25px;

            border-radius: 8px;

            cursor: pointer;

            font-size: 14px;
            font-weight: 700;

            display: flex;
            align-items: center;
            gap: 10px;

            transition: 0.25s ease;

            white-space: nowrap;
        }

        .submit-btn span {
            font-size: 19px;
        }

        .submit-btn:hover {
            background: #8ac01b;

            transform: translateY(-2px);

            box-shadow: 0 8px 20px rgba(139, 192, 27, 0.22);
        }

        .submit-btn:active {
            transform: translateY(0);
        }


        /* =========================
           RESPONSIVE DESIGN
        ========================= */

        @media (max-width: 950px) {

            .nav-container {
                padding: 0 25px;
            }

            .nav-links {
                gap: 20px;
                margin-left: 35px;
            }

            .welcome-text {
                display: none;
            }

        }


        @media (max-width: 700px) {

            .navbar {
                height: auto;
                padding: 18px 0;
            }

            .nav-container {
                flex-wrap: wrap;
                gap: 18px;
            }

            .nav-links {
                order: 3;

                width: 100%;

                margin-left: 0;

                justify-content: center;
            }

            .maintenance-page {
                padding-top: 45px;
            }

            .page-heading h1 {
                font-size: 30px;
            }

            .booking-card {
                padding: 28px 22px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .form-footer {
                flex-direction: column;
                align-items: stretch;
            }

            .submit-btn {
                justify-content: center;
            }

        }


        @media (max-width: 480px) {

            .logo {
                font-size: 20px;
            }

            .nav-links {
                gap: 14px;
                flex-wrap: wrap;
            }

            .nav-links a {
                font-size: 13px;
            }

            .maintenance-btn {
                padding: 12px 15px;
                font-size: 12px;
            }

            .page-heading h1 {
                font-size: 27px;
            }

        }

        </style>
    </head>
    <body>
        <nav class="nav">
        <div class="shell">

            <a class="brand" href="index.jsp">CARVERSE</a>

            <div class="navlinks">
                <a class="active" href="index.jsp">Explore</a>
                <a href="car-search.jsp">New Cars</a>
                <a href="compare.jsp">Compare</a>
                <a href="#ownership">Ownership</a>
            </div>

            <%
                String userName = (String) session.getAttribute("USERNAME");
                String userId = (String) session.getAttribute("USERID");

                if (userName == null || userId == null) {
            %>

                <!-- User is not logged in -->
                <a class="btn btn-outline" href="login.html">Sign in</a>

                <a class="btn btn-primary" href="user_registration.html">
                    Sign up →
                </a>

            <%
                } else {
            %>

                <!-- Logged-in user -->
                <span class="user-name">
                    Welcome, <%= userName %>
                </span>

            <%
                }
            %>

            <!-- Book Maintenance Button -->
            <a class="btn btn-primary" href="Book_maintenance.jsp">
                Book Maintenance →
            </a>

        </div>
    </nav>
            
            <!-- ================= MAIN CONTENT ================= -->

    <main class="maintenance-page">

        <section class="booking-container">


            <!-- PAGE HEADING -->

            <div class="page-heading">

                <p class="section-tag">
                    CAR CARE
                </p>

                <h1>
                    Book Your Maintenance
                </h1>

                <p>
                    Keep your car performing at its best. Tell us what your
                    vehicle needs, and we'll help you schedule the right service.
                </p>

            </div>


            <!-- BOOKING FORM -->

            <div class="booking-card">

                <form action="Maintenance_User" method="post">


                    <div class="form-grid">


                        <!-- CAR MODEL NAME -->

                        <div class="form-group">

                            <label for="carModel">
                                Car Model Name
                            </label>

                            <input
                                type="text"
                                id="carModel"
                                name="carModel"
                                placeholder="e.g. Hyundai Creta"
                                required
                            >

                        </div>


                        <!-- MAINTENANCE TYPE -->

                        <div class="form-group">

                            <label for="maintenanceType">
                                Maintenance Type
                            </label>

                            <select
                                id="maintenanceType"
                                name="maintenanceType"
                                required
                            >

                                <option value="" disabled selected>
                                    Select maintenance type
                                </option>

                                <option value="regular-service">
                                    Regular Service
                                </option>

                                <option value="oil-change">
                                    Oil Change
                                </option>

                                <option value="engine-maintenance">
                                    Engine Maintenance
                                </option>

                                <option value="brake-service">
                                    Brake Service
                                </option>

                                <option value="tyre-service">
                                    Tyre Service
                                </option>

                                <option value="battery-service">
                                    Battery Service
                                </option>

                                <option value="ac-service">
                                    AC Service
                                </option>

                                <option value="general-repair">
                                    General Repair
                                </option>

                            </select>

                        </div>


                        <!-- CAR PURCHASE YEAR -->

                        <div class="form-group">

                            <label for="purchaseYear">
                                Car Purchase Year
                            </label>

                            <input
                                type="number"
                                id="purchaseYear"
                                name="purchaseYear"
                                placeholder="e.g. 2023"
                                min="1900"
                                max="2030"
                                required
                            >

                        </div>


                        <!-- LAST MAINTENANCE DATE -->

                        <div class="form-group">

                            <label for="lastMaintenance">
                                Last Maintenance Date
                            </label>

                            <input
                                type="date"
                                id="lastMaintenance"
                                name="lastMaintenance"
                                required
                            >

                        </div>

                    </div>


                    <!-- DESCRIPTION -->

                    <div class="form-group">

                        <label for="description">
                            Describe Your Maintenance Requirement
                        </label>

                        <textarea
                            id="description"
                            name="description"
                            rows="6"
                            placeholder="Tell us about any issues, unusual sounds, warning lights, or maintenance requirements..."
                            required
                        ></textarea>

                    </div>


                    <!-- FORM FOOTER -->

                    <div class="form-footer">

                        <p class="form-note">
                            Our team will review your request and get back to you.
                        </p>


                        <button type="submit" class="submit-btn">

                            Book Maintenance

                            <span>→</span>

                        </button>

                    </div>

                </form>

            </div>

        </section>

    </main>
        
    </body>
</html>
