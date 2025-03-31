<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Ensure user is logged in
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Deposit Money</title>
     <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/loan.css">
   <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
</head>
<body>
    <h2>Deposit Money</h2>
    <form action="processDeposit.jsp" method="post">
        <label for="amount">Enter Amount:</label>
        <input type="number" name="amount" id="amount" required min="1" step="0.01">
        <input type="hidden" name="user_id" value="<%= userId %>">
        <button type="submit">Deposit</button>
    </form>
    <br>
    <a href="homepage.jsp">Back to Home</a>
</body>
</html>
