<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%> 
<%
String username = request.getParameter("username");
String password = request.getParameter("password");
String confirmPassword = request.getParameter("confirm_password");
String email = request.getParameter("email");
String firstName = request.getParameter("first_name");
String lastName = request.getParameter("last_name");

if (username == null || password == null || confirmPassword == null || email == null || firstName == null || lastName == null ||
    username.trim().isEmpty() || password.trim().isEmpty() || confirmPassword.trim().isEmpty() || email.trim().isEmpty() || firstName.trim().isEmpty() || lastName.trim().isEmpty()) {
    out.println("<p>All fields are required.</p>");
    return;
}

if (!password.equals(confirmPassword)) {
    out.println("<p>Passwords do not match. Please <a href='register.jsp'>try again</a>.</p>");
    return;
}

ApplicationDB db = new ApplicationDB();
Connection conn = null;
PreparedStatement checkUserStmt = null;
PreparedStatement checkEmailStmt = null;
PreparedStatement insertUserStmt = null;
PreparedStatement insertCustomerStmt = null;
ResultSet rsUser = null;
ResultSet rsEmail = null;

try {
    conn = db.getConnection();

    // Check if username already exists
    checkUserStmt = conn.prepareStatement("SELECT username FROM users WHERE username = ?");
    checkUserStmt.setString(1, username);
    rsUser = checkUserStmt.executeQuery();
    if (rsUser.next()) {
        out.println("<p>Username already exists. Please <a href='register.jsp'>choose another username</a>.</p>");
        return;
    }

    // Check if email already exists in customers
    checkEmailStmt = conn.prepareStatement("SELECT email FROM customers WHERE email = ?");
    checkEmailStmt.setString(1, email);
    rsEmail = checkEmailStmt.executeQuery();
    if (rsEmail.next()) {
        out.println("<p>Email already registered. Please <a href='register.jsp'>use another email</a>.</p>");
        return;
    }

    // Insert into users table
    insertUserStmt = conn.prepareStatement("INSERT INTO users (username, password, first_name, last_name) VALUES (?, ?, ?, ?)");
    insertUserStmt.setString(1, username);
    insertUserStmt.setString(2, password);
    insertUserStmt.setString(3, firstName);
    insertUserStmt.setString(4, lastName);
    insertUserStmt.executeUpdate();

    // Insert into customers table
    insertCustomerStmt = conn.prepareStatement("INSERT INTO customers (username, email) VALUES (?, ?)");
    insertCustomerStmt.setString(1, username);
    insertCustomerStmt.setString(2, email);
    insertCustomerStmt.executeUpdate();

    out.println("<p>Registration successful! <a href='login.jsp'>Log in here</a>.</p>");

} catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
} finally {
    if (rsUser != null) rsUser.close();
    if (rsEmail != null) rsEmail.close();
    if (checkUserStmt != null) checkUserStmt.close();
    if (checkEmailStmt != null) checkEmailStmt.close();
    if (insertUserStmt != null) insertUserStmt.close();
    if (insertCustomerStmt != null) insertCustomerStmt.close();
    if (conn != null) conn.close();
}
%>