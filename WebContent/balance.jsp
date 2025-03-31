<%@ page import="java.sql.*" %>
<%
    // Ensure user is logged in
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Database connection details
    String jdbcUrl = "jdbc:mysql://localhost:3306/banking_db";
    String dbUser = "balasaravanan";
    String dbPass = "balasaravanan18@";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    double balance = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

        // ✅ Get the account ID of the logged-in user
        String getAccountSQL = "SELECT account_id FROM accounts WHERE user_id = ?";
        PreparedStatement getAccountStmt = conn.prepareStatement(getAccountSQL);
        getAccountStmt.setInt(1, userId);
        ResultSet accountRs = getAccountStmt.executeQuery();

        if (accountRs.next()) {
            int accountId = accountRs.getInt("account_id");

            // ✅ Fetch the updated balance
            String sql = "SELECT balance FROM balances WHERE account_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, accountId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                balance = rs.getDouble("balance");
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
    <title>Account Balance</title>
     <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/homepage.css">
   <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
</head>
<body>
    <h2>Your Account Balance: ₹<%= balance %></h2>
    <a href="homepage.jsp">Back to Home</a>
</body>
</html>