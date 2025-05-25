package com.example.event_booking_project_90.servlet;


import com.example.event_booking_project_90.model.Photography;
import com.example.event_booking_project_90.util.PhotoEventFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/EditEventServlet")
public class EditEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form parameters
            String eventId = request.getParameter("eventId");
            String title = request.getParameter("title");
            String date = request.getParameter("date");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String username = request.getParameter("username");
            double price = Double.parseDouble(request.getParameter("price"));

            // Get existing event
            Photography event = PhotoEventFileHandler.getEventById(eventId);

            if (event != null) {
                // Update event properties
                event.setTitle(title);
                event.setDate(date);
                event.setLocation(location);
                event.setPrice(price);
                event.setDescription(description);
                event.setUsername(username);

                // Save updated event
                boolean success = PhotoEventFileHandler.updateEvent(event);

                if (success) {
                    response.sendRedirect("adminDashboard.jsp?success=true");
                } else {
                    response.sendRedirect("error.jsp?errorType=updateFailed");
                }
            } else {
                response.sendRedirect("error.jsp?errorType=eventNotFound");
            }
        } catch (Exception e) {
            getServletContext().log("Error in EditEventServlet", e);
            response.sendRedirect("error.jsp?errorType=exception&message=" + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventId = request.getParameter("eventId");

        if (eventId != null && !eventId.isEmpty()) {
            // Fetch the event and forward to an edit page
            Photography event = PhotoEventFileHandler.getEventById(eventId);

            if (event != null) {
                request.setAttribute("event", event);
                request.getRequestDispatcher("editEvent.jsp").forward(request, response);
                return;
            }
        }

        // If no valid event ID or event not found, redirect to main page
        response.sendRedirect("index.jsp");
    }
}
