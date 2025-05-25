package com.example.event_booking_project_90.servlet;

import util.BookingFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/EditBookingServlet")
public class EditBookingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendRedirect("myBookings.jsp");
            return;
        }
        List<Map<String, String>> bookings = BookingFileHandler.getAllBookings();
        for (Map<String, String> booking : bookings) {
            if (bookingId.equals(booking.get("id"))) {
                request.setAttribute("booking", booking);
                break;
            }
        }
        request.getRequestDispatcher("editBooking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        String bookingDate = request.getParameter("bookingDate");
        String[] serviceTypes = request.getParameterValues("serviceType");
        String bookingLocation = request.getParameter("bookingLocation");
        String price = request.getParameter("price");

        // Read all bookings, update the matching one, and write back
        List<Map<String, String>> bookings = BookingFileHandler.getAllBookings();
        for (Map<String, String> booking : bookings) {
            if (bookingId.equals(booking.get("id"))) {
                booking.put("bookingDate", bookingDate);
                booking.put("serviceTypes", serviceTypes != null ? String.join(", ", serviceTypes) : "");
                booking.put("bookingLocation", bookingLocation);
                break;
            }
        }
        BookingFileHandler.overwriteBookings(bookings);
        response.sendRedirect("myBookings.jsp");
    }
}
