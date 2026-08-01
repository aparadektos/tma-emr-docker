<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");

//String examRoomId=request.getParameter("roomFilter");
String appStartDateStr=request.getParameter("appStartDatePicker");

//paramedicBacking.appointmentSearchExamRoomId=examRoomId;
paramedicBacking.appointmentSearchDateStr=appStartDateStr;

paramedicBacking.appointmentsSearchResults=new ArrayList<appointmentsBean>(0);
                     
if(appStartDateStr!=null)
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    Date submittedDate = sdf.parse(appStartDateStr);
    
    //appStartDateStr should be like 10/20/2015 (MM/dd/yyyy)
    paramedicBacking.teleAppointmentsSearchResults=paramedicBacking.getAllTeleAppointmentsByParamedicIdAndDate(paramedicBacking.AB.getParamedicBean().getId(),submittedDate);
}
else
{
//    Date today=new Date();
//    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
//    String curDate = sdf.format(today);
//    paramedicBacking.appointmentsSearchResults=paramedicBacking.getAllAppointmentsBySiteAndDate(curDate);
}

if(paramedicBacking.teleAppointmentsSearchResults.size()==0)
{
    paramedicBacking.infoMessage=langBacking.getLiteral("no_appointments_found");
}
response.sendRedirect(returnToPage);
%>