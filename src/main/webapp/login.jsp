<%-- 
    Document   : login_jsp
    Created on : 11 Aug, 2026, 12:10:40 PM
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.* " %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String em = request.getParameter("sn1");
            String p = request.getParameter("sn2");
        
        try{
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE" , "CARVERSE" , "manager");
            Statement stmt = con.createStatement();
            
            String q1 = "select * from USER_REGISTRATION where EMAIL='"+em+"' and PASSWORD='"+p+"'";
            
            ResultSet res = stmt.executeQuery(q1);
            
            if(res.next()){
                String name = res.getString(2);
                String u_id = res.getString(1);
                session.setAttribute("USER_NAME", name);
                session.setAttribute("USER_ID" , u_id);
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
    </body>
</html>
