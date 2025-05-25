<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="util.UserFileHandler" %>
<%@ page import="util.BookingFileHandler" %>
<%@ page import="com.example.event_booking_project_90.model.Photography" %>
<%@ page import="com.example.event_booking_project_90.util.PhotoEventFileHandler" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Use the implicit 'session' object provided by JSP
    String username = (session != null && session.getAttribute("username") != null) ? (String) session.getAttribute("username") : null;
    if (username == null || !"admin".equals(username)) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Map<String, String>> users = UserFileHandler.getAllUsers();
    List<Map<String, String>> bookings = BookingFileHandler.getAllBookings();
    List<Photography> events = PhotoEventFileHandler.getAllEvents();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            background: linear-gradient(120deg, #f5f7fa 0%, #c3cfe2 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .admin-layout {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 230px;
            background: linear-gradient(180deg, #232946 70%, #2196F3 100%);
            color: #fff;
            padding-top: 0;
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            z-index: 200;
            box-shadow: 2px 0 16px rgba(33,150,243,0.10);
            animation: fadeInLeft 0.7s;
        }
        .sidebar-header {
            font-size: 1.6em;
            font-weight: bold;
            padding: 30px 0 20px 0;
            text-align: center;
            background: #232946;
            letter-spacing: 1px;
            border-bottom: 1px solid #393e5c;
            text-shadow: 0 2px 8px rgba(33,150,243,0.08);
        }
        .sidebar-nav {
            flex: 1;
            display: flex;
            flex-direction: column;
            margin-top: 30px;
        }
        .sidebar-nav button {
            background: none;
            border: none;
            color: #fff;
            padding: 16px 32px;
            text-align: left;
            font-size: 1.1em;
            cursor: pointer;
            transition: background 0.18s, transform 0.18s;
            outline: none;
            border-left: 4px solid transparent;
        }
        .sidebar-nav button.active, .sidebar-nav button:hover {
            background: #2196F3;
            color: #fff;
            border-left: 4px solid #fff;
            transform: scale(1.04);
        }
        .sidebar-footer {
            padding: 20px 32px;
            border-top: 1px solid #393e5c;
        }
        .logout-btn {
            background: linear-gradient(90deg, #f44336 0%, #ff7961 100%);
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 24px;
            cursor: pointer;
            font-size: 15px;
            width: 100%;
            box-shadow: 0 2px 8px rgba(244,67,54,0.08);
            transition: background 0.18s, transform 0.18s;
        }
        .logout-btn:hover {
            background: #c62828;
            transform: scale(1.04);
        }
        .main-content {
            margin-left: 230px;
            padding: 40px 32px 32px 32px;
            width: 100%;
            min-height: 100vh;
            background: transparent;
            animation: fadeInUp 0.8s;
        }
        .section {
            display: none;
            animation: fadeIn 0.4s;
        }
        .section.active {
            display: block;
            animation: fadeInUp 0.7s;
        }
        h2 {
            color: #2196F3;
            margin-top: 0;
            margin-bottom: 18px;
            font-size: 1.7em;
            letter-spacing: 1px;
            text-shadow: 0 2px 8px rgba(33,150,243,0.08);
        }
        table,
        .event-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 32px;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(33,150,243,0.07);
            animation: fadeInCard 0.7s;
            font-size: 0.97em;
        }
        th, td,
        .event-table th, .event-table td {
            padding: 10px 8px;
            text-align: center;
            border: none;
        }
        th, .event-table th {
            background: #f7f7f7;
            color: #232946;
            font-size: 1em;
            font-weight: bold;
            letter-spacing: 0.5px;
        }
        tr, .event-table tr {
            background: #fff;
            transition: background 0.18s;
        }
        tr:nth-child(even), .event-table tr:nth-child(even) {
            background: #f3f3f3;
        }
        tr:hover, .event-table tr:hover {
            background: #d1d5db;
        }
        td, .event-table td {
            font-size: 1em;
            color: #232946;
            vertical-align: middle;
            max-width: 120px;
            word-break: break-word;
        }
        td:first-child, th:first-child,
        .event-table td:first-child, .event-table th:first-child {
            font-weight: bold;
            color: #2196F3;
            background: #f7f7f7;
        }
        .action-btns,
        .event-table .action-btns {
            display: flex;
            gap: 8px;
            align-items: center;
            justify-content: center;
        }

        .event-table .delete-btn {
            border: none;
            border-radius: 6px;
            padding: 7px 14px;
            font-size: 1em;
            cursor: pointer;
            font-weight: bold;
            background: #b91a1a;
            color: #ffffff;
            transition: background 0.18s, color 0.18s, transform 0.18s;
            margin-right: 2px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .delete-btn {
            border: none;
            border-radius: 6px;
            padding: 7px 14px;
            font-size: 1em;
            cursor: pointer;
            font-weight: bold;
            background: #ddaa09;
            color: #232946;
            transition: background 0.18s, color 0.18s, transform 0.18s;
            margin-right: 2px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .view-btn {
            border: none;
            border-radius: 6px;
            padding: 7px 14px;
            font-size: 1em;
            cursor: pointer;
            font-weight: bold;
            background: #21c3f3;
            color: #232946;
            transition: background 0.18s, color 0.18s, transform 0.18s;
            margin-right: 2px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .edit-btn,
        .event-table .view-btn,
        .event-table .edit-btn {
            border: none;
            border-radius: 6px;
            padding: 7px 14px;
            font-size: 1em;
            cursor: pointer;
            font-weight: bold;
            background: #e5e7eb;
            color: #232946;
            transition: background 0.18s, color 0.18s, transform 0.18s;
            margin-right: 2px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .delete-btn:hover {
            background: #bd1e1e;
            color: #fff;
            transform: scale(1.07);
        }
        .view-btn:hover {
            transform: scale(1.07);
        }
        .edit-btn:hover,
        .event-table .view-btn:hover,
        .event-table .edit-btn:hover,
        .event-table .delete-btn:hover {
            background: #0c6ba8;
            color: #fff;
            transform: scale(1.07);
        }
        /* Booking status badge */
        .status-badge {
            display: inline-block;
            padding: 6px 18px;
            border-radius: 16px;
            font-size: 1em;
            font-weight: bold;
            color: #fff;
            background: #888;
            letter-spacing: 0.5px;
            min-width: 80px;
        }
        .status-badge.Pending {
            background: #f59e42;
        }
        .status-badge.Complete {
            background: #22c55e;
        }
        .status-badge.Canceled {
            background: #f44336;
        }
        /* Booking cards */
        .booking-cards {
            display: flex;
            gap: 24px;
            margin-bottom: 18px;
            justify-content: flex-start;
            flex-wrap: wrap;
        }
        .booking-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(33,150,243,0.10);
            padding: 18px 32px;
            min-width: 180px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .booking-card .card-title {
            font-size: 1em;
            color: #232946;
            margin-bottom: 6px;
            font-weight: bold;
        }
        .booking-card .card-value {
            font-size: 2em;
            font-weight: bold;
            color: #2196F3;
        }
        .booking-card.all { border-left: 6px solid #2196F3; }
        .booking-card.complete { border-left: 6px solid #22c55e; }
        .booking-card.pending { border-left: 6px solid #f59e42; }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInLeft {
            from { opacity: 0; transform: translateX(-40px);}
            to { opacity: 1; transform: translateX(0);}
        }
        @keyframes fadeInCard {
            from { opacity: 0; transform: scale(0.95);}
            to { opacity: 1; transform: scale(1);}
        }
        @media (max-width: 900px) {
            .main-content {
                padding: 24px 4px 16px 4px;
            }
            .sidebar {
                width: 100px;
            }
            .sidebar-header {
                font-size: 1.1em;
                padding: 18px 0 10px 0;
            }
            .sidebar-nav button {
                padding: 12px 10px;
                font-size: 1em;
            }
        }
        .modal-overlay {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0; top: 0; right: 0; bottom: 0;
            background: rgba(44,62,80,0.18);
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active {
            display: flex !important;
        }
        .modal-content {
            background: #fff;
            border-radius: 10px;
            padding: 32px 28px 24px 28px;
            box-shadow: 0 4px 24px rgba(33,150,243,0.13);
            position: relative;
            animation: fadeInUp 0.4s;
        }
        .close-btn {
            position: absolute;
            top: 12px;
            right: 18px;
            background: none;
            border: none;
            font-size: 1.7em;
            color: #888;
            cursor: pointer;
            font-weight: bold;
        }
        .close-btn:hover { color: #f44336; }
    </style>
    <script>
        function showSection(sectionId, btn) {
            var sections = document.querySelectorAll('.section');
            sections.forEach(function(sec) { sec.classList.remove('active'); });
            document.getElementById(sectionId).classList.add('active');
            var navBtns = document.querySelectorAll('.sidebar-nav button');
            navBtns.forEach(function(b) { b.classList.remove('active'); });
            btn.classList.add('active');
        }
        window.onload = function() {
            // Show first section by default
            document.getElementById('eventsSection').classList.add('active');
            document.getElementById('navEvents').classList.add('active');
        }
        function showAddEventPopup() {
            var popup = document.getElementById('addEventPopup');
            if (popup) {
                popup.classList.add('active');
                popup.style.display = 'flex';
            }
        }
        function closeAddEventPopup() {
            var popup = document.getElementById('addEventPopup');
            if (popup) {
                popup.classList.remove('active');
                popup.style.display = 'none';
            }
        }
    </script>
</head>
<body>
    <div class="admin-layout">
        <div class="sidebar">
            <div class="sidebar-header">Admin Panel</div>
            <div class="sidebar-nav">
                <button id="navEvents" onclick="showSection('eventsSection', this)">Events</button>
                <button id="navBookings" onclick="showSection('bookingsSection', this)">Bookings</button>
                <button id="navUsers" onclick="showSection('usersSection', this)">Users</button>
            </div>
            <div class="sidebar-footer">
                <form action="LogoutServlet" method="post" style="margin:0;">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>
        <div class="main-content">
            <div id="eventsSection" class="section">
                <h2>Events</h2>
                <!-- Add Event Button (shows popup form) -->
                <div style="display: flex; justify-content: flex-end; align-items: center; margin-bottom:18px;">
                    <button class="view-btn" style="padding:8px 28px;box-shadow:0 2px 8px rgb(21,122,255);" onclick="showAddEventPopup()">Add Event</button>
                </div>
                <table class="event-table">
                    <tr>
                        <th>Event ID</th>
                        <th>Title</th>
                        <th>Date</th>
                        <th>Location</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Action</th>
                    </tr>
                    <% 
                    if (events != null && !events.isEmpty()) {
                        for (int i = 0; i < events.size(); i++) {
                            Photography event = events.get(i);
                            // Escape single quotes for JS string safety
                            String jsTitle = event.getTitle() != null ? event.getTitle().replace("'", "\\\\'") : "";
                            String jsLocation = event.getLocation() != null ? event.getLocation().replace("'", "\\\\'") : "";
                            String jsDescription = event.getDescription() != null ? event.getDescription().replace("'", "\\\\'") : "";
                            String jsUsername = event.getUsername() != null ? event.getUsername().replace("'", "\\\\'") : "";
                            String jsPrice = event.getPrice() > 0 ? "Rs. " + String.format("%.2f", event.getPrice()) : "-";
%>
<tr>
    <td title="<%= event.getId() %>">
        <%= event.getId().length() > 10 ? event.getId().substring(0, 10) + "..." : event.getId() %>
    </td>
    <td style="font-weight:bold;color:#2196F3;"><%= event.getTitle() %></td>
    <td><%= event.getDate() %></td>
    <td><%= event.getLocation() %></td>
    <td style="max-width:120px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%= event.getDescription() %></td>
    <td><%= jsPrice %></td>
    <td>
        <div class="action-btns">
            <button type="button" class="view-btn" title="View"
                onclick="showEventPopup(
                    '<%= event.getTitle() != null ? event.getTitle().replace("\\", "\\\\").replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    '<%= event.getDate() != null ? event.getDate().replace("\\", "\\\\").replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    '<%= event.getLocation() != null ? event.getLocation().replace("\\", "\\\\").replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    '<%= event.getDescription() != null ? event.getDescription().replace("\\", "\\\\").replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    '',
                    '<%= event.getPrice() > 0 ? ("Rs. " + String.format("%.2f", event.getPrice())).replace("\\", "\\\\").replace("'", "\\'") : "-" %>'
                )">
                <span style="font-size:1.2em;">&#128065;</span>
            </button>
            <button type="button" class="edit-btn" title="Edit"
                onclick="showEditEventPopup({
                    id: '<%= event.getId().replace("'", "\\'") %>',
                    title: '<%= event.getTitle() != null ? event.getTitle().replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    date: '<%= event.getDate() != null ? event.getDate().replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    location: '<%= event.getLocation() != null ? event.getLocation().replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>',
                    price: <%= event.getPrice() %>,
                    description: '<%= event.getDescription() != null ? event.getDescription().replace("'", "\\'").replaceAll("[\\r\\n]+", " ") : "" %>'
                })">
                <span style="font-size:1.2em;">&#9998;</span>
            </button>
            <form action="DeleteEventServlet" method="post" style="display:inline;">
                <input type="hidden" name="eventId" value="<%= event.getId() %>">
                <input type="hidden" name="admin" value="1">
                <button type="submit" class="delete-btn" title="Delete" onclick="return confirm('Are you sure you want to delete this event?')">
                    <span style="font-size:1.2em;">&#128465;</span>
                </button>
            </form>
        </div>
    </td>
</tr>
<% 
    }
} else { 
%>
<tr>
    <td colspan="7" style="text-align:center; color:#888;">No events found.</td>
</tr>
<% } %>
                </table>
            </div>
            <div id="bookingsSection" class="section">
                <h2>Bookings</h2>
                <%
                    int allCount = bookings != null ? bookings.size() : 0;
                    int completeCount = 0, pendingCount = 0;
                    if (bookings != null) {
                        for (Map<String, String> booking : bookings) {
                            String status = booking.get("status");
                            if ("Complete".equalsIgnoreCase(status)) completeCount++;
                            if ("Pending".equalsIgnoreCase(status)) pendingCount++;
                        }
                    }
                %>
                <div class="booking-cards">
                    <div class="booking-card all">
                        <div class="card-title">All Bookings</div>
                        <div class="card-value"><%= allCount %></div>
                    </div>
                    <div class="booking-card complete">
                        <div class="card-title">Completed</div>
                        <div class="card-value"><%= completeCount %></div>
                    </div>
                    <div class="booking-card pending">
                        <div class="card-title">Pending</div>
                        <div class="card-value"><%= pendingCount %></div>
                    </div>
                </div>
                <table>
                    <tr>
                        <th>Booking ID</th>
                        <th>User</th>
                        <th>Event</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    <% 
                    for (Map<String, String> booking : bookings) { 
                    %>
                    <tr>
                        <td><%= booking.get("id") %></td>
                        <td><%= booking.get("username") %></td>
                        <td><%= booking.get("eventTitle") %></td>
                        <td>
                            <span class="status-badge <%= booking.get("status") %>"><%= booking.get("status") %></span>
                        </td>
                        <td>
                            <button class="update-btn" title="Edit Status"
                                onclick="showUpdateStatusPopup('<%= booking.get("id") %>', '<%= booking.get("status") %>')"
                                style="background:#ffc107;color:#222;padding:6px 12px;border-radius:50%;border:none;cursor:pointer;">
                                <span style="font-size:18px;">&#9998;</span>
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
            <!-- Update Booking Status Popup -->
            <div id="updateStatusPopup" class="modal-overlay" style="display:none;">
                <div class="modal-content" style="max-width:340px;">
                    <button class="close-btn" onclick="closeUpdateStatusPopup()">&times;</button>
                    <h3 style="color:#2196F3;text-align:center;">Update Booking Status</h3>
                    <form id="updateStatusForm" action="UpdateBookingStatusServlet" method="post" style="margin-top:18px;">
                        <input type="hidden" id="updateBookingId" name="bookingId" value="">
                        <div style="margin-bottom:18px;">
                            <label for="updateStatusSelect" style="font-weight:bold;color:#1769aa;">Status:</label>
                            <select id="updateStatusSelect" name="status" style="width:100%;padding:8px;border-radius:4px;border:1px solid #bbb;">
                                <option value="Pending">Pending</option>
                                <option value="Complete">Complete</option>
                                <option value="Canceled">Canceled</option>
                            </select>
                        </div>
                        <div style="text-align:center;">
                            <button type="button" class="view-btn" style="background:#f40a0a;color:#222;margin-right:10px;" onclick="closeUpdateStatusPopup()">Cancel</button>
                            <button type="submit" class="view-btn">Update</button>
                        </div>
                    </form>
                </div>
            </div>
            <div id="usersSection" class="section">
                <h2>Users</h2>
                <table>
                    <tr>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Action</th>
                    </tr>
                    <% for (Map<String, String> user : users) {
                        if ("admin".equals(user.get("username"))) continue; %>
                    <tr>
                        <td><%= user.get("username") %></td>
                        <td><%= user.get("email") %></td>
                        <td>
                            <form action="DeleteUserServlet" method="post" style="display:inline;">
                                <input type="hidden" name="username" value="<%= user.get("username") %>"/>
                                <button type="submit" class="delete-btn">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
        </div>
    </div>

    <!-- Delete Event Confirmation Popup -->
    <div id="deleteEventPopup" class="modal-overlay" style="display:none;">
        <div class="modal-content">
            <button class="close-btn" onclick="closeDeleteEventPopup()">&times;</button>
            <h3>Confirm Delete</h3>
            <p>Are you sure you want to delete this event?</p>
            <form action="DeleteEventServlet" method="post" style="text-align:center;">
                <input type="hidden" id="deleteEventId" name="eventId" value="">
                <button type="button" onclick="closeDeleteEventPopup()" class="view-btn" style="background:#ccc; color:#222;">Cancel</button>
                <input type="submit" value="Delete" class="delete-btn" style="margin-left:10px;">
            </form>
        </div>
    </div>

    <!-- Delete Success Popup -->
    <div id="deleteSuccessPopup" class="modal-overlay" style="display:none;">
        <div class="modal-content">
            <button class="close-btn" onclick="closeDeleteSuccessPopup()">&times;</button>
            <div class="success-msg">Event deleted successfully!</div>
            <div class="modal-actions">
                <button onclick="closeDeleteSuccessPopup()" class="view-btn">OK</button>
            </div>
        </div>
    </div>

    <!-- Add Event Popup Modal -->
    <div id="addEventPopup" class="modal-overlay">
        <div class="modal-content" style="max-width:520px; padding: 0; overflow: visible;">
            <button class="close-btn" onclick="closeAddEventPopup()">&times;</button>
            <div style="background:linear-gradient(90deg,#2196F3 60%,#232946 100%);border-radius:10px 10px 0 0;padding:24px 0 16px 0;text-align:center;">
                <h3 style="margin:0;color:#fff;font-size:1.5em;letter-spacing:1px;">Add New Event</h3>
            </div>
            <form action="AddEventServlet" method="post" style="padding:28px 32px 18px 32px;">
                <div style="display:flex; flex-wrap:wrap; gap:18px;">
                    <div style="flex:1; min-width:180px;">
                        <label style="font-weight:bold;color:#1769aa;">Title:<br>
                            <input type="text" name="title" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                    <div style="flex:1; min-width:140px;">
                        <label style="font-weight:bold;color:#1769aa;">Date:<br>
                            <input type="date" name="date" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                    <div style="flex:1; min-width:180px;">
                        <label style="font-weight:bold;color:#1769aa;">Location:<br>
                            <input type="text" name="location" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                    <div style="flex:1; min-width:120px;">
                        <label style="font-weight:bold;color:#1769aa;">Price:<br>
                            <input type="number" name="price" min="0" step="0.01" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;" value="">
                        </label>
                    </div>
                </div>
                <div style="margin-top:18px;">
                    <label style="font-weight:bold;color:#1769aa;">Description:<br>
                        <textarea name="description" rows="3" style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;" required></textarea>
                    </label>
                </div>
                <div style="margin-top:22px; text-align:center;">
                    <button type="button" class="view-btn" style="background:#ccc;color:#222;margin-right:14px;padding:10px 32px;font-size:1.1em;" onclick="closeAddEventPopup()">Cancel</button>
                    <button type="submit" class="view-btn" style="padding:10px 32px;background:linear-gradient(90deg,#2196F3 60%,#232946 100%);color:#fff;font-size:1.1em;">Add Event</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Event Popup Modal -->
    <div id="editEventPopup" class="modal-overlay" style="display:none;">
        <div class="modal-content" style="max-width:520px; padding: 0; overflow: visible;">
            <button class="close-btn" onclick="closeEditEventPopup()">&times;</button>
            <div style="background:linear-gradient(90deg,#2196F3 60%,#232946 100%);border-radius:10px 10px 0 0;padding:24px 0 16px 0;text-align:center;">
                <h3 style="margin:0;color:#fff;font-size:1.5em;letter-spacing:1px;">Edit Event</h3>
            </div>
            <form id="editEventForm" action="EditEventServlet" method="post" style="padding:28px 32px 18px 32px;">
                <input type="hidden" name="eventId" id="editEventId" value="">
                <div style="display:flex; flex-wrap:wrap; gap:18px;">
                    <div style="flex:1; min-width:180px;">
                        <label style="font-weight:bold;color:#1769aa;">Title:<br>
                            <input type="text" name="title" id="editEventTitle" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                    <div style="flex:1; min-width:140px;">
                        <label style="font-weight:bold;color:#1769aa;">Date:<br>
                            <input type="date" name="date" id="editEventDate" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                    <div style="flex:1; min-width:180px;">
                        <label style="font-weight:bold;color:#1769aa;">Location:<br>
                            <input type="text" name="location" id="editEventLocation" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                    <div style="flex:1; min-width:120px;">
                        <label style="font-weight:bold;color:#1769aa;">Price:<br>
                            <input type="number" name="price" id="editEventPrice" min="0" step="0.01" required style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;">
                        </label>
                    </div>
                </div>
                <div style="margin-top:18px;">
                    <label style="font-weight:bold;color:#1769aa;">Description:<br>
                        <textarea name="description" id="editEventDescription" rows="3" style="width:100%;padding:10px 8px;border-radius:6px;border:1.5px solid #2196F3;font-size:1em;" required></textarea>
                    </label>
                </div>
                <div style="margin-top:22px; text-align:center;">
                    <button type="button" class="view-btn" style="background:#ccc;color:#222;margin-right:14px;padding:10px 32px;font-size:1.1em;" onclick="closeEditEventPopup()">Cancel</button>
                    <button type="submit" class="view-btn" style="padding:10px 32px;background:linear-gradient(90deg,#2196F3 60%,#232946 100%);color:#fff;font-size:1.1em;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Event View Popup -->
    <div id="eventViewPopup" class="modal-overlay" style="display:none;">
        <div class="modal-content" style="max-width:500px; padding:0; overflow:visible;">
            <button class="close-btn" onclick="closeEventPopup()">&times;</button>
            <div style="background:linear-gradient(90deg,#2196F3 60%,#232946 100%);border-radius:10px 10px 0 0;padding:24px 0 16px 0;text-align:center;">
                <h2 id="eventPopupTitle" style="margin:0;color:#fff;font-size:1.5em;letter-spacing:1px;"></h2>
            </div>
            <div style="padding:28px 32px 18px 32px;">
                <div style="margin-bottom:18px;">
                    <span style="font-weight:bold;color:#1769aa;">Date:</span>
                    <span id="eventPopupDate" style="margin-left:8px;color:#232946;"></span>
                </div>
                <div style="margin-bottom:18px;">
                    <span style="font-weight:bold;color:#1769aa;">Location:</span>
                    <span id="eventPopupLocation" style="margin-left:8px;color:#232946;"></span>
                </div>
                <div style="margin-bottom:18px;">
                    <span style="font-weight:bold;color:#1769aa;">Price:</span>
                    <span id="eventPopupPrice" style="margin-left:8px;color:#232946;"></span>
                </div>
                <div style="margin-bottom:18px;">
                    <span style="font-weight:bold;color:#1769aa;">Description:</span>
                    <span id="eventPopupDescription" style="margin-left:8px;color:#232946;"></span>
                </div>
            </div>
            <div class="modal-actions" style="text-align:center;padding-bottom:18px;">
                <button onclick="closeEventPopup()" class="view-btn" style="padding:10px 32px;background:#232946;color:#fff;font-size:1.1em;">Close</button>
            </div>
        </div>
    </div>
    <script>
        function showEventPopup(title, date, location, description, username, price) {
            document.getElementById('eventPopupTitle').innerText = title;
            document.getElementById('eventPopupDate').innerText = date;
            document.getElementById('eventPopupLocation').innerText = location;
            document.getElementById('eventPopupDescription').innerText = description;
            document.getElementById('eventPopupPrice').innerText = price && price !== "0.00" && price !== "-" ? price : "-";
            // Show popup using flex (for overlay centering)
            var popup = document.getElementById('eventViewPopup');
            if (popup) {
                popup.style.display = 'flex';
            }
        }
        function closeEventPopup() {
            var popup = document.getElementById('eventViewPopup');
            if (popup) {
                popup.style.display = 'none';
            }
        }
        function showDeleteEventPopup(eventId) {
            document.getElementById('deleteEventId').value = eventId;
            document.getElementById('deleteEventPopup').style.display = 'block';
        }
        function closeDeleteEventPopup() {
            document.getElementById('deleteEventPopup').style.display = 'none';
        }
        function showDeleteSuccessPopup() {
            document.getElementById('deleteSuccessPopup').style.display = 'block';
        }
        function closeDeleteSuccessPopup() {
            document.getElementById('deleteSuccessPopup').style.display = 'none';
        }
        function showAddEventPopup() {
            var popup = document.getElementById('addEventPopup');
            if (popup) {
                popup.classList.add('active');
                popup.style.display = 'flex';
            }
        }
        function closeAddEventPopup() {
            var popup = document.getElementById('addEventPopup');
            if (popup) {
                popup.classList.remove('active');
                popup.style.display = 'none';
            }
        }
        function showUpdateStatusPopup(bookingId, currentStatus) {
            document.getElementById('updateBookingId').value = bookingId;
            document.getElementById('updateStatusSelect').value = currentStatus;
            document.getElementById('updateStatusPopup').style.display = 'flex';
        }
        function closeUpdateStatusPopup() {
            document.getElementById('updateStatusPopup').style.display = 'none';
        }
        // If you use a popup for editing, add a function to populate the edit form fields:
        function showEditEventPopup(event) {
            document.getElementById('editEventId').value = event.id;
            document.getElementById('editEventTitle').value = event.title;
            document.getElementById('editEventDate').value = event.date;
            document.getElementById('editEventLocation').value = event.location;
            document.getElementById('editEventPrice').value = event.price > 0 ? event.price : '';
            document.getElementById('editEventDescription').value = event.description;
            document.getElementById('editEventPopup').style.display = 'flex';
        }
        function closeEditEventPopup() {
            document.getElementById('editEventPopup').style.display = 'none';
        }
        window.onload = function() {
            document.getElementById('eventsSection').classList.add('active');
            document.getElementById('navEvents').classList.add('active');
            <% if ("1".equals(request.getParameter("eventDeleted"))) { %>
            showDeleteSuccessPopup();
            <% } %>
        }
    </script>
    <style>
        /* Add a subtle fade-in for the whole page */
        body { animation: fadeIn 0.7s; }
    </style>
</body>
</html>
