<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="util.BookingFileHandler" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sessionObj = request.getSession(false);
    String username = (sessionObj != null && sessionObj.getAttribute("username") != null) ? (String) sessionObj.getAttribute("username") : null;
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    List<Map<String, String>> allBookings = BookingFileHandler.getAllBookings();
    List<Map<String, String>> userBookings = new ArrayList<>();
    for (Map<String, String> booking : allBookings) {
        if (username.equals(booking.get("username"))) {
            userBookings.add(booking);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <style>
        body {
            background: linear-gradient(120deg, #e3f0ff 0%, #f5f7fa 100%);
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
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 62px;
            box-shadow: 0 2px 8px rgba(44,62,80,0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .navbar .nav-title {
            font-size: 1.5em;
            font-weight: bold;
            margin-left: 32px;
            letter-spacing: 1px;
        }
        .navbar .nav-links {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-right: 32px;
        }
        .navbar .nav-link {
            color: #fff;
            text-decoration: none;
            font-size: 1em;
            padding: 8px 18px;
            border-radius: 4px;
            transition: background 0.18s;
        }
        .navbar .nav-link:hover, .navbar .nav-link.active {
            background: #2196F3;
            color: #fff;
        }
        .navbar .logout-btn {
            background: #f44336;
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 8px 18px;
            font-size: 1em;
            cursor: pointer;
            margin-left: 10px;
        }
        .navbar .logout-btn:hover {
            background: #c62828;
        }
        .main-title {
            text-align: center;
            font-size: 2.3em;
            font-weight: bold;
            margin-top: 38px;
            margin-bottom: 10px;
            color: #1769aa;
            letter-spacing: 1px;
        }
        .subtitle {
            text-align: center;
            color: #555;
            font-size: 1.1em;
            margin-bottom: 32px;
        }
        .bookings-container {
            max-width: 1200px;
            margin: 32px auto 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 32px;
            padding: 0 16px;
        }
        .booking-card {
            background: linear-gradient(120deg, #fff 60%, #e3f2fd 100%);
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(33,150,243,0.13);
            padding: 32px 26px 26px 26px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            position: relative;
            border: 1.5px solid #e3f2fd;
            transition: box-shadow 0.18s, transform 0.18s;
        }
        .booking-card:hover {
            box-shadow: 0 10px 32px rgba(33,150,243,0.18);
            transform: translateY(-4px) scale(1.01);
        }
        .booking-id {
            font-size: 1em;
            color: #888;
            margin-bottom: 6px;
            letter-spacing: 0.5px;
        }
        .booking-title {
            font-size: 1.35em;
            color: #2196F3;
            font-weight: bold;
            margin-bottom: 4px;
            letter-spacing: 0.5px;
        }
        .booking-info {
            font-size: 1.07em;
            color: #333;
            margin-bottom: 2px;
        }
        .booking-info ul {
            margin: 4px 0 0 18px;
            padding: 0;
        }
        .booking-info li {
            font-size: 1em;
            color: #1769aa;
            margin-bottom: 2px;
        }
        .booking-status {
            display: inline-block;
            padding: 6px 20px;
            border-radius: 14px;
            font-weight: bold;
            font-size: 1.08em;
            margin-top: 12px;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
        }
        .booking-status.Pending { background: #ffe082; color: #b28704; }
        .booking-status.Complete { background: #c8e6c9; color: #388e3c; }
        .booking-status.Canceled { background: #ffcdd2; color: #c62828; }
        .back-btn {
            display: inline-block;
            margin: 28px 0 0 0;
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 12px 32px;
            font-size: 1.1em;
            cursor: pointer;
            text-decoration: none;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
            transition: background 0.18s;
        }
        .back-btn:hover {
            background: #1769aa;
        }
        .booking-actions {
            margin-top: 10px;
            display: flex;
            gap: 12px;
        }
        .edit-booking-btn, .cancel-booking-btn, .delete-booking-btn {
            padding: 7px 18px;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.18s, transform 0.18s;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
        }
        .edit-booking-btn {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
        }
        .edit-booking-btn:hover {
            background: #1769aa;
            transform: scale(1.05);
        }
        .cancel-booking-btn {
            background: linear-gradient(90deg, #f44336 0%, #ff7961 100%);
            color: #fff;
        }
        .cancel-booking-btn:hover {
            background: #c62828;
            transform: scale(1.05);
        }
        .delete-booking-btn {
            background: linear-gradient(90deg, #b71c1c 0%, #ff5252 100%);
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 7px 18px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.18s, transform 0.18s;
            box-shadow: 0 2px 8px rgba(244,67,54,0.08);
        }
        .delete-booking-btn:hover {
            background: #d32f2f;
            transform: scale(1.05);
        }
        @media (max-width: 900px) {
            .bookings-container {
                grid-template-columns: 1fr;
                padding: 0 8px;
            }
            .navbar .nav-title {
                margin-left: 10px;
                font-size: 1.1em;
            }
            .navbar .nav-links {
                margin-right: 10px;
                gap: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="nav-title">LensLoom</div>
        <div class="nav-links">
            <a href="dashboard.jsp" class="nav-link">Dashboard</a>
            <a href="myBookings.jsp" class="nav-link active">My Bookings</a>
            <a href="profile.jsp" class="nav-link">My Profile</a>
            <form action="LogoutServlet" method="post" style="display:inline;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
    <div class="main-title">My Bookings</div>
    <div class="subtitle">Here are your current and past bookings.</div>
    <div class="bookings-container">
        <%
        if (userBookings.isEmpty()) {
        %>
            <div style="grid-column: 1 / -1; text-align: center; color: #888; font-size: 1.2em; padding: 40px 0;">
                You have no bookings yet.
            </div>
        <%
        } else {
            for (Map<String, String> booking : userBookings) {
                String location = booking.get("bookingLocation") != null && !booking.get("bookingLocation").trim().isEmpty()
                    ? booking.get("bookingLocation")
                    : "N/A";
                String serviceTypesRaw = booking.get("serviceTypes");
                String[] services = (serviceTypesRaw != null && !serviceTypesRaw.trim().isEmpty())
                    ? serviceTypesRaw.split("\\s*,\\s*")
                    : new String[0];
                List<String> cleanServices = new ArrayList<>();
                for (String s : services) {
                    if (!s.trim().isEmpty() && !s.trim().equals(location)) {
                        cleanServices.add(s.trim());
                    }
                }
                String status = booking.get("status") != null && !booking.get("status").trim().isEmpty()
                    ? booking.get("status")
                    : "Pending";
        %>
        <div class="booking-card">
            <div class="booking-id">Booking ID: <%= booking.get("id") %></div>
            <div class="booking-title"><%= booking.get("eventTitle") %></div>
            <div class="booking-info"><b>Date:</b> <%= booking.get("bookingDate") %></div>
            <div class="booking-info"><b>Service(s):</b>
                <% if (!cleanServices.isEmpty()) { %>
                    <ul>
                        <% for (String s : cleanServices) { %>
                            <li>&#10003; <%= s %></li>
                        <% } %>
                    </ul>
                <% } else { %>
                    N/A
                <% } %>
            </div>
            <div class="booking-info"><b>Location:</b> <span style="color:#1769aa;"><%= location %></span></div>
            <div class="booking-status <%= status %>"><%= status %></div>
            <% if ("Pending".equalsIgnoreCase(status)) { %>
            <div class="booking-actions">
                <button type="button" class="edit-booking-btn" onclick="showEditBookingPopup('<%= booking.get("id") %>')">Edit</button>
                <form action="CancelBookingServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this booking?');">
                    <input type="hidden" name="bookingId" value="<%= booking.get("id") %>">
                    <button type="submit" class="cancel-booking-btn">Cancel</button>
                </form>
            </div>
            <% } else if ("Canceled".equalsIgnoreCase(status)) { %>
            <div class="booking-actions">
                <form action="DeleteBookingServlet" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to permanently delete this booking?');">
                    <input type="hidden" name="bookingId" value="<%= booking.get("id") %>">
                    <button type="submit" class="delete-booking-btn">Delete</button>
                </form>
            </div>
            <% } %>
        </div>
        <% } } %>
    </div>
    <!-- Edit Booking Popup Modal -->
    <div id="editBookingPopup" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(33,150,243,0.13);z-index:9999;align-items:center;justify-content:center;">
        <div style="background:#fff;max-width:400px;width:90%;margin:60px auto;padding:28px 24px 24px 24px;border-radius:12px;box-shadow:0 4px 24px rgba(33,150,243,0.18);position:relative;">
            <button onclick="closeEditBookingPopup()" style="position:absolute;top:10px;right:16px;background:none;border:none;font-size:22px;color:#888;cursor:pointer;">&times;</button>
            <h3 style="color:#2196F3;text-align:center;margin-bottom:18px;">Edit Booking</h3>
            <form id="editBookingForm" method="post" action="EditBookingServlet">
                <input type="hidden" name="bookingId" id="editBookingId" value="">
                <div style="margin-bottom:14px;">
                    <label style="font-weight:bold;color:#1769aa;">Booking Date:</label>
                    <input type="date" name="bookingDate" id="editBookingDate" required style="width:100%;padding:8px;border-radius:4px;border:1px solid #bbb;">
                </div>
                <div style="margin-bottom:14px;">
                    <label style="font-weight:bold;color:#1769aa;">Service Type:</label>
                    <div style="padding:6px 0;">
                        <label style="margin-right:12px;">
                            <input type="checkbox" name="serviceType" value="Photographers" id="editServicePhotographers"> Photographers
                        </label>
                        <label style="margin-right:12px;">
                            <input type="checkbox" name="serviceType" value="Videographers" id="editServiceVideographers"> Videographers
                        </label>
                        <label>
                            <input type="checkbox" name="serviceType" value="Drone Shot" id="editServiceDrone"> Drone Shot
                        </label>
                    </div>
                </div>
                <div style="margin-bottom:18px;">
                    <label style="font-weight:bold;color:#1769aa;">Location:</label>
                    <input type="text" name="bookingLocation" id="editBookingLocation" required style="width:100%;padding:8px;border-radius:4px;border:1px solid #bbb;">
                </div>
                <div style="text-align:center;">
                    <button type="submit" style="background:#2196F3;color:#fff;border:none;border-radius:4px;padding:10px 32px;font-size:1em;cursor:pointer;">Save</button>
                    <button type="button" onclick="closeEditBookingPopup()" style="background:#ccc;color:#222;border:none;border-radius:4px;padding:10px 32px;font-size:1em;margin-left:10px;cursor:pointer;">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        // Store all bookings in JS for quick lookup
        var bookingsData = {};
        <% for (Map<String, String> booking : userBookings) { %>
            bookingsData["<%= booking.get("id") %>"] = {
                bookingDate: "<%= booking.get("bookingDate") %>",
                serviceTypes: "<%= booking.get("serviceTypes") != null ? booking.get("serviceTypes").replace("\"", "\\\"") : "" %>",
                bookingLocation: "<%= booking.get("bookingLocation") != null ? booking.get("bookingLocation").replace("\"", "\\\"") : "" %>"
            };
        <% } %>
        function showEditBookingPopup(bookingId) {
            var data = bookingsData[bookingId];
            if (!data) return;
            document.getElementById('editBookingId').value = bookingId;
            document.getElementById('editBookingDate').value = data.bookingDate;
            document.getElementById('editBookingLocation').value = data.bookingLocation;
            // Uncheck all first
            document.getElementById('editServicePhotographers').checked = false;
            document.getElementById('editServiceVideographers').checked = false;
            document.getElementById('editServiceDrone').checked = false;
            // Check those in serviceTypes
            if (data.serviceTypes) {
                var arr = data.serviceTypes.split(",");
                arr.forEach(function(s) {
                    var val = s.trim();
                    if (val === "Photographers") document.getElementById('editServicePhotographers').checked = true;
                    if (val === "Videographers") document.getElementById('editServiceVideographers').checked = true;
                    if (val === "Drone Shot") document.getElementById('editServiceDrone').checked = true;
                });
            }
            document.getElementById('editBookingPopup').style.display = 'flex';
        }
        function closeEditBookingPopup() {
            document.getElementById('editBookingPopup').style.display = 'none';
        }
        // Optional: close popup when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('editBookingPopup');
            if (event.target === modal) {
                closeEditBookingPopup();
            }
        }
    </script>
    <div style="text-align:center;margin:32px 0;">
        <a href="dashboard.jsp" class="back-btn">&#8592; Back to Dashboard</a>
    </div>
</body>
</html>
