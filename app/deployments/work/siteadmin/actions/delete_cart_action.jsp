<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="tools.DBHelper"%>

<% 
   DBHelper DBH= new DBHelper();
   String deleted=DBH.deleteCart(Integer.parseInt(request.getParameter("id")));
   if (deleted.equals("CartDeleted")){
     response.sendRedirect("../carts.jsp?result='CartDeleted'");        
   }
   else{
     response.sendRedirect("../carts.jsp?result='CartDeleteError'");          
   }
%>
   
