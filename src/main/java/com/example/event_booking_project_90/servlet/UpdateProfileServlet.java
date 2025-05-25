package com.example.event_booking_project_90.servlet;

import com.example.event_booking_project_90.util.UserFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String oldUsername = (String) request.getSession().getAttribute("username");
        String newUsername = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Find and update user
        boolean updated = false;
        List<Map<String, String>> users = UserFileHandler.getAllUsers();
        if (users != null && oldUsername != null) {
            for (Map<String, String> user : users) {
                if (oldUsername.equals(user.get("username"))) {
                    user.put("username", newUsername);
                    user.put("email", email);
                    if (password != null && !password.trim().isEmpty()) {
                        user.put("password", password);
                    }
                    updated = true;
                    break;
                }
            }
            if (updated) {
                // FIX: Use setAllUsers if saveAllUsers does not exist
                UserFileHandler.setAllUsers(users);
                // Update session username if changed
                if (!oldUsername.equals(newUsername)) {
                    request.getSession().setAttribute("username", newUsername);
                }
                response.sendRedirect("profile.jsp?updateMsg=success");
                return;
            }
        }
        response.sendRedirect("profile.jsp?updateMsg=Update+failed");
    }
}
