<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.mindrot.jbcrypt.BCrypt" %>
<%
    // Get user input
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Database credentials
    String dbURL = "jdbc:mysql://localhost:3306/banking_db";
    String dbUser = "balasaravanan";
    String dbPassword = "balasaravanan18@";

    boolean isAuthenticated = false;
    String username = null;
    int userId = -1; // Default invalid value

    try {
        // Load MySQL Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Query user from database
        String sql = "SELECT user_id, username, password FROM users WHERE email = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            userId = rs.getInt("user_id");
            username = rs.getString("username");
            String hashedPassword = rs.getString("password");

            // Check if the entered password matches the stored hash
            if (BCrypt.checkpw(password, hashedPassword)) {
                isAuthenticated = true;
            }
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (isAuthenticated) {
        // ✅ Store user_id and username in session
        session.setAttribute("user_id", userId);
        session.setAttribute("username", username);
        
        // Redirect to homepage
        response.sendRedirect("homepage.jsp");
    } else {
        // Show error message and redirect back to login page
        out.println("<script>alert('Invalid email or password!'); window.location='index.jsp';</script>");
    }
%>
