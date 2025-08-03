<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
    String username = (String) session.getAttribute("username");
    String reservationId = request.getParameter("reservationId");

    if (username == null || reservationId == null) {
%>
        <p>Error: Missing session or reservation ID. Please log in and try again.</p>
        <a href="login.jsp">Login</a>
<%
        return;
    }

    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

    PreparedStatement stmt = conn.prepareStatement(
        "DELETE FROM reservations WHERE id=? AND username=?"
    );
    stmt.setInt(1, Integer.parseInt(reservationId));
    stmt.setString(2, username);

    int result = stmt.executeUpdate();

    stmt.close();
    conn.close();

    if (result > 0) {
%>
        <p>Reservation <%= reservationId %> cancelled successfully.</p>
<%
    } else {
%>
        <p>Failed to cancel reservation. Please try again.</p>
<%
    }
%>
