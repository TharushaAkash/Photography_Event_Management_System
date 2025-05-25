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
    String username = null;
    if (session != null && session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Event</title>
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
        .edit-container {
            max-width: 600px;
            margin: 90px auto 0 auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(44,62,80,0.15);
            padding: 40px 32px 32px 32px;
            position: relative;
        }
        .edit-title {
            font-size: 2em;
            color: #222;
            margin-bottom: 18px;
            font-weight: bold;
            letter-spacing: 1px;
            text-align: center;
        }
        .edit-form label {
            font-weight: bold;
            color: #2196F3;
            margin-bottom: 6px;
            display: block;
        }
        .edit-form input[type="text"],
        .edit-form input[type="date"],
        .edit-form textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #bbb;
            border-radius: 5px;
            margin-bottom: 18px;
            font-size: 1em;
            background: #f7fafc;
            box-sizing: border-box;
        }
        .edit-form textarea {
            min-height: 90px;
            resize: vertical;
        }
        .edit-form .form-actions {
            text-align: right;
        }
        .edit-form button,
        .edit-form input[type="submit"] {
            background: #2196F3;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 10px 28px;
            font-size: 1em;
            cursor: pointer;
            margin-left: 8px;
            transition: background 0.2s;
        }
        .edit-form button.cancel-btn {
            background: #ccc;
            color: #222;
        }
        .edit-form button.cancel-btn:hover {
            background: #b0b0b0;
        }
        .edit-form input[type="submit"]:hover {
            background: #1769aa;
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
        @media (max-width: 700px) {
            .edit-container {
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
    <div class="edit-container card-shadow">
        <a href="adminDashboard.jsp" class="back-btn">&#8592; Back</a>
        <div class="edit-title">Edit Event</div>
        <% if (event != null) { %>
        <form class="edit-form" action="EditEventServlet" method="post">
            <input type="hidden" name="eventId" value="<%= event.getId() %>">
            <div style="display:flex; flex-wrap:wrap; gap:18px;">
                <div style="flex:1; min-width:180px;">
                    <label>Title:<br>
                        <input type="text" name="title" value="<%= event.getTitle() %>" required style="width:100%;padding:6px;">
                    </label>
                </div>
                <div style="flex:1; min-width:140px;">
                    <label>Date:<br>
                        <input type="date" name="date" value="<%= event.getDate() %>" required style="width:100%;padding:6px;">
                    </label>
                </div>
                <div style="flex:1; min-width:180px;">
                    <label>Location:<br>
                        <input type="text" name="location" value="<%= event.getLocation() %>" required style="width:100%;padding:6px;">
                    </label>
                </div>
                <div style="flex:1; min-width:120px;">
                    <label>Price:<br>
                        <input type="number" name="price" value="<%= event.getPrice() > 0 ? String.format("%.2f", event.getPrice()) : "" %>" min="0" step="0.01" required style="width:100%;padding:6px;">
                    </label>
                </div>
            </div>
            <div style="margin-top:12px;">
                <label>Description:<br>
                    <textarea name="description" rows="2" style="width:100%;padding:6px;" required><%= event.getDescription() %></textarea>
                </label>
            </div>

            <div class="form-actions">
                <button type="button" class="cancel-btn" onclick="window.location.href='adminDashboard.jsp'">Cancel</button>
                <input type="submit" value="Save Changes">
            </div>
        </form>
        <% } else { %>
            <div style="text-align:center; color:#f44336; font-size:1.3em; margin: 60px 0;">
                <b>Event not found.</b>
            </div>
            <div style="text-align:right;">
                <a href="adminDashboard.jsp" class="back-btn">Back to Events</a>
            </div>
        <% } %>
    </div>
</body>
</html>


