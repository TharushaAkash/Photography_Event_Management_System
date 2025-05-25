package servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import util.UserFileHandler;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET not supported. Use POST.");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        boolean success = UserFileHandler.addUser(username, email, password);
        if (success) {
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("error", "Username already exists");
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
        }
    }
}