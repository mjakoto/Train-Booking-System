<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>

<%
    // Check for role to ensure only representatives can access this page
    String role = (String) session.getAttribute("role");
    if (role == null || !"representative".equals(role)) {
%>
    <p>Access denied. This page is for representatives only.</p>
    <a href="login.jsp">Login</a>
<%
        return;
    }
%>

<h2>Search Schedules by Station</h2>

<!-- Search Form for Station -->
<form method="get" action="repListSchedulesByStation.jsp">
    <label for="station">Enter Station Name or ID:</label>
    <input type="text" id="station" name="station" required>
    <input type="submit" value="Search">
</form>

<%
    // If station is provided, search for the schedules
    String station = request.getParameter("station");

    if (station != null && !station.trim().isEmpty()) {
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        // SQL Query to fetch schedules where the station is either the origin or destination
        String sql = "SELECT * FROM train_schedules WHERE origin_station_id = ? OR destination_station_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, station);
        stmt.setString(2, station);

        ResultSet rs = stmt.executeQuery();
%>

<h3>Schedules for Station: <%= station %></h3>

<table border="1">
<tr>
    <th>Schedule ID</th><th>Train #</th><th>Origin</th><th>Destination</th>
    <th>Departure</th><th>Arrival</th><th>Price</th>
</tr>

<%
        boolean hasResults = false;
        while (rs.next()) {
            hasResults = true;
%>
<tr>
    <td><%= rs.getInt("schedule_id") %></td>
    <td><%= rs.getString("train_id") %></td>
    <td><%= rs.getInt("origin_station_id") %></td> <!-- Origin station ID -->
    <td><%= rs.getInt("destination_station_id") %></td> <!-- Destination station ID -->
    <td><%= rs.getTimestamp("departure_date_time") %></td>
    <td><%= rs.getTimestamp("arrival_date_time") %></td>
    <td>$<%= rs.getBigDecimal("fare") %></td>
</tr>
<%
        }
        if (!hasResults) {
%>
<tr><td colspan="7">No schedules found for this station.</td></tr>
<%
        }

        rs.close();
        stmt.close();
        conn.close();
    }
%>

</table>

<a href="representativeDashboard.jsp">Dashboard</a>
