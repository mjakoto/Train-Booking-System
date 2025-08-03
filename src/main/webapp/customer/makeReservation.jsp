<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Make a Reservation</title>
</head>
<body>
<%
  
  String username = (String) session.getAttribute("username");
  if (username == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  
  String scheduleId = request.getParameter("scheduleId");
  if (scheduleId == null) {
%>
    <p style="color:red;">No train schedule selected. <a href="searchSchedules.jsp">Go back</a>.</p>
<%
    return;
  }
%>

<h2>Reserve Train #<%= scheduleId %></h2>

<form method="post" action="CustomerServlet">
  <input type="hidden" name="action" value="reserve"/>
  <input type="hidden" name="scheduleId" value="<%= scheduleId %>"/>

  <label>Your category:
    <select name="category">
      <option value="none">None (full fare)</option>
      <option value="child">Child (50% off)</option>
      <option value="disabled">Disabled (25% off)</option>
      <option value="elderly">Elderly (30% off)</option>
    </select>
  </label>
  <br/><br/>

  <button type="submit">Confirm Reservation</button>
</form>
</body>
</html>
