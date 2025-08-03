<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Dashboard</title>
</head>
<body>

<h2>Welcome, <%= session.getAttribute("username") %></h2>

<!-- Ask a Question -->
<h3>Ask a Question</h3>
<% String askQuestionMessage = (String) request.getAttribute("askQuestionMessage"); %>
<% if (askQuestionMessage != null) { %>
    <p><%= askQuestionMessage %></p>
<% } %>
<form method="post" action="../CustomerServlet?action=askQuestion">
    <textarea name="question" rows="4" cols="50"></textarea><br/>
    <input type="submit" value="Submit Question">
</form>

<hr>

<!-- Search Train Schedules -->
<h3>Search Train Schedules</h3>
<form method="post" action="searchResults.jsp">
    Origin: <input type="text" name="origin"><br/>
    Destination: <input type="text" name="destination"><br/>
    Date (YYYY-MM-DD): <input type="text" name="date"><br/>
    <input type="submit" value="Search">
</form>

<hr>

<!-- View Reservations -->
<form method="get" action="myReservations.jsp">
    <input type="submit" value="View or Manage Reservations" />
</form>

<hr>

<a href="/cs336_group45/logout.jsp">Logout</a>

</body>
</html>
