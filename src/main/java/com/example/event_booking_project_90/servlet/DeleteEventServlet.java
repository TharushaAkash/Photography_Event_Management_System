package com.example.event_booking_project_90.servlet;


import com.example.event_booking_project_90.util.PhotoEventFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteEventServlet")
public class DeleteEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String eventId = request.getParameter("eventId");

            if (eventId != null && !eventId.isEmpty()) {
                boolean success = PhotoEventFileHandler.deleteEvent(eventId);

                if (success) {
                    response.sendRedirect("adminDashboard.jsp?deleted=true");
                } else {
                    response.sendRedirect("error.jsp?errorType=deleteFailed");
                }
            } else {
                response.sendRedirect("error.jsp?errorType=invalidEventId");
            }
        } catch (Exception e) {
            getServletContext().log("Error in DeleteEventServlet", e);
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
