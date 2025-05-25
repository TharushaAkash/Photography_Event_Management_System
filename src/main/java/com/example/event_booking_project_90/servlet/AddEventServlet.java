package com.example.event_booking_project_90.servlet;

import com.example.event_booking_project_90.model.Photography;
import com.example.event_booking_project_90.util.PhotoEventFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddEventServlet")
public class AddEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String title = request.getParameter("title");
            String date = request.getParameter("date");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String username = request.getParameter("username");
            double price = Double.parseDouble(request.getParameter("price"));

            // Create new Photography event
            Photography event = new Photography();
            event.setTitle(title);
            event.setDate(date);
            event.setLocation(location);
            event.setDescription(description);
            event.setUsername(username);
            event.setPrice(price);

            // Save event
            boolean success = PhotoEventFileHandler.saveEvent(event);

            if (success) {
                // Redirect back to the index page on success
                response.sendRedirect("adminDashboard.jsp?success=true");
            } else {
                // Redirect to error page if save failed
                response.sendRedirect("error.jsp?errorType=saveFailed");
            }
        } catch (Exception e) {
            // Log the error
            getServletContext().log("Error in AddEventServlet", e);

            // Redirect to error page
            response.sendRedirect("error.jsp?errorType=exception&message=" + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to the main page
        response.sendRedirect("index.jsp");
    }
}