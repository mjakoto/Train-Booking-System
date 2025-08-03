<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<html>
<head><title>Monthly Sales Report</title></head>
<body>
<h2>Monthly Sales Report</h2>

<form method="post">
    <input type="hidden" name="action" value="monthlyReport" />
    <input type="submit" value="Generate Report">
</form>

<%
    String action = request.getParameter("action");
    if ("monthlyReport".equals(action)) {
        ApplicationDB db = new ApplicationDB();
        List<String[]> report = db.getMonthlySalesReport();
        if (report != null) {
            out.println("<table border='1'><tr><th>Year</th><th>Month</th><th>Total Revenue</th></tr>");
            for (String[] row : report) {
                out.println("<tr><td>" + row[0] + "</td><td>" + row[1] + "</td><td>" + row[2] + "</td></tr>");
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
