<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>CarVerse</h1>
	<%
		Object userId = session.getAttribute("USER_ID");
		if(userId != null){
			
		
	%>
		<p>Welcome back, <%= session.getAttribute("USER_NAME") %>!</p>
        <a href="Maintenance.html">Go to Maintenance</a>
        <br>
    <%
		}else{
			
	%>
	        <a href="user_registration.html">Register</a>
	        <br>
	        <a href="login.jsp">Login</a>
	<%
	        }
	%>
</body>
</html>