<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"representative".equals(role)) {
%>
    <p>Access denied. <a href="login.jsp">Login</a></p>
<%
        return;
    }

    String trainNumber = request.getParameter("trainNumber");
    String date = request.getParameter("date");
%>

<h2>List Customers for Train and/or Date</h2>

<form method="get">
    Train Number: <input type="text" name="trainNumber" value="<%= trainNumber != null ? trainNumber : "" %>"><br/>
    Date (YYYY-MM-DD): <input type="text" name="date" value="<%= date != null ? date : "" %>"><br/>
    <input type="submit" value="Search">
</form>

<%
    if ((trainNumber != null && !trainNumber.trim().isEmpty()) ||
        (date != null && !date.trim().isEmpty())) {

        ApplicationDB db = new ApplicationDB();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = db.getConnection();

            StringBuilder sql = new StringBuilder(
                    "SELECT DISTINCT r.email FROM reservations r " +
                    "JOIN train_schedules ts ON r.schedule_id = ts.schedule_id " +
                    "JOIN customers c ON r.email = c.email " +
                    "JOIN users u ON c.username = u.username " +
                    "WHERE u.role = 'customer'"
            );

            if (trainNumber != null && !trainNumber.trim().isEmpty()) {
                sql.append(" AND ts.train_id = ?");
            }
            if (date != null && !date.trim().isEmpty()) {
                sql.append(" AND DATE(ts.departure_date_time) = ?");
            }

            stmt = conn.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (trainNumber != null && !trainNumber.trim().isEmpty()) {
                stmt.setString(paramIndex++, trainNumber);
            }
            if (date != null && !date.trim().isEmpty()) {
                stmt.setString(paramIndex++, date);
            }

            rs = stmt.executeQuery();
%>

<h3>Results:</h3>

<ul>
<%
            boolean found = false;
            while (rs.next()) {
                found = true;
%>
    <li><%= rs.getString("email") %></li> <!-- Displaying email instead of username -->
<%
            }
            if (!found) {
%>
    <li>No customers found.</li>
<%
            }
        } catch (SQLException e) {
            e.printStackTrace();
<%
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
</ul>

<a href="representativeDashboard.jsp">Dashboard</a>
