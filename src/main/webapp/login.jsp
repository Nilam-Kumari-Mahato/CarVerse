<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.sql.* " %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign in | CarVerse</title>
    <link rel="stylesheet" href="assets/css/carverse.css">
    <style>.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}</style>
  </head>
  <body>
    <main class="auth-page">
      <section class="auth-card" aria-labelledby="sign-in-title">
        <header class="auth-copy">
          <a class="brand" href="index.jsp" aria-label="CarVerse home">CARVERSE</a>
          <p class="eyebrow" style="margin-top:80px">Welcome back</p>
          <h1>Your next chapter <span>starts in the driver's seat.</span></h1>
          <p>Compare favourites, track your booking, schedule maintenance, and keep your car journey in one calm place.</p>
        </header>
        <form class="auth-form" action="index.jsp" method="get">
          <h2 id="sign-in-title">Sign in</h2>
          <p class="sub">Enter your account details to continue.</p>
          <div><label class="sr-only" for="email">Email address</label><input class="input" id="email" name="email" type="email" autocomplete="email" placeholder="Email address" required></div>
          <div><label class="sr-only" for="password">Password</label><input class="input" id="password" name="password" type="password" autocomplete="current-password" placeholder="Password" required></div>
          <p class="form-note" style="text-align:right"><a href="#">Forgot password?</a></p>
          <button class="btn btn-primary" type="submit">Sign in <span aria-hidden="true">→</span></button>
          <p class="form-note">New to CarVerse? <a href="user_registration.html">Create an account</a></p>
   		</form>
   	  </section>
   	  
   	  <%
		   	String em = request.getParameter("email");
		     String p = request.getParameter("password");
		  
		  try{
		      Class.forName("oracle.jdbc.driver.OracleDriver");
		      Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE" , "CARVERSE" , "oracle26");
		      Statement stmt = con.createStatement();
		      
		      String q1 = "select * from USER_REGISTRATION where email='"+em+"' and password='"+p+"'";
		      
		      ResultSet res = stmt.executeQuery(q1);
		      
		      if(res.next()){
		    	  String u_id = res.getString(1);
		    	  String u_name = res.getString(2);
		    	  
		    	  session.setAttribute(u_name , "USERNAME");
		    	  session.setAttribute(u_id , "USERID");
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
   	</main>
   </body>
</html>
