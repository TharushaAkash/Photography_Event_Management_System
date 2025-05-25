<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="util.UserFileHandler" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sessionObj = request.getSession(false);
    String username = (sessionObj != null && sessionObj.getAttribute("username") != null) ? (String) sessionObj.getAttribute("username") : null;
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    // --- FIX: get user by iterating all users ---
    Map<String, String> user = null;
    List<Map<String, String>> allUsers = UserFileHandler.getAllUsers();
    if (allUsers != null) {
        for (Map<String, String> u : allUsers) {
            if (username.equals(u.get("username"))) {
                user = u;
                break;
            }
        }
    }
    String updateMsg = request.getParameter("updateMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
    <style>
        body {
            background: linear-gradient(120deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .navbar {
            width: 100%;
            background: linear-gradient(90deg, #232946 60%, #2196F3 100%);
            color: #fff;
            padding: 0;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 62px;
            box-shadow: 0 2px 12px rgba(44,62,80,0.10);
        }
        .navbar .nav-title {
            font-size: 1.6em;
            font-weight: bold;
            margin-left: 32px;
            letter-spacing: 1.5px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .navbar .nav-logo {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: #e3f2fd;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6em;
            color: #2196F3;
            box-shadow: 0 2px 8px rgba(33,150,243,0.12);
        }
        .navbar .nav-links {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-right: 32px;
        }
        .navbar .welcome-user {
            background:#1769aa;
            color:#fff;
            font-weight:bold;
            border-radius:20px;
            padding:7px 22px;
            margin-right:8px;
            letter-spacing:0.5px;
            font-size:1em;
            box-shadow:0 2px 8px rgba(33,150,243,0.08);
            display: flex;
            align-items: center;
        }
        .navbar .nav-link {
            color: #fff;
            text-decoration: none;
            font-size: 1em;
            padding: 10px 22px;
            border-radius: 6px;
            transition: background 0.18s, box-shadow 0.18s;
            font-weight: bold;
            background: transparent;
        }
        .navbar .nav-link:hover, .navbar .nav-link.active {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            box-shadow: 0 2px 8px #2196f344;
        }
        .navbar .logout-btn {
            background: linear-gradient(90deg, #f44336 0%, #ff7961 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 22px;
            font-size: 1em;
            cursor: pointer;
            margin-left: 10px;
            font-weight: bold;
            transition: background 0.18s, box-shadow 0.18s, transform 0.18s;
            box-shadow: 0 2px 8px rgba(244,67,54,0.08);
        }
        .navbar .logout-btn:hover {
            background: #c62828;
            box-shadow: 0 4px 16px rgba(244,67,54,0.15);
            transform: scale(1.04);
        }
        .profile-container {
            max-width: 480px;
            margin: 56px auto 48px auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 8px 32px rgba(33,150,243,0.13);
            padding: 44px 36px 36px 36px;
            animation: fadeInCard 0.8s;
        }
        h2 {
            color: #2196F3;
            text-align: center;
            margin-bottom: 28px;
            font-size: 2em;
            letter-spacing: 1px;
        }
        .profile-avatar {
            width: 82px;
            height: 82px;
            border-radius: 50%;
            background: linear-gradient(120deg,#e3f2fd 0%,#fff 100%);
            margin: 0 auto 18px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.6em;
            color: #2196F3;
            box-shadow: 0 2px 8px #2196f322;
        }
        .profile-form label {
            font-weight: bold;
            color: #1769aa;
            display: block;
            margin-bottom: 6px;
        }
        .profile-form input[type="text"],
        .profile-form input[type="email"],
        .profile-form input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 18px;
            border: 1.5px solid #bbb;
            border-radius: 6px;
            font-size: 1.08em;
            background: #f7fafc;
            transition: border 0.18s, box-shadow 0.18s;
        }
        .profile-form input[type="text"]:focus,
        .profile-form input[type="email"]:focus,
        .profile-form input[type="password"]:focus {
            border: 1.5px solid #2196F3;
            box-shadow: 0 2px 8px #2196f322;
            outline: none;
        }
        .profile-form input[readonly] {
            background: #e3f2fd;
            color: #888;
        }
        .profile-form .form-actions {
            text-align: center;
            margin-top: 18px;
        }
        .profile-form button {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 12px 38px;
            font-size: 1.08em;
            cursor: pointer;
            margin-right: 10px;
            font-weight: bold;
            box-shadow: 0 2px 8px #2196f344;
            transition: background 0.18s, transform 0.18s;
        }
        .profile-form button:hover {
            background: #1769aa;
            transform: scale(1.04);
        }
        .profile-form .cancel-btn {
            background: #ccc;
            color: #222;
        }
        .profile-form .cancel-btn:hover {
            background: #bbb;
        }
        .success-msg {
            color: #2196F3;
            text-align: center;
            font-weight: bold;
            margin-bottom: 18px;
        }
        .error-msg {
            color: #f44336;
            text-align: center;
            font-weight: bold;
            margin-bottom: 18px;
        }
        @keyframes fadeInCard {
            from { opacity: 0; transform: scale(0.95);}
            to { opacity: 1; transform: scale(1);}
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <div class="navbar">
        <div class="nav-title">
            <span class="nav-logo">&#128247;</span>
            LensLoom
        </div>
        <div class="nav-links">
            <span class="welcome-user">
                Welcome, <%= username %>!
            </span>
            <a href="dashboard.jsp" class="nav-link">Dashboard</a>
            <a href="myBookings.jsp" class="nav-link">My Bookings</a>
            <a href="profile.jsp" class="nav-link active">My Profile</a>
            <form action="LogoutServlet" method="post" style="display:inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
    <div class="profile-container">
        <div class="profile-avatar">&#128100;</div>
        <h2>My Profile</h2>
        <% if (updateMsg != null && !updateMsg.isEmpty()) { %>
            <div class="<%= "success".equals(updateMsg) ? "success-msg" : "error-msg" %>">
                <%= "success".equals(updateMsg) ? "Profile updated successfully!" : updateMsg %>
            </div>
        <% } %>
        <form class="profile-form" action="UpdateProfileServlet" method="post">
            <label>Username</label>
            <input type="text" name="username" value="<%= user != null ? user.get("username") : "" %>" required>

            <label>Email</label>
            <input type="email" name="email" value="<%= user != null ? user.get("email") : "" %>" required>

            <label>New Password <span style="font-weight:normal;color:#888;">(leave blank to keep current)</span></label>
            <input type="password" name="password" placeholder="Enter new password">

            <div class="form-actions">
                <button type="submit">Update Profile</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='dashboard.jsp'">Cancel</button>
            </div>
        </form>
    </div>
</body>
</html>
