<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<html>
<head><title>Top 5 Customers</title></head>
<body>
<h2>Top 5 Revenue-Generating Customers</h2>

<form method="post">
    <input type="hidden" name="action" value="topCustomers" />
    <input type="submit" value="Find Top 5 Customers">
</form>

<%
    String action = request.getParameter("action");
    if ("topCustomers".equals(action)) {
        ApplicationDB db = new ApplicationDB();
        List<String[]> topCustomers = db.getTopCustomers();
        if (topCustomers != null) {
            out.println("<table border='1'><tr><th>Rank</th><th>Customer ID</th><th>Total Revenue</th></tr>");
            int rank = 1;
            for (String[] customer : topCustomers) {
                out.println("<tr><td>" + rank++ + "</td><td>" + customer[0] + "</td><td>" + customer[1] + "</td></tr>");
            }
            out.println("</table>");
        } else {
            out.println("<p>No data available.</p>");
        }
    }
%>

<a href="adminDashboard.jsp">Dashboard</a>
</body>
</html>
