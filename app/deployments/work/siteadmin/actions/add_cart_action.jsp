<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
//retrieve DBH and AB from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
%>

<%
String name=request.getParameter("cartName");
String manufacturer=request.getParameter("cartManufacturer");
String videoconfIP=request.getParameter("cartVideoconfIP");
String agnesIP=request.getParameter("cartagnesIP");
int siteid=Integer.parseInt(AB.SB.id);
int statusid;
int portable;

if (request.getParameter("cartPortable").equalsIgnoreCase("cartPortableYES")){
     portable = 1;
}else {
     portable = 0;
}

if (request.getParameter("cartStatus").equalsIgnoreCase("cartStatusYES")){
     statusid = 1;
}else {
     statusid = 0;
}

String comments=request.getParameter("cartComments");
cartBean CB=new cartBean("1",name, manufacturer, siteid, portable, statusid,comments,videoconfIP,agnesIP);

boolean stored=DBH.insertNewCart(CB);
        
if (stored==true){
   response.sendRedirect("../carts.jsp?result=newCartAdded");   
}else{
   response.sendRedirect("../carts.jsp?result=CartSaveError");   
} 
%>