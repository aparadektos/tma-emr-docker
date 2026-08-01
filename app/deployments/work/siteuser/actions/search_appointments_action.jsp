<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

String examRoomId=request.getParameter("roomFilter");
String appStartDateStr=request.getParameter("appStartDatePicker");

siteUserBacking.appointmentSearchExamRoomId=examRoomId;
siteUserBacking.appointmentSearchDateStr=appStartDateStr;

siteUserBacking.appointmentsSearchResults=new ArrayList<appointmentsBean>(0);
                     
if(examRoomId!=null && appStartDateStr!=null)
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    Date submittedDate = sdf.parse(appStartDateStr);
        
    siteUserBacking.appointmentsSearchResults=siteUserBacking.getAllAppointmentsBySearch(examRoomId, submittedDate);
}
else
{
    Date today=new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
    String curDate = sdf.format(today);
    siteUserBacking.appointmentsSearchResults=siteUserBacking.getAllAppointmentsBySiteAndDate(curDate);
}

if(siteUserBacking.appointmentsSearchResults.size()==0)
{
    siteUserBacking.infoMessage=langBacking.getLiteral("no_appointments_found");
}
response.sendRedirect("../appointments.jsp");
%>