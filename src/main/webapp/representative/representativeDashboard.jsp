<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"representative".equals(role)) {
%>
    <p>Access denied. Please <a href="login.jsp">Login</a></p>
<%
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Representative Dashboard</title>
</head>
<body>
	<h1>Representative Dashboard</h1>
	
	<ul>
		<li><a href="repManageSchedules.jsp">Manage Schedules</a></li>
		<!-- <li><a href="editSchedule.jsp">Edit Schedules</a></li>
		<li><a href="deleteSchedule.jsp">Delete Schedules</a></li> -->
		<li><a href="repListSchedulesByStation.jsp">List Schedules by Station</a></li>
		<li><a href="repListCustomers.jsp">List Customers</a></li>
		<li><a href="repAnswerQuestions.jsp">Answer Customer Questions</a></li>
		<li><a href="repSearch.jsp">Search</a></li>
	</ul>

	<form action="/cs336_group45/logout.jsp" method="get">
    <input type="submit" value="Logout" />
	</form>
</body>
</html>

<!--  -->
