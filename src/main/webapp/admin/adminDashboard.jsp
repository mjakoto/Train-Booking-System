<%@ page import="java.sql.*,java.util.*" %>
<html>
<head><title>Admin Dashboard</title></head>
<body>
<h2>Admin Dashboard</h2>

<!-- Links to various admin functions -->
<h3>Manage Customer Representatives</h3>
<ul>
    <li><a href="adminManageRep.jsp">Add/Edit/Delete Representative</a></li>
</ul>

<h3>Generate Reports</h3>
<ul>
    <li><a href="adminMonthlyReport.jsp">Monthly Sales Report</a></li>
    <li><a href="adminRevenueLookup.jsp">Revenue Lookup by Transit Line or Customer</a></li>
    <li><a href="adminTopCustomers.jsp">Top 5 Revenue-Generating Customers</a></li>
    <li><a href="adminTopTransitLines.jsp">Top 5 Most Active Transit Lines</a></li>
</ul>

<h3>List Reservations</h3>
<ul>
    <li><a href="adminListReservations.jsp">List Reservations by Transit Line or Customer Name</a></li>
</ul>

<!-- Logout Button -->
<form action="../logout.jsp" method="get">
    <input type="submit" value="Logout" />
</form>

</body>
</html>

