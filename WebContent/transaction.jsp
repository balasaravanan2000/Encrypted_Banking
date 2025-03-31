<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>Transaction History</title>
     <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/transc.css">
   <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
</head>
<body>
    <h2>Transaction History</h2>
    

    <% 
        Integer userId = (Integer) session.getAttribute("user_id");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Database credentials
        String dbURL = "jdbc:mysql://localhost:3306/banking_db";
        String dbUser = "balasaravanan";
        String dbPassword = "balasaravanan18@";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Get account ID for the logged-in user
            String getAccountQuery = "SELECT account_id FROM accounts WHERE user_id = ?";
            PreparedStatement getAccountStmt = conn.prepareStatement(getAccountQuery);
            getAccountStmt.setInt(1, userId);
            rs = getAccountStmt.executeQuery();

            int accountId = -1;
            if (rs.next()) {
                accountId = rs.getInt("account_id");
            }

            // Fetch transaction history
            String query = "SELECT transaction_id, amount, transaction_type, transaction_date FROM transactions WHERE account_id = ? ORDER BY transaction_date DESC";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, accountId);
            rs = stmt.executeQuery();
    %>

    <table border="1">
        <tr>
            <th>Transaction ID</th>
            <th>Amount</th>
            <th>Type</th>
            <th>Date</th>
        </tr>
        <% while (rs.next()) { %>
        <tr>
            <td><%= rs.getInt("transaction_id") %></td>
            <td><%= rs.getDouble("amount") %></td>
            <td><%= rs.getString("transaction_type") %></td>
            <td><%= rs.getTimestamp("transaction_date") %></td>
        </tr>
        <% } %>
    </table>

    <br>
    <a href="homepage.jsp">Back to Home</a>

    <% 
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error fetching transactions!');</script>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
