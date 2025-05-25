package com.example.event_booking_project_90.servlet;

import util.BookingFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null && !bookingId.trim().isEmpty()) {
            List<Map<String, String>> bookings = BookingFileHandler.getAllBookings();
            Iterator<Map<String, String>> it = bookings.iterator();
            while (it.hasNext()) {
                Map<String, String> booking = it.next();
                if (bookingId.equals(booking.get("id"))) {
                    it.remove();
                    break;
                }
            }
            BookingFileHandler.overwriteBookings(bookings);
        }
        response.sendRedirect("myBookings.jsp");
    }
}



