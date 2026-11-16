<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.servlet.BookingDetail" %>
<%@ page import="com.servlet.load_user" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    load_user user = (load_user) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>CarVerse | My Profile</title>
    <link rel="stylesheet" href="assets/css/common.css">

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

        /* ================= BOOKINGS SECTION ================= */

        .section-gap {
            margin-top: 45px;
        }

        .booking-card {
            background: var(--white);
            border: 1px solid var(--border);
            padding: 25px 35px;
            margin-bottom: 15px;
        }

        .booking-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 15px;
        }

        .booking-id {
            font-size: 15px;
            font-weight: 800;
            text-transform: uppercase;
        }

        .booking-amount {
            font-size: 15px;
            font-weight: 800;
            color: #7dbd00;
        }

        .booking-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            gap: 20px;
        }

        .no-bookings {
            background: var(--white);
            border: 1px solid var(--border);
            padding: 35px;
            text-align: center;
            color: var(--grey);
            font-size: 13px;
        }

        /* ================= BOTTOM ================= */

        .bottom-text {
            margin-top: 40px;
            text-align: center;
            color: var(--grey);
            font-size: 11px;
        }

        /* ================= FEEDBACK BUTTON ================= */

        .feedback-btn {
            background-color: #198754;
            color: white;
            border: none;
            padding: 11px 20px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            white-space: nowrap;
        }

        .feedback-btn:hover {
            background-color: #146c43;
            transform: translateY(-2px);
        }

        /* ================= FEEDBACK MODAL ================= */

        .feedback-modal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.55);
            justify-content: center;
            align-items: center;
        }

        .feedback-popup {
            position: relative;
            width: 420px;
            max-width: 90%;
            background: white;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
            animation: popupAnimation 0.3s ease;
        }

        @keyframes popupAnimation {
            from {
                opacity: 0;
                transform: scale(0.9) translateY(-20px);
            }
            to {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        .feedback-popup h2 {
            margin: 0 0 6px;
            color: #198754;
            font-size: 24px;
        }

        .feedback-popup p {
            margin-bottom: 22px;
            color: #666;
            font-size: 14px;
        }

        .close-btn {
            position: absolute;
            top: 12px;
            right: 18px;
            font-size: 28px;
            color: #777;
            cursor: pointer;
            transition: 0.2s;
        }

        .close-btn:hover {
            color: #dc3545;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 18px;
        }

        .form-group label {
            margin-bottom: 7px;
            font-size: 14px;
            font-weight: 600;
            color: #333;
        }

        .form-group input {
            padding: 11px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 14px;
            outline: none;
        }

        .form-group textarea {
            height: 110px;
            padding: 11px;
            border: 1px solid #ddd;
            border-radius: 7px;
            font-size: 14px;
            resize: vertical;
            outline: none;
            font-family: inherit;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: #198754;
            box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.12);
        }

        .popup-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 22px;
        }

        .cancel-btn {
            background: #e9ecef;
            color: #333;
            border: none;
            padding: 10px 18px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: 600;
        }

        .cancel-btn:hover {
            background: #dee2e6;
        }

        .submit-btn {
            background: #198754;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 7px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
        }

        .submit-btn:hover {
            background: #146c43;
            transform: translateY(-1px);
        }

        .feedback-status {
            margin-top: 14px;
            font-size: 13px;
            font-weight: 600;
            display: none;
        }

        .feedback-status.success {
            color: #198754;
            display: block;
        }

        .feedback-status.error {
            color: #dc3545;
            display: block;
        }

        /* ================= CANCEL BOOKING ================= */

        .booking-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 14px;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            gap: 12px;
            flex-wrap: wrap;
        }

        .cancel-status-badge {
            display: inline-block;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            padding: 4px 10px;
            border-radius: 20px;
        }

        .badge-none       { background: #f1f3f0; color: var(--grey); }
        .badge-requested  { background: #fff3cd; color: #856404; }
        .badge-approved   { background: #d1e7dd; color: #0a3622; }
        .badge-rejected   { background: #f8d7da; color: #58151c; }

        .cancel-booking-btn {
            background: transparent;
            color: #dc3545;
            border: 1.5px solid #dc3545;
            padding: 7px 16px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
            white-space: nowrap;
        }

        .cancel-booking-btn:hover {
            background: #dc3545;
            color: #fff;
        }

        .cancel-booking-btn:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        /* ================= CANCEL CONFIRMATION MODAL ================= */

        .confirm-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.55);
            justify-content: center;
            align-items: center;
        }

        .confirm-popup {
            position: relative;
            width: 400px;
            max-width: 92%;
            background: #fff;
            border-radius: 14px;
            padding: 30px 28px 24px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.25);
            animation: popupAnimation 0.25s ease;
        }

        .confirm-popup h3 {
            font-size: 20px;
            margin-bottom: 8px;
            color: #dc3545;
        }

        .confirm-popup p {
            font-size: 14px;
            color: #555;
            margin-bottom: 6px;
        }

        .confirm-popup .confirm-bid {
            font-weight: 700;
            color: var(--dark);
        }

        .confirm-popup .confirm-note {
            font-size: 12px;
            color: var(--grey);
            margin-top: 10px;
            margin-bottom: 20px;
        }

        .confirm-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .confirm-cancel-btn {
            background: #e9ecef;
            color: #333;
            border: none;
            padding: 9px 18px;
            border-radius: 7px;
            font-weight: 600;
            cursor: pointer;
            font-size: 13px;
        }

        .confirm-cancel-btn:hover { background: #dee2e6; }

        .confirm-proceed-btn {
            background: #dc3545;
            color: #fff;
            border: none;
            padding: 9px 18px;
            border-radius: 7px;
            font-weight: 600;
            cursor: pointer;
            font-size: 13px;
            transition: background 0.2s;
        }

        .confirm-proceed-btn:hover { background: #b02a37; }

        /* ================= TOAST NOTIFICATION ================= */

        .toast {
            position: fixed;
            bottom: 28px;
            right: 28px;
            padding: 13px 20px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            color: #fff;
            z-index: 11000;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
            max-width: 320px;
        }

        .toast.show { opacity: 1; }
        .toast-success { background: #198754; }
        .toast-warn    { background: #856404; }
        .toast-error   { background: #dc3545; }

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

            .booking-card {
                padding: 20px;
            }

            .page-header {
                flex-direction: column;
                gap: 15px;
            }

            .feedback-popup {
                padding: 22px;
                width: 90%;
            }
        }

    </style>

</head>

<body>

<!-- ================= NAVBAR ================= -->

<%@ include file="/WEB-INF/jspf/customer-nav.jspf" %>

<!-- ================= MAIN CONTENT ================= -->

<div class="container">

    <!-- PAGE HEADER -->

    <div class="page-header" style="display: flex; justify-content: space-between; align-items: flex-start;">
        <div>
            <small>Account</small>
            <h1>My Profile</h1>
            <p>Your account details on file with CarVerse.</p>
        </div>

        <button
            type="button"
            class="feedback-btn"
            onclick="openFeedbackPopup()">
            Give Feedback
        </button>
    </div>

    <!-- PROFILE CARD -->

    <div class="profile-card">

        <div class="card-label">Account Details</div>

        <h2><%= user.getU_name() %></h2>

        <div class="profile-details">

            <div class="detail">
                <div class="detail-label">Email</div>
                <div class="detail-value"><%= user.getU_email() %></div>
            </div>

            <div class="detail">
                <div class="detail-label">Contact No.</div>
                <div class="detail-value"><%= user.getU_cont() %></div>
            </div>

            <div class="detail">
                <div class="detail-label">Address</div>
                <div class="detail-value"><%= user.getU_add() %></div>
            </div>

        </div>

    </div>

    <!-- ================= BOOKINGS SECTION ================= -->

    <div class="section-gap">

        <div class="page-header">
            <small>History</small>
            <h1 style="font-size: 26px;">My Bookings</h1>
            <p>Cars you've booked through CarVerse.</p>
        </div>

        <%
            @SuppressWarnings("unchecked")
            List<BookingDetail> bookings = (List<BookingDetail>) request.getAttribute("bookings");

            if (bookings != null && !bookings.isEmpty()) {
                NumberFormat currencyFmt = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));

                for (BookingDetail booking : bookings) {
        %>

                    <div class="booking-card">

                        <div class="booking-top">
                            <div class="booking-id">Booking #<%= booking.getBookingId() %></div>
                            <div class="booking-amount"><%= currencyFmt.format(booking.getTotalAmount()) %></div>
                        </div>

                        <div class="booking-row">
                            <div class="detail-label">Car ID</div>
                            <div class="detail-value"><%= booking.getCarId() %></div>
                        </div>

                        <div class="booking-row">
                            <div class="detail-label">Pickup Location</div>
                            <div class="detail-value"><%= booking.getPickupLocation() %></div>
                        </div>

                        <div class="booking-row">
                            <div class="detail-label">Drop Location</div>
                            <div class="detail-value"><%= booking.getDropLocation() %></div>
                        </div>

                        <%
                            String cancelStatus = booking.getCancellationStatus();
                            if (cancelStatus == null) cancelStatus = "NONE";
                            String badgeClass;
                            String badgeLabel;
                            switch (cancelStatus) {
                                case "REQUESTED": badgeClass = "badge-requested"; badgeLabel = "Cancellation Requested"; break;
                                case "APPROVED":  badgeClass = "badge-approved";  badgeLabel = "Cancellation Approved";  break;
                                case "REJECTED":  badgeClass = "badge-rejected";  badgeLabel = "Cancellation Rejected";  break;
                                default:          badgeClass = "badge-none";      badgeLabel = "Active";                 break;
                            }
                            boolean canRequestCancel = "NONE".equals(cancelStatus);
                        %>

                        <div class="booking-footer">
                            <span class="cancel-status-badge <%= badgeClass %>"><%= badgeLabel %></span>
                            <% if (canRequestCancel) { %>
                            <button
                                type="button"
                                class="cancel-booking-btn"
                                onclick="openCancelConfirm('<%= booking.getBookingId() %>')">
                                Cancel Booking
                            </button>
                            <% } %>
                        </div>

                    </div>

        <%
                }
            } else {
        %>
                <div class="no-bookings">
                    You haven't booked any cars yet.
                </div>
        <%
            }
        %>

    </div>

    <!-- BOTTOM TEXT -->

    <div class="bottom-text">
        CarVerse • Find Your Drive
    </div>

</div>

<!-- ================= FEEDBACK MODAL (built directly into this page) ================= -->

<div id="feedbackModal" class="feedback-modal">

    <div class="feedback-popup">

        <span class="close-btn" onclick="closeFeedbackPopup()">&times;</span>

        <h2>Share Your Feedback</h2>
        <p>Tell us what you think about CarVerse.</p>

        <form id="feedbackForm">

            <div class="form-group">
                <label for="title">Feedback Title</label>
                <input
                    type="text"
                    id="title"
                    name="title"
                    placeholder="Enter feedback title"
                    required
                    maxlength="100">
            </div>

            <div class="form-group">
                <label for="content">Your Feedback</label>
                <textarea
                    id="content"
                    name="content"
                    placeholder="Write your feedback here..."
                    required
                    maxlength="1000"></textarea>
            </div>

            <div id="feedbackStatus" class="feedback-status"></div>

            <div class="popup-buttons">
                <button type="button" class="cancel-btn" onclick="closeFeedbackPopup()">Cancel</button>
                <button type="submit" class="submit-btn" id="feedbackSubmitBtn">Submit Feedback</button>
            </div>

        </form>

    </div>

</div>

<!-- ================= CANCEL CONFIRMATION MODAL ================= -->

<div id="cancelConfirmModal" class="confirm-modal">
    <div class="confirm-popup">
        <h3>Cancel Booking?</h3>
        <p>Are you sure you want to cancel booking <span class="confirm-bid" id="confirmBookingId"></span>?</p>
        <p class="confirm-note">Your cancellation request will be sent to the business partner for approval.</p>
        <div class="confirm-actions">
            <button type="button" class="confirm-cancel-btn" onclick="closeCancelConfirm()">No, Keep It</button>
            <button type="button" class="confirm-proceed-btn" onclick="proceedCancel()">Yes, Cancel</button>
        </div>
    </div>
</div>

<!-- ================= TOAST NOTIFICATION ================= -->

<div id="toast" class="toast"></div>

<script>

    function openFeedbackPopup() {
        document.getElementById("feedbackModal").style.display = "flex";
    }

    function closeFeedbackPopup() {
        document.getElementById("feedbackModal").style.display = "none";
        document.getElementById("feedbackForm").reset();
        var status = document.getElementById("feedbackStatus");
        status.className = "feedback-status";
        status.textContent = "";
    }

    // close when clicking outside the popup box — handled by window.addEventListener below

    // submit via fetch so the page doesn't navigate away to a blank "success" page
    document.getElementById("feedbackForm").addEventListener("submit", function(e) {
        e.preventDefault();

        var title = document.getElementById("title").value.trim();
        var content = document.getElementById("content").value.trim();
        var status = document.getElementById("feedbackStatus");
        var submitBtn = document.getElementById("feedbackSubmitBtn");

        if (title === "" || content === "") {
            status.className = "feedback-status error";
            status.textContent = "Please fill in both fields.";
            return;
        }

        submitBtn.disabled = true;
        submitBtn.textContent = "Submitting...";

        var params = new URLSearchParams();
        params.append("title", title);
        params.append("content", content);

        fetch("User_feed", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: params.toString()
        })
        .then(function(res) { return res.text(); })
        .then(function(text) {
            submitBtn.disabled = false;
            submitBtn.textContent = "Submit Feedback";

            if (text.trim() === "success") {
                status.className = "feedback-status success";
                status.textContent = "Thanks! Your feedback was submitted.";
                document.getElementById("feedbackForm").reset();
                setTimeout(closeFeedbackPopup, 1500);
            } else {
                status.className = "feedback-status error";
                status.textContent = "Something went wrong. Please try again.";
            }
        })
        .catch(function() {
            submitBtn.disabled = false;
            submitBtn.textContent = "Submit Feedback";
            status.className = "feedback-status error";
            status.textContent = "Network error. Please try again.";
        });
    });

    // ================= CANCEL BOOKING CONFIRMATION + SUBMISSION =================

    let selectedBookingId = null;

    function openCancelConfirm(bookingId) {
        selectedBookingId = bookingId;
        document.getElementById("confirmBookingId").textContent = bookingId;
        document.getElementById("cancelConfirmModal").style.display = "flex";
    }

    function closeCancelConfirm() {
        document.getElementById("cancelConfirmModal").style.display = "none";
        selectedBookingId = null;
    }

    function proceedCancel() {
        if (!selectedBookingId) return;

        var form = document.createElement("form");
        form.method = "POST";
        form.action = "view_profile";

        var actionInput = document.createElement("input");
        actionInput.type = "hidden";
        actionInput.name = "action";
        actionInput.value = "cancelBooking";
        form.appendChild(actionInput);

        var bidInput = document.createElement("input");
        bidInput.type = "hidden";
        bidInput.name = "bookingId";
        bidInput.value = selectedBookingId;
        form.appendChild(bidInput);

        document.body.appendChild(form);
        form.submit();
    }

    // Close modal when clicking outside
    window.addEventListener("click", function(event) {
        var feedbackModal = document.getElementById("feedbackModal");
        var cancelModal   = document.getElementById("cancelConfirmModal");
        if (event.target === feedbackModal) {
            closeFeedbackPopup();
        }
        if (event.target === cancelModal) {
            closeCancelConfirm();
        }
    });

    // ================= TOAST NOTIFICATION =================

    function showToast(message, type) {
        var toast = document.getElementById("toast");
        toast.textContent = message;
        toast.className = "toast show toast-" + type;
        setTimeout(function() {
            toast.className = "toast";
        }, 4000);
    }

    // Check URL params for cancel action result
    (function() {
        var params = new URLSearchParams(window.location.search);
        var cancelResult = params.get("cancel");
        var bid = params.get("bid");
        if (cancelResult === "success") {
            showToast("Cancellation request submitted for booking " + (bid || ""), "success");
        } else if (cancelResult === "already") {
            showToast("Booking " + (bid || "") + " already has a cancellation request.", "warn");
        } else if (cancelResult === "error") {
            showToast("Failed to submit cancellation request. Try again.", "error");
        }
    })();

</script>

</body>
</html>