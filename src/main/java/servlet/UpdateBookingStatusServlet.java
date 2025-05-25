package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import util.BookingFileHandler;

public class UpdateBookingStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        String status = request.getParameter("status");
        if (bookingId != null && status != null) {
            BookingFileHandler.updateBookingStatus(bookingId, status);
        }
        response.sendRedirect("adminDashboard.jsp");
    }
}
