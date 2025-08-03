<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

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
    int scheduleId = -1; // Initialize with an invalid value

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

    // Update the query to use schedule_id instead of id
    PreparedStatement stmt = conn.prepareStatement(
        "DELETE FROM train_schedules WHERE schedule_id=?"
    );
    stmt.setInt(1, scheduleId);

    int result = stmt.executeUpdate();

    stmt.close();
    conn.close();

    if (result > 0) {
%>
    <p>Schedule <%= scheduleId %> deleted successfully.</p>
<%
    } else {
%>
    <p>Failed to delete schedule <%= scheduleId %>. It may not exist.</p>
<%
    }
%>

<a href="repManageSchedules.jsp">Back to Manage Schedules</a>
