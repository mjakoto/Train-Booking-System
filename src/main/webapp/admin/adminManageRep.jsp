<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<html>
<head><title>Manage Customer Representatives</title></head>
<body>
<h2>Manage Customer Representatives</h2>

<!-- Add/Edit Rep -->
<form method="post">
    <input type="hidden" name="action" value="saveRep" />
    First Name: <input type="text" name="first_name"><br/>
    Last Name: <input type="text" name="last_name"><br/>
    Username: <input type="text" name="username"><br/>
    Password: <input type="password" name="password"><br/>
    SSN: <input type="text" name="ssn"><br/>
    <input type="submit" value="Add/Update Rep">
</form>

<!-- Delete Rep -->
<form method="post">
    <input type="hidden" name="action" value="deleteRep" />
    ID: <input type="text" name="id">
    <input type="submit" value="Delete Rep">
</form>

<%
    String action = request.getParameter("action");
    ApplicationDB db = new ApplicationDB();
    if ("saveRep".equals(action)) {
    	String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String ssn = request.getParameter("ssn");
        boolean success = db.saveRep(username, password, firstName, lastName, ssn);
        if (success) {
            out.println("<p>Representative added/updated successfully!</p>");
        } else {
            out.println("<p style='color:red;'>Failed to add/update representative. Possibly a duplicate username or SSN.</p>");
        }
    }
    if ("deleteRep".equals(action)) {
        String username = request.getParameter("username");
        db.deleteRep(username);
        out.println("<p>Representative deleted successfully!</p>");
    }
%>
<a href="adminDashboard.jsp">Dashboard</a>
</body>
</html>
