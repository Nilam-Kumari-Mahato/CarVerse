
<%@ page contentType="text/html;charset=UTF-8" %>

<c:if test="${empty user}">
    <c:redirect url="login.html" />
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CarVerse | My Profile</title>

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        :root {
            --dark: #171b22;
            --lime: #9bea00;
            --background: #f6f7f5;
            --white: #ffffff;
            --grey: #747980;
            --border: #e2e4e1;
        }

        body {
            background: var(--background);
            color: var(--dark);
        }

        /* ================= NAVBAR ================= */

        .navbar {
            height: 70px;
            background: var(--white);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 7%;
            border-bottom: 1px solid var(--border);
        }

        .logo {
            text-decoration: none;
            color: var(--dark);
            font-size: 21px;
            font-weight: 800;
            letter-spacing: 1px;
        }

        .logo span {
            color: #7dbd00;
        }

        .nav-links {
            list-style: none;
            display: flex;
            gap: 30px;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--dark);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .nav-links a:hover {
            color: #7dbd00;
        }

        /* ================= MAIN ================= */

        .container {
            max-width: 650px;
            margin: auto;
            padding: 65px 25px;
        }

        /* ================= HEADER ================= */

        .page-header {
            margin-bottom: 40px;
        }

        .page-header small {
            color: #7dbd00;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .page-header h1 {
            margin-top: 8px;
            font-size: 34px;
            text-transform: uppercase;
            letter-spacing: -0.5px;
        }

        .page-header p {
            margin-top: 10px;
            color: var(--grey);
            font-size: 14px;
        }

        /* ================= PROFILE CARD ================= */

        .profile-card {
            background: var(--white);
            border: 1px solid var(--border);
            padding: 35px;
        }

        .card-label {
            color: #7dbd00;
            font-size: 10px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }

        .profile-card h2 {
            font-size: 26px;
            margin-bottom: 30px;
            text-transform: uppercase;
        }

        .profile-details {
            border-top: 1px solid var(--border);
        }

        .detail {
            display: flex;
            justify-content: space-between;
            padding: 17px 0;
            border-bottom: 1px solid var(--border);
            gap: 20px;
        }

        .detail-label {
            color: var(--grey);
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .detail-value {
            font-size: 13px;
            font-weight: 600;
            text-align: right;
        }

        /* ================= BOTTOM ================= */

        .bottom-text {
            margin-top: 40px;
            text-align: center;
            color: var(--grey);
            font-size: 11px;
        }

        /* ================= RESPONSIVE ================= */

        @media(max-width: 800px) {
            .nav-links {
                display: none;
            }
        }

        @media(max-width: 500px) {
            .navbar {
                padding: 0 25px;
            }

            .container {
                padding: 45px 20px;
            }

            .page-header h1 {
                font-size: 28px;
            }

            .profile-card {
                padding: 25px;
            }
        }

    </style>

</head>

<body>

<!-- ================= NAVBAR ================= -->

<nav class="navbar">

    <a href="index.jsp" class="logo">
        CAR<span>VERSE</span>
    </a>

    <ul class="nav-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="CarListServlet">Cars</a></li>
        <li><a href="Maintenance.jsp">Maintenance</a></li>
        <li><a href="ProfileServlet">Profile</a></li>
    </ul>

</nav>

<!-- ================= MAIN CONTENT ================= -->

<div class="container">

    <!-- PAGE HEADER -->

    <div class="page-header">
        <small>Account</small>
        <h1>My Profile</h1>
        <p>Your account details on file with CarVerse.</p>
    </div>

    <!-- PROFILE CARD -->

    <div class="profile-card">

        <div class="card-label">Account Details</div>

        <h2>${user.u_name}</h2>

        <div class="profile-details">

            <div class="detail">
                <div class="detail-label">User ID</div>
                <div class="detail-value">${user.u_id}</div>
            </div>

            <div class="detail">
                <div class="detail-label">Email</div>
                <div class="detail-value">${user.u_email}</div>
            </div>

            <div class="detail">
                <div class="detail-label">Contact No.</div>
                <div class="detail-value">${user.u_cont}</div>
            </div>

            <div class="detail">
                <div class="detail-label">Address</div>
                <div class="detail-value">${user.u_add}</div>
            </div>

            <div class="detail">
                <div class="detail-label">Joined On</div>
                <div class="detail-value">${user.u_createdat}</div>
            </div>

        </div>

    </div>

    <!-- BOTTOM TEXT -->

    <div class="bottom-text">
        CarVerse • Find Your Drive
    </div>

</div>

</body>
</html>