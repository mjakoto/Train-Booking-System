<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<html>
<head><title>Revenue Lookup</title></head>
<body>
<h2>Revenue by Transit Line or Customer</h2>

<form method="post">
    <input type="hidden" name="action" value="revenueLookup" />
    Transit Line: <input type="text" name="transitLineId"><br/>
    OR<br/>
    Customer email: <input type="text" name="customerId"><br/><br/>
    <input type="submit" value="Get Revenue">
</form>

<%
    String action = request.getParameter("action");
    if ("revenueLookup".equals(action)) {
        String transitLineId = request.getParameter("transitLineId");
        String customerId = request.getParameter("customerId");
        ApplicationDB db = new ApplicationDB();
        String revenue = db.getRevenue(transitLineId, customerId);
        out.println("<p><strong>Total Revenue:</strong> $" + revenue + "</p>");
    }
%>
<a href="adminDashboard.jsp">Dashboard</a>


</body>
</html>
