<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"representative".equals(role)) {
%>
    <p>Access denied. This page is for representatives only.</p>
    <a href="login.jsp">Login</a>
<%
        return;
    }

    String idParam = request.getParameter("id");
    int scheduleId = -1;

    if (idParam == null) {
%>
    <p>No schedule ID provided.</p>
    <a href="repManageSchedules.jsp">Back</a>
<%
        return;
    }

    try {
        scheduleId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        out.println("<p>Invalid schedule ID.</p>");
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

    // Use the correct column name 'schedule_id' here
    PreparedStatement stmt = conn.prepareStatement(
        "SELECT * FROM train_schedules WHERE schedule_id=?"
    );
    stmt.setInt(1, scheduleId);

    ResultSet rs = stmt.executeQuery();
    if (!rs.next()) {
%>
    <p>Schedule not found.</p>
    <a href="repManageSchedules.jsp">Back</a>
<%
        rs.close();
        stmt.close();
        conn.close();
        return;
    }
%>

<h2>Edit Schedule ID <%= scheduleId %></h2>
<form method="post" action="editSchedule.jsp?id=<%= scheduleId %>">
    <!-- Form Fields to Update the Schedule -->
    Train Number: <input type="text" name="train_number" value="<%= rs.getString("train_id") %>"><br/>
    Origin: <input type="text" name="origin_station" value="<%= rs.getString("origin_station_id") %>"><br/>
    Destination: <input type="text" name="destination_station" value="<%= rs.getString("destination_station_id") %>"><br/>
    Departure: <input type="text" name="departure_time" value="<%= rs.getTimestamp("departure_date_time") %>"><br/>
    Arrival: <input type="text" name="arrival_time" value="<%= rs.getTimestamp("arrival_date_time") %>"><br/>
    Price: <input type="text" name="price" value="<%= rs.getBigDecimal("fare") %>"><br/>
    <input type="submit" value="Update">
</form>

<a href="repManageSchedules.jsp">Back to Manage Schedules</a>

<%
    rs.close();
    stmt.close();
    conn.close();
%>
