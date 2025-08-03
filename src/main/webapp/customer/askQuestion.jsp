<%@ page import="com.cs336.pkg.ApplicationDB"%>
<%@ page import="java.sql.*"%>

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
%>
    <p>Please <a href="login.jsp">log in</a> to ask a question.</p>
<%
        return;
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String question = request.getParameter("question");
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();

        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO questions (customer, question) VALUES (?, ?)"
        );
        stmt.setString(1, username);
        stmt.setString(2, question);

        stmt.executeUpdate();
        stmt.close();
        conn.close();
%>
    <p>Your question has been submitted!</p>
    <a href="askQuestion.jsp">Submit another</a>
<%
        return;
    }
%>

<h2>Ask a Question</h2>

<form method="post">
    <textarea name="question" rows="4" cols="50"></textarea><br/>
    <input type="submit" value="Submit">
</form>

