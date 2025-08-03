<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<html>
<head><title>List Reservations</title></head>
<body>
<h2>List Reservations by Transit Line or Customer Name</h2>

<form method="post">
    <input type="hidden" name="action" value="listReservations" />
    Transit Line: <input type="text" name="transitLineId"><br/>
    OR<br/>
    Customer Email: <input type="text" name="customerName"><br/><br/>
    <input type="submit" value="List Reservations">
</form>

<%
    String action = request.getParameter("action");
    if ("listReservations".equals(action)) {
        String transitLineId = request.getParameter("transitLineId");
        String customerName = request.getParameter("customerName");
        ApplicationDB db = new ApplicationDB();
        List<String[]> reservations = db.getReservationsByCriteria(transitLineId, customerName);
        if (reservations != null) {
            out.println("<table border='1'><tr><th>Reservation ID</th><th>Customer Name</th><th>Reservation Time</th><th>Transit Line</th></tr>");
            for (String[] reservation : reservations) {
                out.println("<tr><td>" + reservation[0] + "</td><td>" + reservation[1] + "</td><td>" + reservation[2] + "</td><td>" + reservation[3] + "</td></tr>");
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
