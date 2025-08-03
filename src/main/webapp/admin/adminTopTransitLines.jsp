<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<html>
<head><title>Top 5 Most Active Transit Lines</title></head>
<body>
<h2>Top 5 Most Active Transit Lines</h2>

<%
    // Initialize ApplicationDB and prepare for data retrieval
    ApplicationDB db = new ApplicationDB();
    List<String[]> topTransitLines = db.getTopTransitLines();

    if (topTransitLines != null && !topTransitLines.isEmpty()) {
%>
        <table border="1">
            <thead>
                <tr>
                    <th>Rank</th>
                    <th>Transit Line ID</th>
                    <th>Reservations Count</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    int rank = 1; 
                    for (String[] line : topTransitLines) {
                        String transitLineId = line[0];
                        String reservationCount = line[1];
                %>
                        <tr>
                            <td><%= rank++ %></td>
                            <td><%= transitLineId %></td>
                            <td><%= reservationCount %></td>
                        </tr>
                <% 
                    } 
                %>
            </tbody>
        </table>
<%
    } else {
        out.println("<p>No data available for the top 5 transit lines.</p>");
    }
%>

<a href="adminDashboard.jsp">Dashboard</a>
</body>
</html>
