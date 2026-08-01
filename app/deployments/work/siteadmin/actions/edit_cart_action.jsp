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
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
%>

<%
//int id=Integer.parseInt(request.getParameter("cartid"));
String id=request.getParameter("cartid");
String name=request.getParameter("cartName");
String manufacturer=request.getParameter("cartManufacturer");
//int siteid=Integer.parseInt(request.getParameter("cartSite"));
String siteid=AB.SB.id;
String statusid;
String portable;

if (request.getParameter("cartPortable").equalsIgnoreCase("cartPortableYES")){
     portable = "1";
}else {
     portable = "0";
}

if (request.getParameter("cartStatus").equalsIgnoreCase("cartStatusYES")){
     statusid = "1";
}else {
     statusid = "0";
}

String comments = request.getParameter("cartComments");
String videoconfIP=request.getParameter("cartvideoconfip");
String agnesIP=request.getParameter("cartagnesip");

System.out.print("id: "+request.getParameter("cartid"));
System.out.print("name: "+name);
System.out.print("manufacturer: "+manufacturer);
System.out.print("siteid: "+siteid);
System.out.print("statusid: "+statusid);
System.out.print("portable: "+portable);
System.out.print("comments: "+comments);

cartBean CB=new cartBean(id,name,manufacturer,Integer.parseInt(siteid),Integer.parseInt(portable),Integer.parseInt(statusid),comments,videoconfIP,agnesIP);

boolean updated=DBH.updateCart(CB);

if (updated==true){
   response.sendRedirect("../modalities.jsp?result=CartEdited");   
}else{
   response.sendRedirect("../modalities.jsp?result=CartEditError");        
} 
%>