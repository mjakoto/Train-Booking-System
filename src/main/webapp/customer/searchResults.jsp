<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*, java.util.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	String viewStopsFor = request.getParameter("viewStopsFor");
	List<String[]> stopsList = null;

	if (viewStopsFor != null) {
    	ApplicationDB db = new ApplicationDB();
    	Connection conn = db.getConnection();
    	PreparedStatement stopStmt = conn.prepareStatement(
        	"SELECT s.stop_order, st.name, s.arrival_time, s.departure_time " +
        	"FROM stops s JOIN stations st ON s.station_id = st.station_id " +
        	"WHERE s.schedule_id = ? ORDER BY s.stop_order"
    	);
    	stopStmt.setInt(1, Integer.parseInt(viewStopsFor));
    	ResultSet stopsRs = stopStmt.executeQuery();

    	stopsList = new ArrayList<>();
    	while (stopsRs.next()) {
        	stopsList.add(new String[]{
            	stopsRs.getString("stop_order"),
            	stopsRs.getString("name"),
            	stopsRs.getString("arrival_time"),
            	stopsRs.getString("departure_time")
        	});
    	}
    	stopsRs.close();
    	stopStmt.close();
    	conn.close();
	
	}
	String email = (String) session.getAttribute("email");
	String reserveScheduleId = request.getParameter("reserveScheduleId");
	String discountCategory = request.getParameter("category");

	if ("POST".equalsIgnoreCase(request.getMethod()) && reserveScheduleId != null && email != null) {
	    ApplicationDB dbReserve = new ApplicationDB();
	    Connection connReserve = dbReserve.getConnection();

	    // First, get schedule + transit line info
	    PreparedStatement infoStmt = connReserve.prepareStatement(
	        "SELECT ts.origin_station_id, ts.destination_station_id, ts.departure_date_time, ts.fare, tl.route_type " +
	        "FROM train_schedules ts JOIN transit_lines tl ON ts.transit_line_name = tl.name " +
	        "WHERE ts.schedule_id = ?"
	    );
	    infoStmt.setInt(1, Integer.parseInt(reserveScheduleId));
	    ResultSet infoRs = infoStmt.executeQuery();

	    String reservationType = "one way"; // default
	    java.sql.Timestamp departureDateTime = null;
	    java.math.BigDecimal totalFare = null;

	    if (infoRs.next()) {
	        String originId = infoRs.getString("origin_station_id");
	        String destinationId = infoRs.getString("destination_station_id");
	        departureDateTime = infoRs.getTimestamp("departure_date_time");
	        totalFare = infoRs.getBigDecimal("fare");
	        String routeType = infoRs.getString("route_type");

	        if ("round trip".equalsIgnoreCase(routeType)) {
	            if (originId.equals(destinationId)) {
	                reservationType = "round trip";
	            } else {
	                reservationType = "one way";
	            }
	        } else {
	            reservationType = "one way";
	        }
	        
	        if (discountCategory != null) {
	            switch (discountCategory) {
	                case "child":
	                    totalFare = totalFare.multiply(new java.math.BigDecimal("0.75")); // 50% off
	                    break;
	                case "senior":
	                    totalFare = totalFare.multiply(new java.math.BigDecimal("0.65")); // 30% off
	                    break;
	                case "disabled":
	                    totalFare = totalFare.multiply(new java.math.BigDecimal("0.55")); // 40% off
	                    break;
	                default:
	                    // no discount
	                    break;
	            }
	        }
	    }
	    infoRs.close();
	    infoStmt.close();

	    // Now insert into reservations (set reservation_date as current date)
	    PreparedStatement reserveStmt = connReserve.prepareStatement(
	        "INSERT INTO reservations (email, schedule_id, reservation_date, departure_date_time, total_fare, reservation_type) " +
	        "VALUES (?, ?, CURDATE(), ?, ?, ?)"
	    );
	    reserveStmt.setString(1, email);
	    reserveStmt.setInt(2, Integer.parseInt(reserveScheduleId));
	    reserveStmt.setTimestamp(3, departureDateTime);
	    reserveStmt.setBigDecimal(4, totalFare);
	    reserveStmt.setString(5, reservationType);

	    int reserveResult = reserveStmt.executeUpdate();

	    reserveStmt.close();
	    connReserve.close();

	    if (reserveResult > 0) {
%>
	        <p style="color:green;">Reservation successful for train schedule ID <%= reserveScheduleId %>!</p>
<%
	    } else {
%>
	        <p style="color:red;">Reservation failed. Please try again.</p>
<%
	    }
	}


    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String date = request.getParameter("date");

    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

    StringBuilder sql = new StringBuilder("SELECT * FROM train_schedules WHERE 1=1");
    if (origin != null && !origin.trim().isEmpty()) {
        sql.append(" AND origin_station_id=?");
    }
    if (destination != null && !destination.trim().isEmpty()) {
        sql.append(" AND destination_station_id=?");
    }
    if (date != null && !date.trim().isEmpty()) {
        sql.append(" AND DATE(departure_date_time)=?");
    }

    PreparedStatement stmt = conn.prepareStatement(sql.toString());

    int paramIndex = 1;
    if (origin != null && !origin.trim().isEmpty()) {
        stmt.setString(paramIndex++, origin);
    }
    if (destination != null && !destination.trim().isEmpty()) {
        stmt.setString(paramIndex++, destination);
    }
    if (date != null && !date.trim().isEmpty()) {
        stmt.setString(paramIndex++, date);
    }

    ResultSet rs = stmt.executeQuery();
%>

<h2>Search Results</h2>

<a href="customerDashboard.jsp" style="display: inline-block; margin-bottom: 10px; padding: 8px 16px; background-color: #007bff; color: white; text-decoration: none; border-radius: 4px;">Back to Dashboard</a>

<table border="1">
  <tr>
    <th>Train</th><th>Origin</th><th>Destination</th>
    <th>Departure</th><th>Arrival</th><th>Price</th>
    <th>Stops</th><th>Reserve</th>
  </tr>

<%
    boolean hasResults = false;
    while (rs.next()) {
        hasResults = true;
        int sid = rs.getInt("schedule_id");
        boolean expanded = viewStopsFor != null && viewStopsFor.equals(String.valueOf(sid));
%>
  <tr>
    <td><%= rs.getString("train_id") %></td>
    <td><%= rs.getString("origin_station_id") %></td>
    <td><%= rs.getString("destination_station_id") %></td>
    <td><%= rs.getTimestamp("departure_date_time") %></td>
    <td><%= rs.getTimestamp("arrival_date_time") %></td>
    <td>$<%= rs.getBigDecimal("fare") %></td>
    <td>
      <form method="get" style="margin:0;">
        <input type="hidden" name="viewStopsFor" value="<%= sid %>" />
        <input type="submit" value="<%= expanded ? "Hide Stops" : "View Stops" %>" />
      </form>
    </td>
    <td>
      <form method="post" style="margin:0;">
        <input type="hidden" name="reserveScheduleId" value="<%= sid %>" />
        <label for="category-<%= sid %>">Discount:</label>
  		<select name="category" id="category-<%= sid %>">
    		<option value="none">None</option>
    		<option value="disabled">Disability</option>
    		<option value="senior">Senior</option>
    		<option value="child">Child</option>
  		</select>
        <input type="submit" value="Reserve" />
      </form>
    </td>
  </tr>

<%
        if (expanded && stopsList != null) {
%>
  <tr>
    <td colspan="8">
      <strong>Stops:</strong>
      <ul>
        <% for (String[] stop : stopsList) { %>
          <li><%= stop[0] %>. <%= stop[1] %> - Arrive: <%= stop[2] %>, Depart: <%= stop[3] %></li>
        <% } %>
      </ul>
    </td>
  </tr>
<%
        }
    }
    if (!hasResults) {
%>
<tr><td colspan="8">No results found.</td></tr>
<%
    }
%>
</table>

<%
    rs.close();
    stmt.close();
    conn.close();
%>
