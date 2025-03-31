<%@ page import="java.sql.*" %>
<%
    // Ensure user is logged in
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get deposit amount from form
    String amountStr = request.getParameter("amount");
    if (amountStr == null || amountStr.isEmpty()) {
        out.println("<script>alert('Please enter a valid deposit amount!'); window.location.href='deposit.jsp';</script>");
        return;
    }

    double amount = Double.parseDouble(amountStr);
    if (amount <= 0) {
        out.println("<script>alert('Deposit amount must be greater than zero!'); window.location.href='deposit.jsp';</script>");
        return;
    }

    // Database connection details
    String jdbcUrl = "jdbc:mysql://localhost:3306/banking_db";
    String dbUser = "balasaravanan";
    String dbPass = "balasaravanan18@";

    Connection conn = null;
    PreparedStatement getBalanceStmt = null;
    PreparedStatement updateBalanceStmt = null;
    PreparedStatement insertBalanceStmt = null;
    PreparedStatement insertTransactionStmt = null;

    try {
        // Load MySQL Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
        conn.setAutoCommit(false); // Start transaction

        // ✅ Get account ID for the user
        String getAccountSQL = "SELECT account_id FROM accounts WHERE user_id = ?";
        PreparedStatement getAccountStmt = conn.prepareStatement(getAccountSQL);
        getAccountStmt.setInt(1, userId);
        ResultSet rs = getAccountStmt.executeQuery();

        if (!rs.next()) {
            out.println("<script>alert('Error: Account not found!'); window.location.href='deposit.jsp';</script>");
            return;
        }

        int accountId = rs.getInt("account_id");

        // ✅ Check if balance exists for the account
        String checkBalanceSQL = "SELECT balance FROM balances WHERE account_id = ?";
        getBalanceStmt = conn.prepareStatement(checkBalanceSQL);
        getBalanceStmt.setInt(1, accountId);
        ResultSet balanceResult = getBalanceStmt.executeQuery();

        if (balanceResult.next()) {
            double currentBalance = balanceResult.getDouble("balance");

            // ✅ Update balance in `balances` table
            String updateBalanceSQL = "UPDATE balances SET balance = balance + ? WHERE account_id = ?";
            updateBalanceStmt = conn.prepareStatement(updateBalanceSQL);
            updateBalanceStmt.setDouble(1, amount);
            updateBalanceStmt.setInt(2, accountId);
            updateBalanceStmt.executeUpdate();

            out.println("<script>console.log('Balance updated: Old Balance = " + currentBalance + ", New Balance = " + (currentBalance + amount) + "');</script>");
        } else {
            // ✅ If no balance exists, insert a new record
            String insertBalanceSQL = "INSERT INTO balances (account_id, balance) VALUES (?, ?)";
            insertBalanceStmt = conn.prepareStatement(insertBalanceSQL);
            insertBalanceStmt.setInt(1, accountId);
            insertBalanceStmt.setDouble(2, amount);
            insertBalanceStmt.executeUpdate();

            out.println("<script>console.log('New balance created with amount: " + amount + "');</script>");
        }

        // ✅ Insert transaction record in `transactions` table
        String insertTransactionSQL = "INSERT INTO transactions (account_id, transaction_type, amount, description) VALUES (?, 'DEPOSIT', ?, 'Deposit made')";
        insertTransactionStmt = conn.prepareStatement(insertTransactionSQL);
        insertTransactionStmt.setInt(1, accountId);
        insertTransactionStmt.setDouble(2, amount);
        insertTransactionStmt.executeUpdate();

        conn.commit(); // Commit all updates

        out.println("<script>alert('Deposit successful!'); window.location.href='balance.jsp';</script>");
    } catch (Exception e) {
        if (conn != null) conn.rollback(); // Rollback if error occurs
        out.println("<script>alert('Error processing deposit! Check console for details.'); window.location.href='deposit.jsp';</script>");
        e.printStackTrace();
    } finally {
        if (getBalanceStmt != null) getBalanceStmt.close();
        if (updateBalanceStmt != null) updateBalanceStmt.close();
        if (insertBalanceStmt != null) insertBalanceStmt.close();
        if (insertTransactionStmt != null) insertTransactionStmt.close();
        if (conn != null) conn.close();
    }
%>
