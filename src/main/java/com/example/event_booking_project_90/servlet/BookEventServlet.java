package com.example.event_booking_project_90.servlet;

import com.example.event_booking_project_90.model.Photography;
import com.example.event_booking_project_90.util.PhotoEventFileHandler;
import com.example.event_booking_project_90.util.BookingFileHandler;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/BookEventServlet")
public class BookEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventId = request.getParameter("eventId");
        String eventTitle = request.getParameter("eventTitle");
        String username = request.getParameter("username");
        String bookingDate = request.getParameter("bookingDate");
        String[] serviceTypes = request.getParameterValues("serviceType");
        String bookingLocation = request.getParameter("bookingLocation");

        // Payment details (if needed)
        String cardNumber = request.getParameter("cardNumber");
        String cardName = request.getParameter("cardName");
        String cardExpiry = request.getParameter("cardExpiry");
        String cardCVC = request.getParameter("cardCVC");
        String billingAddress = request.getParameter("billingAddress");
        String billingCity = request.getParameter("billingCity");
        String billingZip = request.getParameter("billingZip");

        String bookingId = UUID.randomUUID().toString();
        String serviceTypesStr = "";
        if (serviceTypes != null) {
            serviceTypesStr = String.join(", ", serviceTypes);
        }

        try {
            // Validate the event exists
            Photography event = PhotoEventFileHandler.getEventById(eventId);

            if (event != null) {
                // Store booking using BookingFileHandler
                // --- FIX: Use absolute path for BookingFileHandler ---
                BookingFileHandler.addBooking(
                    bookingId,
                    username,
                    eventId,
                    eventTitle,
                    bookingDate,
                    serviceTypesStr,
                    bookingLocation,
                    billingAddress,
                    billingCity,
                    billingZip,
                    "Pending"
                );
                // Redirect to dashboard or payment success page
                response.sendRedirect("dashboard.jsp?bookingSuccess=1");
            } else {
                response.sendRedirect("dashboard.jsp?error=eventNotFound");
            }
        } catch (Exception e) {
            getServletContext().log("Error in BookEventServlet", e);
            response.sendRedirect("error.jsp?errorType=booking&message=" + e.getMessage());
        }
    }
}
