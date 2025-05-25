package com.example.event_booking_project_90.servlet;

import com.example.event_booking_project_90.util.BookingFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        if (bookingId != null && !bookingId.trim().isEmpty()) {
            BookingFileHandler.updateBookingStatus(bookingId, "Canceled");
        }
        response.sendRedirect("myBookings.jsp");
    }
}
