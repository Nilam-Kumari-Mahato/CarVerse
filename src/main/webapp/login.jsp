<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.* " %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in | CarVerse</title>
  </head>
  <body>
     
   	  
   	  <%
		   	String em = request.getParameter("email");
		     String p = request.getParameter("password");
		  
		  try{
		      Class.forName("oracle.jdbc.driver.OracleDriver");
		      Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE" , "CARVERSE" , "manager");
		      Statement stmt = con.createStatement();
		      
		      String q1 = "select * from USER_REGISTRATION where email='"+em+"' and password='"+p+"'";
		      
		      ResultSet res = stmt.executeQuery(q1);
		      
		      if(res.next()){
		    	  String u_id = res.getString(1);
		    	  String u_name = res.getString(2);
		    	  
		    	  session.setAttribute("USERNAME" , u_name );
		    	  session.setAttribute("USERID" , u_id );
		    	  %>
	                <jsp:include page="index.jsp" />
	              <%
		      }else{
	                out.println("Login failed");
	            }
	            con.close();
	        }catch(Exception e){
	            out.println(e);
		}
	        %>
   	  %>
   </body>
</html>
