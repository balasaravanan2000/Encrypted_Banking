<%@ page import="java.sql.*" %>
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/banking_db";
    String dbUser = "balasaravanan";
    String dbPassword = "balasaravanan18@";
    
    Connection conn = null;
    try {
        // Load MySQL driver (Optional for MySQL 9.x)
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // Establish connection
        conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
        out.println("✅ Database Connected Successfully!");
    } catch (Exception e) {
        out.println("❌ Database Connection Failed: " + e.getMessage());
    } finally {
        // Close connection properly
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                out.println("⚠️ Error closing connection: " + ex.getMessage());
            }
        }
    }
%>
