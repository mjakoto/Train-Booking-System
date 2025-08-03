<%@ page 
    language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    session="true"
    import="com.cs336.pkg.ApplicationDB,java.sql.*,java.util.*" 
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Representative Search</title>
</head>
<body>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"representative".equals(role)) {
%>
    <p>Access denied. Please <a href="login.jsp">Login</a></p>
<%
        return;
    }
%>

<h2>Search Customer Questions &amp; Answers</h2>

<form method="get" action="repSearch.jsp">
    <label>
        Keyword
        <input type="text" name="kw" value="<%= request.getParameter("kw")!=null?request.getParameter("kw"):"" %>" />

    </label>
    <input type = "submit" value="Search" />
</form>

<%
    String kw = request.getParameter("kw"); 
    if (kw != null && !kw.trim().isEmpty())
    {
        ApplicationDB db = new ApplicationDB(); 
        try (Connection conn = db.getConnection()) {
            String sql = "SELECT q.id, q.customer, u.first_name, u.last_name, " +
        "       q.question, q.answer, q.submitted_at, q.answered_at " +
        "FROM questions q " +
        "  JOIN customers c ON q.customer = c.email " +
        "  JOIN users u      ON c.username = u.username " +
        "WHERE q.question LIKE ? OR q.answer LIKE ? " +
        "ORDER BY q.submitted_at DESC";

            try (PreparedStatement ps = conn.prepareStatement(sql)){
                String pattern = "%" + kw + "%"; 
                ps.setString(1, pattern); 
                ps.setString(2, pattern); 
                try(ResultSet rs = ps.executeQuery()){
%>
                    <h3>Results for "<%= kw %>"</h3>
                    <table cellpadding="4" cellspacing="0">
                        <tr>
                            <th>ID</th>
                            <th>Customer Email</th>
                            <th>Name</th>
                            <th>Question</th>
                            <th>Answer</th>
                            <th>Submitted</th>
                            <th>Answered</th>
                        </tr>
                        <%
                            boolean found = false; 
                            while(rs.next()){
                                found = true; 
                            
                        %>

                        <tr>
                            <td><%= rs.getInt("id") %></td>
                            <td><%= rs.getString("customer") %></td>
                            <td><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></td>
                            <td><pre><%= rs.getString("question") %></pre></td>
                            <td><pre><%= rs.getString("answer") != null ? rs.getString("answer") : "<i>—no answer—</i>" %></pre></td>
                            <td><%= rs.getTimestamp("submitted_at") %></td>
                            <td><%= rs.getTimestamp("answered_at") != null ? rs.getTimestamp("answered_at") : "<i>—unanswered—</i>" %></td>
                        </tr>

                        <%
                            }
                            if(!found){
                    %>
                        <tr><td colspan="7">No matching questions found.</td></tr>
                <%
                            }

                    %>

                    </table>
                    <%
                }
            }
        }catch(Exception e){
            %> 
            <p>Error: <%= e.getMessage() %></p>
            <%
             out.println("<p>Error: " + e.getMessage() + "</p>"); 
        }
    }
%>

<br/>
<a href="representativeDashboard.jsp">Back to Dashboard</a>


</body>
</html>
