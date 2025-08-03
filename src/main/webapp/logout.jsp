<%@ page session="true" %>
<%
    session.invalidate();
%>
<p>You have been logged out.</p>
<a href="login.jsp">Login Again</a>