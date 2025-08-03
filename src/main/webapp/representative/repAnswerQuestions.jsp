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

    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String qid = request.getParameter("id");
        String answer = request.getParameter("answer");

        PreparedStatement update = conn.prepareStatement(
            "UPDATE questions SET answer=?, answered_at=NOW() WHERE id=?"
        );
        update.setString(1, answer);
        update.setInt(2, Integer.parseInt(qid));
        update.executeUpdate();
        update.close();
    }

    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM questions");
%>

<h2>Customer Questions</h2>

<table border="1">
<tr><th>ID</th><th>Customer</th><th>Question</th><th>Answer</th><th>Action</th></tr>

<%
    while (rs.next()) {
%>
<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("customer") %></td>
    <td><%= rs.getString("question") %></td>
    <td><%= rs.getString("answer") != null ? rs.getString("answer") : "" %></td>
    <td>
        <% if (rs.getString("answer") == null) { %>
            <form method="post">
                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                <textarea name="answer"></textarea><br/>
                <input type="submit" value="Submit Answer">
            </form>
        <% } %>
    </td>
</tr>
<%
    }
    rs.close();
    stmt.close();
    conn.close();
%>
</table>

<a href="representativeDashboard.jsp">Dashboard</a>
