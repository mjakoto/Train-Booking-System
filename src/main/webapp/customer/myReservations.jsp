<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");

    if (username == null) {
%>
        <p>Please <a href="login.jsp">log in</a> first.</p>
<%
        return;
    }
    if (email == null) {
%>
    	<p> Please contact support about your account's associated email address.</p>
    	<p><a href="login.jsp">login</a></p>
<%
		return;
    }
    
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("cancelId") != null) {
        String cancelId = request.getParameter("cancelId");

        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        PreparedStatement cancelStmt = conn.prepareStatement(
            "DELETE FROM reservations WHERE reservation_id=? AND email=?"
        );
        cancelStmt.setInt(1, Integer.parseInt(cancelId));
        cancelStmt.setString(2, email);  // Use email if that's how it's stored

        int result = cancelStmt.executeUpdate();

        cancelStmt.close();
        conn.close();

        if (result > 0) {
%>
            <p style="color:green;">Reservation <%= cancelId %> cancelled successfully.</p>
<%
        } else {
%>
            <p style="color:red;">Failed to cancel reservation <%= cancelId %>. Please try again.</p>
<%
        }
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

    PreparedStatement stmt = conn.prepareStatement(
        "SELECT r.reservation_id AS reservation_id, ts.train_id, ts.origin_station_id, ts.destination_station_id, ts.departure_date_time, ts.arrival_date_time, r.total_fare " +
        "FROM reservations r JOIN train_schedules ts ON r.schedule_id = ts.schedule_id " +
        "WHERE r.email=?"
    );
    stmt.setString(1, email);

    ResultSet rs = stmt.executeQuery();
%>

<h2>My Reservations</h2>

<a href="customerDashboard.jsp" style="display: inline-block; margin-bottom: 10px; padding: 8px 16px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px;">Back to Dashboard</a>

<table border="1">
<tr><th>Reservation ID</th><th>Train</th><th>Origin</th><th>Destination</th><th>Departure</th><th>Arrival</th><th>Price</th><th>Action</th></tr>

<%
    boolean hasResults = false;
    while(rs.next()) {
        hasResults = true;
%>
<tr>
    <td><%= rs.getInt("reservation_id") %></td>
    <td><%= rs.getString("train_id") %></td>
    <td><%= rs.getString("origin_station_id") %></td>
    <td><%= rs.getString("destination_station_id") %></td>
    <td><%= rs.getTimestamp("departure_date_time") %></td>
    <td><%= rs.getTimestamp("arrival_date_time") %></td>
    <td>$<%= rs.getBigDecimal("total_fare") %></td>
    <td>
    <form method="post" onsubmit="return confirm('Are you sure you want to cancel this reservation?');">
        <input type="hidden" name="cancelId" value="<%= rs.getInt("reservation_id") %>" />
        <input type="submit" value="Cancel" />
    </form>
    </td>
</tr>
<%
    }
    if (!hasResults) {
%>
<tr><td colspan="8">No reservations found.</td></tr>
<%
    }
    rs.close();
    stmt.close();
    conn.close();
%>
</table>