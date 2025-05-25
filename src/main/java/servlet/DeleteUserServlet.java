package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import util.UserFileHandler;

public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        if (username != null && !"admin".equals(username)) {
            UserFileHandler.deleteUser(username);
        }
        response.sendRedirect("adminDashboard.jsp");
    }
}
