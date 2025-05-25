<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Event Booking System - Home</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(120deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
        }
        .navbar {
            width: 100vw;
            min-width: 320px;
            background: linear-gradient(90deg, #232946 60%, #2196F3 100%);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            height: 70px;
            box-sizing: border-box;
            box-shadow: 0 4px 24px rgba(33,150,243,0.10);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
            animation: fadeInDown 0.7s;
        }
        .navbar .brand {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .navbar .brand-logo {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #e3f2fd;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2em;
            color: #2196F3;
            box-shadow: 0 2px 8px rgba(33,150,243,0.12);
        }
        .navbar .brand-title {
            font-size: 1.5em;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .navbar .nav-btns {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .navbar .nav-btn {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 22px;
            font-size: 1em;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s, box-shadow 0.2s;
            box-shadow: 0 2px 8px rgba(33,150,243,0.08);
            outline: none;
            white-space: nowrap;
        }
        .navbar .nav-btn:active,
        .navbar .nav-btn:focus {
            outline: 2px solid #1769aa;
        }
        .navbar .nav-btn:hover {
            background: linear-gradient(90deg, #1769aa 0%, #21CBF3 100%);
            box-shadow: 0 4px 16px rgba(33,150,243,0.15);
        }
        @media (max-width: 700px) {
            .navbar {
                flex-direction: column;
                align-items: flex-start;
                height: auto;
                padding: 0 8px;
            }
            .navbar .nav-btns {
                margin-top: 8px;
                width: 100%;
                justify-content: flex-end;
            }
        }
        .main-hero {
            margin-top: 90px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 60px;
            padding: 40px 0 30px 0;
            animation: fadeInUp 1s;
        }
        .hero-text {
            max-width: 480px;
        }
        .hero-title {
            color: #2196F3;
            font-size: 2.7em;
            font-weight: bold;
            margin-bottom: 18px;
            letter-spacing: 1px;
            text-shadow: 0 2px 8px rgba(33,150,243,0.08);
        }
        .hero-desc {
            color: #444;
            font-size: 1.25em;
            margin-bottom: 32px;
        }
        .hero-btn {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 16px 40px;
            font-size: 1.2em;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 0 2px 8px #2196f344;
            transition: background 0.18s, transform 0.18s;
        }
        .hero-btn:hover {
            background: #1769aa;
            transform: scale(1.04);
        }
        .hero-img {
            width: 420px;
            height: 320px;
            border-radius: 18px;
            object-fit: cover;
            box-shadow: 0 8px 32px rgba(33,150,243,0.13);
            animation: fadeInCard 1.2s;
        }
        .section-title {
            text-align: center;
            color: #2196F3;
            font-size: 2em;
            margin: 60px 0 24px 0;
            font-weight: bold;
            letter-spacing: 1px;
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
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-40px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(40px);}
            to { opacity: 1; transform: translateY(0);}
        }
        @keyframes fadeInCard {
            from { opacity: 0; transform: scale(0.95);}
            to { opacity: 1; transform: scale(1);}
        }
        @media (max-width: 1100px) {
            .main-hero { flex-direction: column; gap: 30px; }
            .hero-img { width: 90vw; max-width: 420px; }
        }
        @media (max-width: 700px) {
            .main-hero { padding: 20px 0 10px 0; }
            .services-cards, .ratings-cards { gap: 16px; }
        }
        .popup-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            width: 100vw; height: 100vh;
            background: rgba(0,0,0,0.45);
            z-index: 9999;
            display: none;
            align-items: center;
            justify-content: center;
        }
        .popup-content {
            background: #fff;
            border-radius: 12px;
            padding: 32px 28px 24px 28px;
            max-width: 350px;
            width: 95vw;
            box-shadow: 0 8px 32px rgba(33,150,243,0.18);
            position: relative;
            animation: fadeInUp 0.5s;
        }
        .close-btn {
            position: absolute;
            top: 12px;
            right: 18px;
            font-size: 24px;
            color: #333;
            background: none;
            border: none;
            cursor: pointer;
            transition: color 0.18s;
        }
        .close-btn:hover {
            color: #f44336;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            font-weight: bold;
            color: #1769aa;
            display: block;
            margin-bottom: 7px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1.5px solid #bbb;
            border-radius: 6px;
            font-size: 1em;
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
        }
        .form-actions input[type="submit"] {
            background: linear-gradient(90deg, #2196F3 0%, #21CBF3 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 10px 32px;
            font-size: 1.08em;
            cursor: pointer;
            font-weight: bold;
            margin-top: 8px;
            box-shadow: 0 2px 8px #2196f344;
            transition: background 0.18s, transform 0.18s;
        }
        .form-actions input[type="submit"]:hover {
            background: #1769aa;
            transform: scale(1.04);
        }
    </style>
    <script>
        function showPopup(id) {
            var popup = document.getElementById(id);
            if (popup) {
                popup.style.display = 'flex';
                popup.style.alignItems = 'center';
                popup.style.justifyContent = 'center';
            }
        }
        function closePopup(id) {
            var popup = document.getElementById(id);
            if (popup) popup.style.display = 'none';
        }
        window.onclick = function(event) {
            ['loginPopup','registerPopup'].forEach(function(id){
                var popup = document.getElementById(id);
                if (popup && event.target === popup) {
                    popup.style.display = "none";
                }
            });
        }
        function handleEventManagerClick(isLoggedIn) {
            if (isLoggedIn) {
                window.location.href = "home.jsp";
            } else {
                showPopup('loginPopup');
            }
        }
    </script>
</head>
<body>
    <%
        boolean loggedIn = false;
        if (session != null && session.getAttribute("username") != null) {
            loggedIn = true;
        }
    %>
    <!-- Navbar -->
    <div class="navbar">
        <div class="brand">
            <div class="brand-logo">
                <span>&#128247;</span>
            </div>
            <span class="brand-title">LensLoom</span>
        </div>
        <div class="nav-btns">
            <% if (!loggedIn) { %>
                <button onclick="showPopup('loginPopup')" class="nav-btn">Sign In</button>
                <button onclick="showPopup('registerPopup')" class="nav-btn">Sign Up</button>
            <% } %>
        </div>
    </div>
    <!-- Hero Section -->
    <div class="main-hero">
        <div class="hero-text">
            <div class="hero-title">Capture Your Moments, Book Your Event</div>
            <div class="hero-desc">
                Discover and book the best photography events for your special occasions.<br>
                Enjoy seamless booking, professional services, and unforgettable memories.
            </div>
            <button class="hero-btn" onclick="handleEventManagerClick(<%= loggedIn %>)">Explore Events</button>
        </div>
        <img class="hero-img" src="https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80" alt="Event Photography">
    </div>
    <!-- Our Services Section -->
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
    <!-- Customer Ratings Section -->
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
    <!-- Login Popup -->
    <div id="loginPopup" class="popup-overlay" style="display:none;">
        <div class="popup-content" style="background:linear-gradient(120deg,#e3f2fd 0%,#fff 100%);box-shadow:0 8px 32px #2196f344;max-width:370px;">
            <button class="close-btn" onclick="closePopup('loginPopup')">&times;</button>
            <div style="text-align:center;">
                <div style="font-size:2.2em;color:#2196F3;margin-bottom:10px;">
                    <span>&#128274;</span>
                </div>
                <h2 style="margin:0 0 8px 0;color:#232946;">Welcome Back!</h2>
                <div style="color:#1769aa;font-size:1.08em;margin-bottom:18px;">Login to your account</div>
            </div>
            <form action="LoginServlet" method="post" autocomplete="off">
                <div class="form-group">
                    <label for="login-username">Name</label>
                    <input type="text" id="login-username" name="username" placeholder="Enter your name" required style="background:#f7fafc;">
                </div>
                <div class="form-group">
                    <label for="login-password">Password</label>
                    <input type="password" id="login-password" name="password" placeholder="Enter your password" required style="background:#f7fafc;">
                </div>
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">
                    <label style="font-size:0.98em;color:#555;">
                        <input type="checkbox" name="remember" style="margin-right:6px;"> Remember me
                    </label>
                    <a href="#" style="color:#2196F3;font-size:0.98em;text-decoration:underline;">Forgot?</a>
                </div>
                <div class="form-actions">
                    <input type="submit" value="Login" style="background:linear-gradient(90deg,#2196F3 0%,#21CBF3 100%);font-size:1.1em;">
                </div>
            </form>
            <div style="margin-top:18px;text-align:center;">
                <span style="color:#555;font-size:0.98em;">Don't have an account?</span>
                <a href="javascript:void(0);" onclick="closePopup('loginPopup');showPopup('registerPopup');" style="color:#2196F3;font-weight:bold;text-decoration:underline;margin-left:6px;">Register</a>
            </div>
        </div>
    </div>
    <!-- Register Popup -->
    <div id="registerPopup" class="popup-overlay" style="display:none;">
        <div class="popup-content" style="background:linear-gradient(120deg,#e3f2fd 0%,#fff 100%);box-shadow:0 8px 32px #2196f344;max-width:370px;">
            <button class="close-btn" onclick="closePopup('registerPopup')">&times;</button>
            <div style="text-align:center;">
                <div style="font-size:2.2em;color:#2196F3;margin-bottom:10px;">
                    <span>&#128100;</span>
                </div>
                <h2 style="margin:0 0 8px 0;color:#232946;">Create Account</h2>
                <div style="color:#1769aa;font-size:1.08em;margin-bottom:18px;">Register to get started</div>
            </div>
            <form action="register" method="post" autocomplete="off">
                <div class="form-group">
                    <label for="register-username">Name</label>
                    <input type="text" id="register-username" name="username" placeholder="Enter your name" required style="background:#f7fafc;">
                </div>
                <div class="form-group">
                    <label for="register-email">E-mail</label>
                    <input type="email" id="register-email" name="email" placeholder="Enter your email" required style="background:#f7fafc;">
                </div>
                <div class="form-group">
                    <label for="register-password">Password</label>
                    <input type="password" id="register-password" name="password" placeholder="Enter your password" required style="background:#f7fafc;">
                </div>
                <div class="form-actions">
                    <input type="submit" value="Register" style="background:linear-gradient(90deg,#2196F3 0%,#21CBF3 100%);font-size:1.1em;">
                </div>
            </form>
            <div style="margin-top:18px;text-align:center;">
                <span style="color:#555;font-size:0.98em;">Already have an account?</span>
                <a href="javascript:void(0);" onclick="closePopup('registerPopup');showPopup('loginPopup');" style="color:#2196F3;font-weight:bold;text-decoration:underline;margin-left:6px;">Login</a>
            </div>
        </div>
    </div>
    <!-- Footer Section -->
    <footer style="background:linear-gradient(90deg,#232946 60%,#2196F3 100%);color:#fff;padding:36px 0 18px 0;text-align:center;margin-top:40px;">
        <div style="max-width:900px;margin:0 auto;">
            <div style="font-size:1.3em;font-weight:bold;letter-spacing:1px;margin-bottom:10px;">
                LensLoom
            </div>
            <div style="margin-bottom:12px;">
                <span style="margin:0 12px;">&#128197; Easy Booking</span>
                <span style="margin:0 12px;">&#128247; Professional Photography</span>
                <span style="margin:0 12px;">&#127909; Videography</span>
                <span style="margin:0 12px;">&#128663; Drone Shots</span>
            </div>
            <div style="margin-bottom:10px;">
                <a href="mailto:info@eventbooking.com" style="color:#fff;text-decoration:underline;margin:0 8px;">info@lensloom.com</a> |
                <span style="margin:0 8px;">Colombo, Sri Lanka</span>
            </div>
            <div style="font-size:0.98em;color:#e3f2fd;">
                &copy; <%= java.time.Year.now() %> Event Booking System. All rights reserved.
            </div>
        </div>
    </footer>
</body>
</html>
