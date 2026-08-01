<%@page import="beans.ModalityBean"%>
<%@page import="beans.modalityAvBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.cartAvBean"%>

<!-- Initializations -->

<%
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");


request.setCharacterEncoding("UTF-8");

String modalityid = request.getParameter("cartid").trim();
String startTime=request.getParameter("startTimePicker").trim();
String startDate=request.getParameter("startDatePicker").trim();
String endTime=request.getParameter("endTimePicker").trim();
String endDate=request.getParameter("endDatePicker").trim();

if(modalityid!=null && modalityid.length()>0 && startDate!=null && startDate.length()>0 &&
     endDate!=null && endDate.length()>0 && startTime!=null && startTime.length()>0 &&
     endTime!=null && endTime.length()>0)
{
   
   String startDateArray[]=startDate.split("/");
   String endDateArray[]=endDate.split("/");
   String startTimeArray[]=startTime.split(":");
   String endTimeArray[]=endTime.split(":");
   // String newStartDate=startDateArray[2]+"-"+startDateArray[0]+"-"+startDateArray[1]+" "+startTime+":00";
   //String newEndDate=endDateArray[2]+"-"+endDateArray[0]+"-"+endDateArray[1]+" "+endTime+":00";
   
   //System.out.println("startDateArray[0]: "+startDateArray[0]);
   //System.out.println("startDateArray[1]: "+startDateArray[1]);
   //System.out.println("startDateArray[2]: "+startDateArray[2]);
   Timestamp startTimestamp=new Timestamp(Integer.parseInt(startDateArray[2])-1900, Integer.parseInt(startDateArray[0])-1, Integer.parseInt(startDateArray[1]), Integer.parseInt(startTimeArray[0]), Integer.parseInt(startTimeArray[1]), 0, 0);
   Timestamp endTimestamp=new Timestamp(Integer.parseInt(endDateArray[2])-1900, Integer.parseInt(endDateArray[0])-1, Integer.parseInt(endDateArray[1]), Integer.parseInt(endTimeArray[0]), Integer.parseInt(endTimeArray[1]), 0, 0);
   ModalityBean mBean= DBH.getModalityByID(modalityid);
   
   ArrayList<avPeriod> avPeriodList = new ArrayList<avPeriod>();
   avPeriodList.add(new avPeriod("", startTimestamp, endTimestamp));
   modalityAvBean MAB=new modalityAvBean(mBean, avPeriodList);
        
  
   if(DBH.addModalityAvailability(MAB))
   {
       response.sendRedirect("../carts.jsp?result=AvailabilityAdded");
   }
   else
   {
       response.sendRedirect("../carts.jsp?result=AvailabilityError");
   }
}
else
{
       response.sendRedirect("../carts.jsp?result=error");
}
%>
