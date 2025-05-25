<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.event_booking_project_90.model.Photography" %>
<%@ page import="com.example.event_booking_project_90.util.PhotoEventFileHandler" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>LensLoom</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(120deg, #e3f0ff 0%, #f5f7fa 100%);
            min-height: 100vh;
        }
        header {
            background: #232946;
            color: white;
            text-align: left;
            padding: 0;
            position: relative;
            min-height: 72px;
            box-shadow: 0 4px 16px rgba(33,150,243,0.10);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header-title {
            font-size: 2.1em;
            font-weight: bold;
            letter-spacing: 1px;
            margin-left: 38px;
            margin-top: 0;
            margin-bottom: 0;
            display: inline-block;
            vertical-align: middle;
            text-shadow: 0 2px 8px rgba(33,150,243,0.08);
            animation: fadeInLeft 0.7s;
            text-align: center;
            width: 100%;
        }
        .header-actions {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-right: 38px;
            animation: fadeInRight 0.7s;
        }
        .header-actions .view-btn, .header-actions .logout-btn {
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 26px;
            font-size: 1em;
            cursor: pointer;
            font-weight: bold;
            margin-left: 6px;
            margin-right: 0;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
            transition: background 0.18s, box-shadow 0.18s, transform 0.18s;
            outline: none;
            white-space: nowrap;
            text-decoration: none;
            display: inline-block;
        }
        .header-actions .view-btn:hover, .header-actions .logout-btn:hover {
            background: #2196f3;
            box-shadow: 0 4px 16px rgba(33,150,243,0.15);
            transform: scale(1.04);
        }
        .header-actions .logout-btn {
            background: #f44336;
            color: #fff;
            border-radius: 6px;
            padding: 10px 26px;
            font-size: 1em;
            font-weight: bold;
            margin-left: 6px;
            margin-right: 0;
            box-shadow: 0 2px 8px rgba(244,67,54,0.08);
            border: none;
            cursor: pointer;
            transition: background 0.18s, box-shadow 0.18s, transform 0.18s;
            outline: none;
            white-space: nowrap;
            text-decoration: none;
            display: inline-block;
        }
        .header-actions .logout-btn:hover {
            background: #c62828;
            box-shadow: 0 4px 16px rgba(244,67,54,0.15);
            transform: scale(1.04);
        }
        .welcome-user {
            background: #1769aa;
            color: #fff;
            font-size: 16px;
            font-weight: bold;
            border-radius: 20px;
            padding: 2px 35px;
            margin-right: 6px;
            display: flex;
            align-items: center;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
            letter-spacing: 0.5px;
            animation: fadeInDown 0.8s;
        }


        /* Our Services and Ratings Section */
        .section-title {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            font-size: 1.6em;
            color: #2196F3;
            letter-spacing: 1px;
            text-align: center;
            font-weight: bold;
        }
        .services-cards {
            display: flex;
            justify-content: center;
            gap: 36px;
            flex-wrap: wrap;
            margin-bottom: 40px;
        }
        .service-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(33,150,243,0.09);
            padding: 32px 28px;
            min-width: 220px;
            max-width: 270px;
            text-align: center;
            transition: transform 0.18s, box-shadow 0.18s;
            animation: fadeInCard 1.2s;
        }
        .service-card:hover {
            transform: translateY(-8px) scale(1.04);
            box-shadow: 0 8px 32px rgba(33,150,243,0.18);
        }
        .service-icon {
            font-size: 2.5em;
            color: #2196F3;
            margin-bottom: 12px;
        }
        .service-title {
            font-size: 1.18em;
            font-weight: bold;
            margin-bottom: 8px;
            color: #232946;
        }
        .service-desc {
            color: #555;
            font-size: 1em;
        }
        .ratings-cards {
            display: flex;
            justify-content: center;
            gap: 36px;
            flex-wrap: wrap;
            margin-bottom: 60px;
        }
        .rating-card {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(33,150,243,0.09);
            padding: 28px 24px 22px 24px;
            min-width: 220px;
            max-width: 270px;
            text-align: center;
            transition: transform 0.18s, box-shadow 0.18s;
            animation: fadeInCard 1.3s;
        }
        .rating-card:hover {
            transform: translateY(-8px) scale(1.04);
            box-shadow: 0 8px 32px rgba(33,150,243,0.18);
        }
        .rating-avatar {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: #e3f2fd;
            margin: 0 auto 10px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2em;
            color: #2196F3;
        }
        .rating-stars {
            color: #FFD700;
            font-size: 1.2em;
            margin-bottom: 8px;
        }
        .rating-name {
            font-weight: bold;
            color: #232946;
            margin-bottom: 6px;
        }
        .rating-text {
            color: #555;
            font-size: 1em;
        }
        .container {
            max-width: 1200px;
            margin: 32px auto 0 auto;
            padding: 32px 24px 24px 24px;
            background: rgba(255,255,255,0.98);
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(33,150,243,0.10);
            animation: fadeInUp 0.8s;
        }
        .events-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 28px;
            margin-top: 20px;
        }
        .event-card {
            border: none;
            border-radius: 18px;
            padding: 0 0 22px 0;
            box-shadow: 0 8px 32px rgba(33,150,243,0.10);
            background: linear-gradient(120deg, #f7fafc 60%, #e3f2fd 100%);
            transition: box-shadow 0.18s, transform 0.18s;
            animation: fadeInCard 0.7s;
            position: relative;
            overflow: hidden;
            margin-bottom: 8px;
        }
        .event-card:hover {
            box-shadow: 0 16px 40px rgba(33,150,243,0.18);
            transform: translateY(-6px) scale(1.03);
        }
        .event-card h3 {
            margin-top: 0;
            color: #2196F3;
            border-bottom: 1px solid #e3f2fd;
            padding: 18px 0 10px 0;
            font-size: 1.35em;
            letter-spacing: 0.5px;
            margin-left: 0;
            margin-right: 0;
            text-align: center;
            font-weight: bold;
        }
        .event-card p {
            margin: 8px 22px;
            color: #232946;
            font-size: 1.08em;
        }
        .event-card .event-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0 22px 8px 22px;
            font-size: 0.98em;
            color: #1769aa;
        }
        .event-actions {
            margin-top: 18px;
            display: flex;
            justify-content: center;
            gap: 16px;
        }
        .event-action-btn {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 28px;
            font-size: 1em;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
            transition: background 0.18s, box-shadow 0.18s, transform 0.18s;
            outline: none;
            white-space: nowrap;
            text-decoration: none;
            display: inline-block;
        }
        .event-action-btn:hover {
            background: #1769aa;
            box-shadow: 0 4px 16px rgba(33,150,243,0.15);
            transform: scale(1.05);
        }
        #eventModal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            overflow-y: auto;
            animation: fadeIn 0.4s;
        }
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
            box-shadow: 0 4px 16px rgba(33,150,243,0.18);
            max-height: 90vh;
            overflow-y: auto;
            animation: fadeInUp 0.6s;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .close {
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.18s;
        }
        .close:hover {
            color: #f44336;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        @keyframes fadeInLeft {
            from { opacity: 0; transform: translateX(-40px);}
            to { opacity: 1; transform: translateX(0);}
        }
        @keyframes fadeInRight {
            from { opacity: 0; transform: translateX(40px);}
            to { opacity: 1; transform: translateX(0);}
        }
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInCard {
            from { opacity: 0; transform: scale(0.95);}
            to { opacity: 1; transform: scale(1);}
        }
        @keyframes fadeIn {
            from { opacity: 0;}
            to { opacity: 1;}
        }
        @media (max-width: 900px) {
            .container {
                padding: 12px 2px 12px 2px;
            }
            .header-title {
                margin-left: 10px;
                font-size: 1.1em;
            }
            .header-actions {
                margin-right: 10px;
                gap: 8px;
            }
        }
    </style>
    <script>
        function openModal() {
            document.getElementById('eventModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('eventModal').style.display = 'none';
        }

        // Close modal when clicking outside of it
        window.onclick = function(event) {
            var modal = document.getElementById('eventModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</head>
<body>
<%
    // Use the implicit 'session' object provided by JSP
    String username = null;
    if (session != null && session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }
%>
<header>
    <div style="display:flex;align-items:center;gap:16px;">
        <div style="width:44px;height:44px;border-radius:50%;background:#e3f2fd;display:flex;align-items:center;justify-content:center;font-size:2em;color:#2196F3;box-shadow:0 2px 8px rgba(33,150,243,0.12);margin-left:24px;">
            &#128247;
        </div>
        <span class="header-title" style="margin-left:0;margin-right:0;text-align:left;width:auto;">LensLoom</span>
    </div>
    <div class="header-actions">
        <span class="welcome-user">
            <% if (username != null && !username.trim().isEmpty()) { %>
                Welcome, <%= username %>!
            <% } else { %>
                Welcome!
            <% } %>
        </span>
        <a href="myBookings.jsp" class="view-btn">My Bookings</a>
        <a href="profile.jsp" class="view-btn">My Profile</a>
        <form action="LogoutServlet" method="post" style="display:inline;">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>
</header>



<!-- Event Cards Section (moved to top) -->
<div class="container">
    <h2 class="section-title">Photography Events</h2>
    <div class="events-container">
        <%
            List<Photography> events = PhotoEventFileHandler.getAllEvents();
            if (events != null && !events.isEmpty()) {
                for (Photography event : events) {
        %>
        <div class="event-card">
            <h3><%= event.getTitle() %></h3>
            <div class="event-meta">
                <span><strong>Date:</strong> <%= event.getDate() %></span>
                <span><strong>Location:</strong> <%= event.getLocation() %></span>
            </div>
            <div class="event-meta">
                <span><strong>Price:</strong> <%= event.getPrice() > 0 ? "Rs. " + String.format("%.2f", event.getPrice()) : "-" %></span>
            </div>
            <p><strong>Description:</strong> <%= 
                event.getDescription().length() > 100 ?
                    event.getDescription().substring(0, 100) + "..." :
                    event.getDescription()
            %></p>
            <div class="event-actions">
                <a href="eventDetails.jsp?eventId=<%= event.getId() %>" class="event-action-btn">View Details</a>
                <!-- Book Now button removed -->
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div style="grid-column: 1 / -1; text-align: center; padding: 40px 0;">
            <h3>No events found</h3>
            <p>Click the '+ Add Event' button to create your first photography event.</p>
        </div>
        <% } %>
    </div>
</div>

<!-- Our Services Section (moved to bottom) -->
<div class="section-title">Our Services</div>
<div class="services-cards">
    <div class="service-card">
        <div class="service-icon">&#128247;</div>
        <div class="service-title">Professional Photography</div>
        <div class="service-desc">Capture every moment with our skilled photographers for weddings, birthdays, and more.</div>
    </div>
    <div class="service-card">
        <div class="service-icon">&#127909;</div>
        <div class="service-title">Videography</div>
        <div class="service-desc">Relive your event with stunning videos shot by our expert videographers.</div>
    </div>
    <div class="service-card">
        <div class="service-icon">&#128663;</div>
        <div class="service-title">Drone Shots</div>
        <div class="service-desc">Get breathtaking aerial views and cinematic shots with our drone services.</div>
    </div>
    <div class="service-card">
        <div class="service-icon">&#128197;</div>
        <div class="service-title">Easy Booking</div>
        <div class="service-desc">Book your event in just a few clicks with our user-friendly platform.</div>
    </div>
</div>

<div class="section-title">What Our Customers Say</div>
<div class="ratings-cards">
    <div class="rating-card">
        <div class="rating-avatar">&#128100;</div>
        <div class="rating-stars">&#11088;&#11088;&#11088;&#11088;&#11088;</div>
        <div class="rating-name">Nimal Perera</div>
        <div class="rating-text">"Amazing service! The photographers were professional and friendly. Highly recommended."</div>
    </div>
    <div class="rating-card">
        <div class="rating-avatar">&#128105;</div>
        <div class="rating-stars">&#11088;&#11088;&#11088;&#11088;&#11088;</div>
        <div class="rating-name">Samanthi Silva</div>
        <div class="rating-text">"The drone shots made our wedding unforgettable. Booking was super easy and fast."</div>
    </div>
    <div class="rating-card">
        <div class="rating-avatar">&#128104;</div>
        <div class="rating-stars">&#11088;&#11088;&#11088;&#11088;&#11088;</div>
        <div class="rating-name">Kasun Fernando</div>
        <div class="rating-text">"Great experience from start to finish. Will definitely use this service again!"</div>
    </div>
</div>

<!-- Modal for adding events (removed) -->

<!-- Footer Section -->
<footer style="width:100%;background:#232946;color:#fff;text-align:center;padding:22px 0 16px 0;margin-top:48px;font-size:1.08em;letter-spacing:0.5px;box-shadow:0 -2px 8px rgba(33,150,243,0.07);">
    &copy; <%= java.time.Year.now() %> Photography Event Manager &mdash; All Rights Reserved.
</footer>
</body>
</html>
