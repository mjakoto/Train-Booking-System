<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.math.BigDecimal"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"representative".equals(role)) {
%>
    <p>Access denied. This page is for representatives only.</p>
    <a href="login.jsp">Login</a>
<%
        return;
    }
%>

<h2>Add New Train Schedule</h2>

<form method="post" action="addSchedule.jsp">
    <label for="train_id">Train ID:</label>
    <input type="text" id="train_id" name="train_id" required><br><br>

    <label for="transit_line_name">Transit Line Name:</label>
    <input type="text" id="transit_line_name" name="transit_line_name" required><br><br>

    <label for="origin_station_id">Origin Station ID:</label>
    <input type="number" id="origin_station_id" name="origin_station_id" required><br><br>

    <label for="destination_station_id">Destination Station ID:</label>
    <input type="number" id="destination_station_id" name="destination_station_id" required><br><br>

    <label for="departure_date_time">Departure Date and Time:</label>
    <input type="datetime-local" id="departure_date_time" name="departure_date_time" required><br><br>

    <label for="arrival_date_time">Arrival Date and Time:</label>
    <input type="datetime-local" id="arrival_date_time" name="arrival_date_time" required><br><br>

    <label for="travel_time">Travel Time (in minutes):</label>
    <input type="number" id="travel_time" name="travel_time" required><br><br>

    <label for="fare">Fare:</label>
    <input type="number" step="0.01" id="fare" name="fare" required><br><br>

    <input type="submit" value="Add Schedule">
</form>

<%
    // Check if form is submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String trainId = request.getParameter("train_id");
        String transitLineName = request.getParameter("transit_line_name");
        int originStationId = Integer.parseInt(request.getParameter("origin_station_id"));
        int destinationStationId = Integer.parseInt(request.getParameter("destination_station_id"));
        String departureDateTime = request.getParameter("departure_date_time");
        String arrivalDateTime = request.getParameter("arrival_date_time");
        int travelTime = Integer.parseInt(request.getParameter("travel_time"));
        BigDecimal fare = new BigDecimal(request.getParameter("fare"));

        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        String query = "INSERT INTO train_schedules (train_id, transit_line_name, origin_station_id, destination_station_id, departure_date_time, arrival_date_time, travel_time, fare) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, trainId);
            stmt.setString(2, transitLineName);
            stmt.setInt(3, originStationId);
            stmt.setInt(4, destinationStationId);
            stmt.setString(5, departureDateTime);
            stmt.setString(6, arrivalDateTime);
            stmt.setInt(7, travelTime);
            stmt.setBigDecimal(8, fare);

            int result = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (result > 0) {
                out.println("<p>Schedule added successfully.</p>");
            } else {
                out.println("<p>Failed to add schedule.</p>");
            }
        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    }
%>

<a href="repManageSchedules.jsp">Back to Manage Schedules</a>
