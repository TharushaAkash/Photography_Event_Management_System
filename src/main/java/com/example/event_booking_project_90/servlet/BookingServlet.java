package com.example.event_booking_project_90.servlet;

import com.example.event_booking_project_90.model.Booking;
import com.example.event_booking_project_90.util.BookingManagement;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/addBooking")
public class BookingServlet extends HttpServlet {
    private BookingManagement bookingManagement;

    @Override
    public void init() {
        bookingManagement = new BookingManagement(getServletContext());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingID = bookingManagement.getNextBookingID();
        String clientName = request.getParameter("clientName");
        String eventType = request.getParameter("eventType");
        String eventDate = request.getParameter("eventDate");
        String location = request.getParameter("location");
        String photographerId = request.getParameter("photographerId");

        if (clientName != null && eventType != null && eventDate != null && location != null && photographerId != null) {
            Booking booking = new Booking(bookingID, clientName, eventType, eventDate, location, photographerId);
            bookingManagement.addBooking(booking);

            request.setAttribute("bookingID", bookingID);
            request.setAttribute("clientName", clientName);
            request.setAttribute("eventType", eventType);
            request.setAttribute("eventDate", eventDate);
            request.setAttribute("location", location);
            request.setAttribute("photographerId", photographerId);

            request.getRequestDispatcher("booking-success.jsp").forward(request, response);
        } else {
            response.sendRedirect("error.jsp");
        }
    }
}


