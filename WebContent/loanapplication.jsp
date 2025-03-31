<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*" %>

<%
    // Ensure user is logged in
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("user_id");

    if (username == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Database connection details
    String dbURL = "jdbc:mysql://localhost:3306/banking_db";
    String dbUser = "balasaravanan";
    String dbPassword = "balasaravanan18@";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    Integer accountId = null;
    String errorMessage = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Fetch user's account_id
        String getAccountQuery = "SELECT account_id FROM accounts WHERE user_id = ?";
        pstmt = conn.prepareStatement(getAccountQuery);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            accountId = rs.getInt("account_id");
        } else {
            errorMessage = "No account found. Please create an account first.";
        }

        // Handle Loan Application Submission
        if (request.getMethod().equalsIgnoreCase("POST") && accountId != null) {
            double loanAmount = Double.parseDouble(request.getParameter("loan_amount"));
            double interestRate = Double.parseDouble(request.getParameter("interest_rate"));
            int tenureMonths = Integer.parseInt(request.getParameter("tenure_months"));

            // Insert Loan Application
            String loanQuery = "INSERT INTO loan_applications (user_id, account_id, loan_amount, interest_rate, tenure_months, loan_status) VALUES (?, ?, ?, ?, ?, 'PENDING')";
            pstmt = conn.prepareStatement(loanQuery);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, accountId);
            pstmt.setDouble(3, loanAmount);
            pstmt.setDouble(4, interestRate);
            pstmt.setInt(5, tenureMonths);
            pstmt.executeUpdate();
        }

    } catch (Exception e) {
        errorMessage = "Error: " + e.getMessage();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
    <title>Loan Application</title>
     <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/loan.css">
   <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/images/icons8-euro-bank-building-48.png">
</head>
<body>
    <h1>Loan Application</h1>
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
    <% if (errorMessage != null) { %>
        <p style="color: red;"><%= errorMessage %></p>
    <% } %>

    <% if (accountId != null) { %>
        <form method="post">
            <label>Loan Amount:</label>
            <input type="number" name="loan_amount" required><br>

            <label>Interest Rate (%):</label>
            <input type="number" name="interest_rate" step="0.1" required><br>

            <label>Tenure (Months):</label>
            <input type="number" name="tenure_months" required><br>

            <button type="submit">Apply</button>
        </form>

        <h2>My Loan Applications</h2>
        <table border="1">
            <tr>
                <th>Loan ID</th>
                <th>Amount</th>
                <th>Interest Rate</th>
                <th>Tenure</th>
                <th>Status</th>
                <th>Applied Date</th>
            </tr>
            <%
                try {
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    String fetchLoansQuery = "SELECT loan_id, loan_amount, interest_rate, tenure_months, loan_status, applied_date FROM loan_applications WHERE user_id = ?";
                    pstmt = conn.prepareStatement(fetchLoansQuery);
                    pstmt.setInt(1, userId);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
            %>
                        <tr>
                            <td><%= rs.getInt("loan_id") %></td>
                            <td><%= rs.getDouble("loan_amount") %></td>
                            <td><%= rs.getDouble("interest_rate") %>%</td>
                            <td><%= rs.getInt("tenure_months") %> months</td>
                            <td><%= rs.getString("loan_status") %></td>
                            <td><%= rs.getTimestamp("applied_date") %></td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error fetching loan applications: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </table>
    <% } %>
</body>
</html>
