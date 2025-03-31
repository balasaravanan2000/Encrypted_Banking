<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>ESB</title>
   <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/esb.css">




    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">

</head>
<body>
    


    
    <img src="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
    
   
    <h1>Welcome to ESB</h1>
    <div id="clock" style="font-size: 18px; font-weight: bold; color: white;"></div>
    <form action="login.jsp" method="post">
        <input type="text" name="email" placeholder="Email or Phone Number" required><br><br>
        <input type="password" name="password" placeholder="Password" required><br><br>
        <input type="submit" value="Login"> <br><br>
        <a href="#">Forget password?</a>
    </form>
    <footer>
        <p>Stay Safe! Beware of Phishing Emails/Sms.Never Share Your Atm Card details/Pins/OTPs/Passwords with anyone.</p>
        <p>© 2025 Secure Bank. All Rights Reserved.</p>
        <p>Contact Us: support@ESB.com | +91 98765 43210</p>
    </footer>
    <script src="<%= request.getContextPath() %>/js/1.js"></script>
</body>
</html>