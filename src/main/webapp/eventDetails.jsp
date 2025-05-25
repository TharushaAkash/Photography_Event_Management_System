<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.event_booking_project_90.model.Photography" %>
<%@ page import="com.example.event_booking_project_90.util.PhotoEventFileHandler" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String eventId = request.getParameter("eventId");
    Photography event = null;
    if (eventId != null) {
        try {
            event = PhotoEventFileHandler.getEventById(eventId);
        } catch (Exception e) {
            event = null;
        }
    }
    // Get username for navbar
    String username = null;
    if (session != null && session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }

    double basePrice = event.getPrice();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Event Details</title>
    <style>
        body {
            background: linear-gradient(120deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .navbar {
            width: 100%;
            background: #333;
            color: #fff;
            padding: 0;
            margin: 0;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
            height: 60px;
        }
        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            padding: 0 30px;
        }
        .navbar-title {
            font-size: 1.5em;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .navbar-right {
            display: flex;
            align-items: center;
        }
        .welcome-message {
            margin-right: 24px;
            font-size: 1.1em;
            font-weight: bold;
        }
        .logout-btn {
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 16px;
            cursor: pointer;
            font-size: 15px;
        }
        .logout-btn:hover {
            background: #c62828;
        }
        .details-container {
            max-width: 600px;
            margin: 90px auto 0 auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(44,62,80,0.15);
            padding: 40px 32px 32px 32px;
            position: relative;
        }
        .back-btn {
            display: inline-block;
            margin-bottom: 24px;
            background: #2196F3;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 8px 18px;
            font-size: 15px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s;
            position: static;
        }
        .back-btn:hover {
            background: #1769aa;
        }
        .event-title {
            font-size: 2.2em;
            color: #222;
            margin-bottom: 12px;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .event-meta {
            color: #666;
            font-size: 1.1em;
            margin-bottom: 18px;
        }
        .event-description {
            font-size: 1.15em;
            color: #333;
            margin-bottom: 24px;
            line-height: 1.7;
            background: #f7fafc;
            border-radius: 8px;
            padding: 18px 16px;
            border-left: 4px solid #2196F3;
        }
        .event-info-list {
            list-style: none;
            padding: 0;
            margin: 0 0 24px 0;
        }
        .event-info-list li {
            margin-bottom: 10px;
            font-size: 1.08em;
        }
        .event-info-label {
            font-weight: bold;
            color: #2196F3;
            margin-right: 8px;
        }
        .card-shadow {
            box-shadow: 0 4px 16px rgba(33,150,243,0.08);
        }
        .event-footer {
            text-align: right;
            margin-top: 20px;
        }
        .event-footer a {
            color: #2196F3;
            text-decoration: none;
            font-weight: bold;
            font-size: 1em;
        }
        .event-footer a:hover {
            text-decoration: underline;
        }
        @media (max-width: 700px) {
            .details-container {
                padding: 24px 8px 16px 8px;
            }
            .back-btn {
                left: 8px;
                top: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-content">
            <div class="navbar-title">Photography Event Manager</div>
            <div class="navbar-right">
                <span class="welcome-message">
                    Welcome<% if (username != null && !username.isEmpty()) { %> <%= username %><% } %>!
                </span>
                <form action="LogoutServlet" method="post" style="display:inline;">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
    </div>
    <div class="details-container card-shadow">
        <a href="dashboard.jsp" class="back-btn">&#8592; Back</a>
        <% if (event != null) { %>
            <div class="event-title"><%= event.getTitle() %></div>
            <ul class="event-info-list">
                <li><span class="event-info-label">Date:</span> <%= event.getDate() %></li>
                <li><span class="event-info-label">Location:</span> <%= event.getLocation() %></li>
                <li><span class="event-info-label">Price:</span> <%= event.getPrice() > 0 ? "Rs. " + String.format("%.2f", event.getPrice()) : "-" %></li>
                <li><span class="event-info-label">Organizer:</span> <%= event.getUsername() != null ? event.getUsername() : "N/A" %></li>
            </ul>
            <div class="event-description">
                <%= event.getDescription() != null && !event.getDescription().isEmpty() ? event.getDescription() : "No description provided." %>
            </div>
            <!-- Booking Button and Popup Form -->
            <div style="text-align:center; margin-top:30px;">
                <button onclick="document.getElementById('bookingModal').style.display='block'" style="background:#2196F3;color:#fff;border:none;border-radius:4px;padding:12px 32px;font-size:1.1em;cursor:pointer;">Book This Event</button>
            </div>
            <!-- Booking Modal -->
            <div id="bookingModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(0,0,0,0.5);z-index:9999;align-items:center;justify-content:center;">
                <div style="background:#fff;max-width:400px;width:90%;margin:60px auto;padding:28px 24px;border-radius:10px;box-shadow:0 4px 24px rgba(33,150,243,0.12);position:relative;">
                    <button onclick="document.getElementById('bookingModal').style.display='none'" style="position:absolute;top:10px;right:16px;background:none;border:none;font-size:22px;color:#888;cursor:pointer;">&times;</button>
                    <h3 style="color:#2196F3;text-align:center;margin-bottom:18px;">Book This Event</h3>
                    <form action="payment.jsp" method="post">
                        <input type="hidden" name="eventId" value="<%= event.getId() %>">
                        <input type="hidden" name="eventTitle" value="<%= event.getTitle() %>">
                        <input type="hidden" name="username" value="<%= username != null ? username : "" %>">
                        <div style="margin-bottom:14px;">
                            <label style="font-weight:bold;color:#1769aa;">Booking Date:</label>
                            <input type="date" name="bookingDate" required style="width:100%;padding:8px;border-radius:4px;border:1px solid #bbb;">
                        </div>
                        <div style="margin-bottom:14px;">
                            <label style="font-weight:bold;color:#1769aa;">Service Type:</label>
                            <div style="padding:6px 0;">
                                <label style="margin-right:12px;">
                                    <input type="checkbox" name="serviceType" value="Photographers"> Photographers
                                </label>
                                <label style="margin-right:12px;">
                                    <input type="checkbox" name="serviceType" value="Videographers"> Videographers
                                </label>
                                <label>
                                    <input type="checkbox" name="serviceType" value="Drone Shot"> Drone Shot
                                </label>
                            </div>
                        </div>
                        <input type="hidden" name="price" value="<%= event.getPrice() %>">
                        <div style="margin-bottom:18px;">
                            <label style="font-weight:bold;color:#1769aa;">Location:</label>
                            <input type="text" name="bookingLocation" required style="width:100%;padding:8px;border-radius:4px;border:1px solid #bbb;">
                        </div>
                        <div style="text-align:center;">
                            <button type="submit" style="background:#2196F3;color:#fff;border:none;border-radius:4px;padding:10px 32px;font-size:1em;cursor:pointer;">Book Now</button>
                            <button type="button" onclick="document.getElementById('bookingModal').style.display='none'" style="background:#ccc;color:#222;border:none;border-radius:4px;padding:10px 32px;font-size:1em;margin-left:10px;cursor:pointer;">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
            <script>
                // Close modal when clicking outside the form
                window.onclick = function(event) {
                    var modal = document.getElementById('bookingModal');
                    if (event.target === modal) {
                        modal.style.display = 'none';
                    }
                }
            </script>
            <div class="event-footer">
                <a href="dashboard.jsp">Back to Events</a>
            </div>
        <% } else { %>
            <div style="text-align:center; color:#f44336; font-size:1.3em; margin: 60px 0;">
                <b>Event not found.</b>
            </div>
            <div class="event-footer">
                <a href="dashboard.jsp">Back to Events</a>
            </div>
        <% } %>
    </div>
    <!-- Footer Section -->
    <footer style="width:100%;background:#232946;color:#fff;text-align:center;padding:22px 0 16px 0;margin-top:48px;font-size:1.08em;letter-spacing:0.5px;box-shadow:0 -2px 8px rgba(33,150,243,0.07);">
        &copy; <%= java.time.Year.now() %> Photography Event Manager &mdash; All Rights Reserved.
    </footer>
</body>
</html>