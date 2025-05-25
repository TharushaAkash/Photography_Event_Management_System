package com.example.event_booking_project_90.servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import com.example.event_booking_project_90.util.UserFileHandler;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if ("admin".equals(username) && "admin123".equals(password)) {
            // Redirect admin to the admin dashboard
            request.getSession().setAttribute("username", username);
            response.sendRedirect("adminDashboard.jsp");
            return;
        }
        if (UserFileHandler.validateUser(username, password)) {
            // Set username in session so it can be displayed in dashboard.jsp
            request.getSession().setAttribute("username", username);
            response.sendRedirect("dashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid credentials");
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
        }
    }
}
