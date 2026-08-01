<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");

//String examRoomId=request.getParameter("roomFilter");
String appStartDateStr=request.getParameter("appStartDatePicker");

//siteDoctorBacking.appointmentSearchExamRoomId=examRoomId;
siteDoctorBacking.appointmentSearchDateStr=appStartDateStr;

siteDoctorBacking.appointmentsSearchResults=new ArrayList<appointmentsBean>(0);
                     
if(appStartDateStr!=null)
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    Date submittedDate = sdf.parse(appStartDateStr);
    
    //appStartDateStr should be like 10/20/2015 (MM/dd/yyyy)
    siteDoctorBacking.teleAppointmentsSearchResults=siteDoctorBacking.getAllTeleAppointmentsByDoctorIdAndDate(siteDoctorBacking.AB.docBean.id,submittedDate);
}
else
{
//    Date today=new Date();
//    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
//    String curDate = sdf.format(today);
//    siteDoctorBacking.appointmentsSearchResults=siteDoctorBacking.getAllAppointmentsBySiteAndDate(curDate);
}

if(siteDoctorBacking.teleAppointmentsSearchResults.size()==0)
{
    siteDoctorBacking.infoMessage=langBacking.getLiteral("no_appointments_found");
}
response.sendRedirect(returnToPage);
%>