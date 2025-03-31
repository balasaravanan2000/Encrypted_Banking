<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Account Details</title>
     <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/acc.css">
</head>
<body>
    <h2>Your Account Details</h2>
    <a href="homepage.jsp" style="
    font-size: 24px; 
    color: white; 
    text-decoration: none; 
    position: fixed; 
    top: 20px; 
    left: 20px; 
    background-color: rgba(0, 0, 0, 0.6); 
    padding: 10px 15px; 
    border-radius: 5px;
    font-weight: bold;">
    ⬅ Home
    </a>

    
    <table border="1">
        <tr><th>Account Number</th><th>Account Type</th><th>Created At</th></tr>
        <%
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/banking_db", "balasaravanan", "balasaravanan18@");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT account_number, account_type, created_at FROM accounts WHERE user_id=1");
            while (rs.next()) {
                out.println("<tr><td>" + rs.getString("account_number") + "</td><td>" + rs.getString("account_type") + "</td><td>" + rs.getTimestamp("created_at") + "</td></tr>");
            }
            rs.close();
            stmt.close();
            con.close();
        %>
    </table>
    <footer>
        
        <p>© 2025 Secure Bank. All Rights Reserved.</p>
        <p>Contact Us: support@ESB.com | +91 98765 43210</p>
    </footer>
</body>
</html>