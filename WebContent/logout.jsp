<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    // Invalidate the session to log out the user
    session.invalidate();

    // Redirect to login page
    response.sendRedirect("login.jsp");
%>
