<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*" %>

<%
    // Check if the user is logged in
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("user_id"); // Ensure user_id is stored in session

    if (username == null || userId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if session is not set
        return;
    }
%>

<html>
<head>
    <title>ESB - Home</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/homepage.css">
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
    
</head>
<body>
    <h1>Welcome, <%= username %></h1>
    <div class="top-bar">
        
        <a href="logout.jsp" class="logout-btn">Logout</a>
    </div>

    <div class="menu">
        <a href="account.jsp">Account Details</a>
        <a href="balance.jsp">Balance</a>
        <a href="deposit.jsp">Deposit Money Here</a>
        <a href="transaction.jsp">Transaction History</a>
        <a href="loanapplication.jsp">Loan Application</a>
    </div>

    <footer>
        <p>© 2025 Secure Bank. All Rights Reserved.</p>
        <p>Contact Us: support@ESB.com | +91 98765 43210</p>
    </footer>

</body>
</html>
