<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.util.*, util.BookingFileHandler" %>
<%@ page import="com.example.event_booking_project_90.model.Photography" %>
<%@ page import="com.example.event_booking_project_90.util.PhotoEventFileHandler" %>
<%
    String eventId = request.getParameter("eventId");
    String eventTitle = request.getParameter("eventTitle");
    String username = request.getParameter("username");
    String bookingDate = request.getParameter("bookingDate");
    String[] serviceTypes = request.getParameterValues("serviceType");
    String bookingLocation = request.getParameter("bookingLocation");
    String price = request.getParameter("price"); // base price from event

    // --- Price Calculation Logic ---
    double basePrice = 0.0;
    if (price != null && !price.isEmpty()) {
        try {
            basePrice = Double.parseDouble(price);
        } catch (Exception e) {
            try {
                basePrice = Double.parseDouble(price.replaceAll("[^0-9.]", ""));
            } catch (Exception ex) {
                basePrice = 0.0;
            }
        }
    }
    double photographerPrice = 1500.00;
    double videographerPrice = 2500.00;
    double dronePrice = 4500.00;
    double totalPrice = basePrice;

    // Calculate total based on selected services
    if (serviceTypes != null && serviceTypes.length > 0) {
        boolean hasPhotographer = false, hasVideographer = false, hasDrone = false;
        for (String s : serviceTypes) {
            String normalized = s.trim().toLowerCase();
            if (normalized.equals("photographer") || normalized.equals("photographers") || normalized.equals("photographer shot")) hasPhotographer = true;
            if (normalized.equals("videographer") || normalized.equals("videographers") || normalized.equals("videographer shot")) hasVideographer = true;
            if (normalized.equals("drone") || normalized.equals("drone shot")) hasDrone = true;
        }
        if (hasPhotographer) totalPrice += photographerPrice;
        if (hasVideographer) totalPrice += videographerPrice;
        if (hasDrone) totalPrice += dronePrice;
    }
    String totalPriceStr = String.format("Rs. %.2f", totalPrice);
    // Generate a short booking ID (6 random uppercase alphanumeric chars)
    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    StringBuilder sb = new StringBuilder("BKG");
    Random rand = new Random();
    for (int i = 0; i < 6; i++) {
        sb.append(chars.charAt(rand.nextInt(chars.length())));
    }
    String bookingId = sb.toString();

    String serviceTypesStr = "";
    if (serviceTypes != null) {
        serviceTypesStr = String.join(", ", serviceTypes);
    }

    boolean bookingPlaced = false;
    String errorMsg = null;

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("cardNumber") != null) {
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");
        String cardExpiry = request.getParameter("cardExpiry");
        String cardCVC = request.getParameter("cardCVC");
        String billingAddress = request.getParameter("billingAddress");
        String billingCity = request.getParameter("billingCity");
        String billingZip = request.getParameter("billingZip");

        try {
            // Use BookingFileHandler to store booking in the correct file
            BookingFileHandler.addBooking(
                bookingId,
                username,
                eventId,
                eventTitle,
                bookingDate,
                serviceTypesStr,
                bookingLocation,
                billingAddress,
                billingCity,
                billingZip,
                "Pending"
            );
            bookingPlaced = true;
        } catch (Exception e) {
            errorMsg = "Booking failed. Please try again.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Complete Your Booking</title>
    <style>
        body {
            background: linear-gradient(120deg, #f8fafc 0%, #e3f0ff 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        .main-title {
            text-align: center;
            font-size: 2.4em;
            font-weight: bold;
            margin-top: 44px;
            margin-bottom: 10px;
            color: #232946;
            letter-spacing: 1px;
        }
        .subtitle {
            text-align: center;
            color: #666;
            font-size: 1.18em;
            margin-bottom: 38px;
        }
        .payment-flex {
            max-width: 1100px;
            margin: 0 auto 40px auto;
            display: flex;
            gap: 36px;
            align-items: flex-start;
            justify-content: center;
        }
        .order-summary-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(33,150,243,0.13);
            padding: 32px 28px 28px 28px;
            min-width: 340px;
            max-width: 370px;
            margin-bottom: 0;
            margin-top: 0;
            animation: fadeInLeft 0.8s;
            display: flex;
            flex-direction: column;
            align-items: stretch;
        }
        .order-summary-title {
            font-size: 1.25em;
            font-weight: bold;
            color: #232946;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .order-summary-title .icon {
            font-size: 1.3em;
            color: #4f46e5;
        }
        .order-summary-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 10px;
        }
        .order-summary-row .label {
            color: #888;
            font-size: 0.98em;
            min-width: 110px;
        }
        .order-summary-row .value {
            font-weight: bold;
            color: #232946;
            font-size: 1.05em;
        }
        .order-summary-res {
            color: #22c55e;
            font-size: 0.98em;
            font-weight: bold;
            background: #e0fbe6;
            border-radius: 8px;
            padding: 2px 10px;
            margin-bottom: 12px;
            display: inline-block;
        }
        .order-summary-img {
            width: 100%;
            border-radius: 12px;
            margin-bottom: 12px;
            object-fit: cover;
            height: 140px;
            background: #e3f2fd;
        }
        .order-summary-badge {
            position: absolute;
            top: 16px;
            left: 16px;
            background: #4f46e5;
            color: #fff;
            font-size: 0.92em;
            font-weight: bold;
            border-radius: 8px;
            padding: 4px 14px;
            z-index: 2;
            letter-spacing: 0.5px;
        }
        .order-summary-img-wrap {
            position: relative;
            margin-bottom: 18px;
        }
        .order-summary-total {
            margin-top: 18px;
            font-size: 1.18em;
            font-weight: bold;
            color: #232946;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-summary-total .price {
            color: #22c55e;
            font-size: 1.25em;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .payment-form-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(33,150,243,0.13);
            padding: 38px 38px 32px 38px;
            min-width: 340px;
            flex: 1 1 420px;
            animation: fadeInUp 0.8s;
        }
        .payment-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 22px;
        }
        .payment-header-icon {
            font-size: 1.5em;
            color: #2196F3;
            background: #e3f2fd;
            border-radius: 50%;
            padding: 10px 16px;
            box-shadow: 0 2px 8px #2196f322;
        }
        .payment-header-title {
            font-size: 1.18em;
            font-weight: bold;
            color: #232946;
            letter-spacing: 0.5px;
        }
        .card-icons {
            margin-left: 8px;
            font-size: 1.1em;
            color: #888;
            display: flex;
            gap: 4px;
        }
        .card-icons img {
            height: 26px;
            filter: drop-shadow(0 2px 8px #2196f322);
        }
        .form-row {
            display: flex;
            gap: 16px;
        }
        .form-group {
            margin-bottom: 18px;
            flex: 1;
        }
        .form-group label {
            font-weight: bold;
            color: #1769aa;
            display: block;
            margin-bottom: 7px;
            letter-spacing: 0.2px;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1.5px solid #bbb;
            border-radius: 6px;
            font-size: 1.08em;
            background: #f7fafc;
            transition: border 0.18s, box-shadow 0.18s;
        }
        .form-group input:focus {
            border: 1.5px solid #2196F3;
            box-shadow: 0 2px 8px #2196f322;
            outline: none;
        }
        .form-actions {
            text-align: center;
            margin-top: 22px;
        }
        .form-actions button {
            background: linear-gradient(90deg, #4f46e5 0%, #06b6d4 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 16px 0;
            font-size: 1.13em;
            cursor: pointer;
            width: 100%;
            font-weight: bold;
            margin-bottom: 10px;
            margin-top: 10px;
            box-shadow: 0 2px 8px #2196f344;
            transition: background 0.18s, transform 0.18s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .form-actions button svg {
            font-size: 1.2em;
        }
        .form-actions button:hover {
            background: #1769aa;
            transform: scale(1.03);
        }
        .form-actions button.cancel-btn {
            background: #ccc;
            color: #222;
            width: 100%;
            margin-top: 0;
            box-shadow: none;
        }
        .form-actions button.cancel-btn:hover {
            background: #bbb;
        }
        .success-msg {
            color: #2196F3;
            text-align: center;
            font-weight: bold;
            margin-bottom: 18px;
            font-size: 1.18em;
        }
        .error-msg {
            color: #f44336;
            text-align: center;
            font-weight: bold;
            margin-bottom: 18px;
            font-size: 1.1em;
        }
        .save-payment {
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .save-payment label {
            font-weight: normal;
            color: #444;
        }
        .payment-note {
            margin-top: 16px;
            color: #22c55e;
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .payment-note svg {
            font-size: 1.2em;
        }
        @keyframes fadeInLeft {
            from { opacity: 0; transform: translateX(-60px);}
            to { opacity: 1; transform: translateX(0);}
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInCard {
            from { opacity: 0; transform: scale(0.95);}
            to { opacity: 1; transform: scale(1);}
        }
        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-60px);}
            to { opacity: 1; transform: translateX(0);}
        }
        @media (max-width: 1100px) {
            .payment-flex { flex-direction: column; align-items: stretch; }
            .order-summary-card, .payment-form-card { max-width: 100%; min-width: 0; }
        }
        @media (max-width: 700px) {
            .payment-flex { padding: 0 4px; }
            .order-summary-card, .payment-form-card { padding: 16px 6px 16px 6px; }
        }
    </style>
    <script>
        // Live card preview
        function updateCardPreview() {
            document.getElementById('cardPreviewNumber').innerText =
                document.getElementById('cardNumber')?.value.replace(/(\d{4})/g, '$1 ').trim() || '•••• •••• •••• ••••';
            document.getElementById('cardPreviewName').innerText =
                document.getElementById('cardName')?.value || 'CARDHOLDER';
            document.getElementById('cardPreviewExpiry').innerText =
                document.getElementById('cardExpiry')?.value || 'MM/YY';
        }
        // Format card number input with spaces every 4 digits
        function formatCardNumber(input) {
            let value = input.value.replace(/\D/g, '').substring(0,16);
            let formatted = value.replace(/(.{4})/g, '$1 ').trim();
            input.value = formatted;
        }
        // Format expiry date as MM/YY
        function formatExpiry(input) {
            let value = input.value.replace(/\D/g, '').substring(0, 4);
            if (value.length > 2) {
                value = value.substring(0,2) + '/' + value.substring(2,4);
            }
            input.value = value;
        }
        document.addEventListener("DOMContentLoaded", function() {
            var number = document.getElementById('cardNumber');
            var name = document.getElementById('cardName');
            var expiry = document.getElementById('cardExpiry');
            if (number) number.addEventListener('input', updateCardPreview);
            if (name) name.addEventListener('input', updateCardPreview);
            if (expiry) expiry.addEventListener('input', updateCardPreview);
            updateCardPreview();
        });
    </script>
</head>
<body>
    <div class="main-title">Complete Your Booking</div>
    <div class="subtitle">You're just one step away from your amazing journey!</div>
    <div class="payment-flex">
        <!-- Left: Order Summary Card -->
        <div class="order-summary-card">
            <div class="order-summary-title">
                <span class="icon">&#128179;</span>
                Order Summary
            </div>
            <div class="order-summary-row">
                <span style="color:#22c55e;font-size:1em;">&#128278;</span>
                <span class="order-summary-res">Booking: <%= bookingId %></span>
            </div>
            <div class="order-summary-img-wrap">
                <span class="order-summary-badge">Standard Package</span>
                <img class="order-summary-img" src="https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80" alt="Package Image">
            </div>
            <div class="order-summary-row">
                <span class="label">Event</span>
                <span class="value"><%= eventTitle %></span>
            </div>
            <div class="order-summary-row">
                <span class="label">Location</span>
                <span class="value"><%= bookingLocation %></span>
            </div>
            <div class="order-summary-row">
                <span class="label">Date</span>
                <span class="value"><%= bookingDate %></span>
            </div>
            <div class="order-summary-row">
                <span class="label">Service(s)</span>
                <span class="value"><%= serviceTypesStr %></span>
            </div>
            <div class="order-summary-total">
                <span>Total Price</span>
                <span class="price"><%= totalPriceStr %></span>
            </div>
        </div>
        <!-- Right: Payment Form Card -->
        <div class="payment-form-card">
            <div class="payment-header">
                <span class="payment-header-icon">&#128179;</span>
                <span class="payment-header-title">Payment Details</span>
                <span class="card-icons">
                    <img src="https://img.icons8.com/color/32/000000/visa.png" alt="Visa">
                    <img src="https://img.icons8.com/color/32/000000/mastercard-logo.png" alt="Mastercard">
                    <img src="https://img.icons8.com/color/32/000000/amex.png" alt="Amex">
                </span>
            </div>
            <% if (bookingPlaced) { %>
                <div class="success-msg">Booking placed successfully!</div>
                <div class="payment-summary">
                    <label>Event:</label> <%= eventTitle %><br>
                    <label>Date:</label> <%= bookingDate %><br>
                    <label>Service(s):</label> <%= serviceTypesStr %><br>
                    <label>Location:</label> <%= bookingLocation %><br>
                    <label>Status:</label> Pending
                </div>
                <div style="text-align:center;">
                    <a href="myBookings.jsp" style="background:#2196F3;color:#fff;border:none;border-radius:4px;padding:10px 32px;text-decoration:none;">Go to Dashboard</a>
                </div>
            <% } else { %>
                <% if (errorMsg != null) { %>
                    <div class="error-msg"><%= errorMsg %></div>
                <% } %>
                <form method="post" autocomplete="off">
                    <input type="hidden" name="eventId" value="<%= eventId %>">
                    <input type="hidden" name="eventTitle" value="<%= eventTitle %>">
                    <input type="hidden" name="username" value="<%= username %>">
                    <input type="hidden" name="bookingDate" value="<%= bookingDate %>">
                    <% if (serviceTypes != null) {
                        for (String s : serviceTypes) { %>
                            <input type="hidden" name="serviceType" value="<%= s %>">
                    <%  }
                    } %>
                    <input type="hidden" name="bookingLocation" value="<%= bookingLocation %>">
                    <input type="hidden" name="price" value="<%= totalPriceStr %>">
                    <div class="form-group">
                        <label>Cardholder Name</label>
                        <input type="text" name="cardName" id="cardName" required placeholder="Name as it appears on your card">
                    </div>
                    <div class="form-group">
                        <label for="cardNumber">Card Number</label>
                        <div class="input-group"></div>
                        <input type="text" name="cardNumber" id="cardNumber" maxlength="19" pattern="[0-9 ]{13,19}" required placeholder="1234 5678 9012 3456" autocomplete="on" oninput="formatCardNumber(this)">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Expiration Date</label>
                            <input type="text" name="cardExpiry" id="cardExpiry" maxlength="5" pattern="[0-9]{2}/[0-9]{2}" required placeholder="MM/YY" autocomplete="off" oninput="formatExpiry(this)">
                        </div>
                        <div class="form-group">
                            <label>Security Code (CVV)</label>
                            <input type="password" name="cardCVC" maxlength="4" pattern="[0-9]{3,4}" required placeholder="123" autocomplete="off">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Billing Address</label>
                        <input type="text" name="billingAddress" required placeholder="Street Address">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>City</label>
                            <input type="text" name="billingCity" required placeholder="City">
                        </div>
                        <div class="form-group">
                            <label>ZIP/Postal Code</label>
                            <input type="text" name="billingZip" required placeholder="ZIP/Postal Code">
                        </div>
                    </div>
                    <div class="save-payment">
                        <input type="checkbox" name="savePayment" id="savePayment">
                        <label for="savePayment">Save my payment information for future bookings</label>
                    </div>
                    <div class="form-actions">
                        <button type="submit" id="payBtn">
                            <svg style="vertical-align:middle;" width="20" height="20" fill="currentColor" viewBox="0 0 20 20"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"></path><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"></path></svg>
                            Pay Securely <%= totalPriceStr %>
                        </button>
                        <button type="button" class="cancel-btn" onclick="window.location.href='myBookings.jsp'">Cancel</button>
                    </div>
                    <div class="payment-note">
                        <svg width="18" height="18" fill="#22c55e" viewBox="0 0 20 20"><path d="M10 18a8 8 0 100-16 8 8 0 000 16zm-1-7V7a1 1 0 112 0v4a1 1 0 01-2 0zm1 4a1.5 1.5 0 110-3 1.5 1.5 0 010 3z"></path></svg>
                        Your payment information is encrypted and secure. We never store your CVV code.
                    </div>
                </form>
            <% } %>
        </div>
    </div>

    <!-- Payment Success Popup -->
    <div id="paymentSuccessPopup" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(33,150,243,0.15);z-index:99999;align-items:center;justify-content:center;">
        <div style="background:#fff;max-width:340px;width:90%;margin:120px auto;padding:36px 24px 32px 24px;border-radius:16px;box-shadow:0 8px 32px rgba(33,150,243,0.18);text-align:center;position:relative;">
            <div style="font-size:3em;color:#4caf50;margin-bottom:12px;">&#10004;</div>
            <div style="font-size:1.3em;font-weight:bold;color:#2196F3;margin-bottom:10px;">Payment Successful!</div>
            <div style="color:#444;margin-bottom:18px;">Your booking has been placed.<br>Thank you for your payment.</div>
            <a href="myBookings.jsp" style="background:#2196F3;color:#fff;border:none;border-radius:4px;padding:10px 32px;text-decoration:none;display:inline-block;">Go to Dashboard</a>
        </div>
    </div>
    <script>
        // Show popup after payment (on bookingPlaced)
        <% if (bookingPlaced) { %>
        document.addEventListener("DOMContentLoaded", function() {
            document.querySelector('.payment-container').style.display = 'none';
            document.getElementById('paymentSuccessPopup').style.display = 'flex';
        });
        <% } %>
    </script>
</body>
</html>
