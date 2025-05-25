<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String username = null;
    if (session != null && session.getAttribute("username") != null) {
        username = (String) session.getAttribute("username");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Event</title>
    <style>
        body {
            background: linear-gradient(120deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .navbar {
            width: 100%;
            background: #232946;
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
        .add-container {
            max-width: 520px;
            margin: 90px auto 0 auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(44,62,80,0.15);
            padding: 48px 36px 36px 36px;
            position: relative;
        }
        .add-title {
            font-size: 2em;
            color: #2196F3;
            margin-bottom: 18px;
            font-weight: bold;
            letter-spacing: 1px;
            text-align: center;
        }
        .add-form label {
            font-weight: bold;
            color: #2196F3;
            margin-bottom: 6px;
            display: block;
            font-size: 1.08em;
        }
        .add-form input[type="text"],
        .add-form input[type="date"],
        .add-form textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #bbb;
            border-radius: 5px;
            margin-bottom: 18px;
            font-size: 1.08em;
            background: #f7fafc;
            box-sizing: border-box;
            transition: border 0.2s;
        }
        .add-form input[type="text"]:focus,
        .add-form input[type="date"]:focus,
        .add-form textarea:focus {
            border: 1.5px solid #2196F3;
            outline: none;
        }
        .add-form textarea {
            min-height: 90px;
            resize: vertical;
        }
        .add-form .form-actions {
            text-align: center;
            margin-top: 18px;
        }
        .add-form button,
        .add-form input[type="submit"] {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 12px 32px;
            font-size: 1em;
            cursor: pointer;
            margin-left: 8px;
            margin-top: 8px;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
        }
        .add-form button.cancel-btn {
            background: #ccc;
            color: #222;
        }
        .add-form button.cancel-btn:hover {
            background: #b0b0b0;
        }
        .add-form input[type="submit"]:hover {
            background: linear-gradient(90deg, #1769aa 0%, #21CBF3 100%);
            box-shadow: 0 4px 16px rgba(33,150,243,0.15);
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
            .add-container {
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
    <div class="add-container card-shadow">
        <a href="dashboard.jsp" class="back-btn">&#8592; Back</a>
        <div class="add-title">Add New Event</div>
        <form class="add-form" action="AddEventServlet" method="post">
            <label for="title">Event Title:</label>
            <input type="text" id="title" name="title" placeholder="Enter event title" required>

            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required>

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" placeholder="Enter location" required>

            <label for="description">Description:</label>
            <textarea id="description" name="description" placeholder="Enter event description"></textarea>

            <label for="username">Username:</label>
            <input type="text" id="username" name="username" value="<%= username != null ? username : "" %>" required readonly>

            <div class="form-actions">
                <button type="button" class="cancel-btn" onclick="window.location.href='dashboard.jsp'">Cancel</button>
                <input type="submit" value="Add Event">
            </div>
        </form>
    </div>
</body>
</html>
