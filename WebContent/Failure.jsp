<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Failure</title>
</head>
<body>
    <%
        String type = request.getParameter("failure");
        if (type != null && type.equals("SignUp")) {
    %>
        SignUp Failure<p>
        <a href="SignUp.jsp">Please try again</a>
    <%
        } else if (type != null && type.equals("NotLogin")) {
    %>
        No User Login<p> 
        <a href="Login.jsp">Please login </a>   
    <%
        } else if (type != null && type.equals("Access")) {
    %>
    	This page is available to owners only<p>
        <a href="Home.jsp">Return to HomePage</a>
    <%
        } else if (type != null && type.equals("InvalidUser")) {
        	String wrongName = request.getParameter("WrongName");
    %>
    	The provided name <%=wrongName %> is not known<p>
    	<a href="Login.jsp">Please try again</a>
    <%
        } else if (type != null && type.equals("RepeatItem")) {
    %>
    	Item already in cart!<p>
    	<a href="Product_Order.jsp">View item in cart</a>
    <%
        } else if (type != null && type.equals("Other")) {
    %>
    	Uh-oh, something went wrong<p>
    	<a href="Home.jsp">Return to HomePage</a>
    <%
        }
    %>

</body>
</html>