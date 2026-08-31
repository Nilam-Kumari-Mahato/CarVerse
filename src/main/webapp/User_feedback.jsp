<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<!-- =========================
     FEEDBACK BUTTON
========================= -->

<button type="button" class="feedback-btn" onclick="openFeedbackPopup()">
    💬 Give Feedback
</button>

<!-- =========================
     FEEDBACK POPUP
========================= -->

<div id="feedbackModal" class="feedback-modal">

```
<div class="feedback-popup">

    <!-- Close Button -->
    <span class="close-btn" onclick="closeFeedbackPopup()">&times;</span>

    <h2>Car Feedback</h2>
    <p>Share your thoughts about this car.</p>

    <form action="User_feed" method="post">

        <!-- Car ID can be passed automatically from the specification page -->
        <input type="hidden" name="carId" value="<%= request.getParameter("carId") %>">

        <!-- Feedback Title -->
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


        <!-- Feedback Content -->
        <div class="form-group">
            <label for="content">Your Feedback</label>

            <textarea
                id="content"
                name="content"
                placeholder="Write your feedback here..."
                required
                maxlength="1000"></textarea>
        </div>


        <!-- Buttons -->
        <div class="popup-buttons">

            <button
                type="button"
                class="cancel-btn"
                onclick="closeFeedbackPopup()">
                Cancel
            </button>

            <button
                type="submit"
                class="submit-btn">
                Submit Feedback
            </button>

        </div>

    </form>

</div>
```

</div>

<!-- =========================
     CSS
========================= -->

<style>

    /* Feedback Button */
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
    }

    .feedback-btn:hover {
        background-color: #146c43;
        transform: translateY(-2px);
    }


    /* Modal Background */
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


    /* Popup Box */
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


    /* Popup Animation */
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


    /* Heading */
    .feedback-popup h2 {
        margin: 0 0 6px;

        color: #198754;

        font-size: 24px;
    }


    /* Description */
    .feedback-popup p {
        margin-bottom: 22px;

        color: #666;

        font-size: 14px;
    }


    /* Close Button */
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


    /* Form Group */
    .form-group {

        display: flex;

        flex-direction: column;

        margin-bottom: 18px;
    }


    /* Labels */
    .form-group label {

        margin-bottom: 7px;

        font-size: 14px;

        font-weight: 600;

        color: #333;
    }


    /* Input */
    .form-group input {

        padding: 11px;

        border: 1px solid #ddd;

        border-radius: 7px;

        font-size: 14px;

        outline: none;
    }


    /* Textarea */
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


    /* Focus Effect */
    .form-group input:focus,
    .form-group textarea:focus {

        border-color: #198754;

        box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.12);
    }


    /* Buttons */
    .popup-buttons {

        display: flex;

        justify-content: flex-end;

        gap: 10px;

        margin-top: 22px;
    }


    /* Cancel */
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


    /* Submit */
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


    /* Mobile Responsive */
    @media (max-width: 480px) {

        .feedback-popup {

            padding: 22px;

            width: 90%;
        }

    }

</style>

<!-- =========================
     JAVASCRIPT
========================= -->

<script>

    function openFeedbackPopup() {

        document.getElementById("feedbackModal").style.display = "flex";

    }


    function closeFeedbackPopup() {

        document.getElementById("feedbackModal").style.display = "none";

    }


    /* Close popup when clicking outside */

    window.onclick = function(event) {

        const modal = document.getElementById("feedbackModal");

        if (event.target === modal) {

            closeFeedbackPopup();

        }

    }

</script>
