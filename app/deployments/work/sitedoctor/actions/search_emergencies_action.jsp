<%@page import="beans.EmergencyCaseBean"%>
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

String examRoomId=request.getParameter("roomFilter");
String erStartDateStr=request.getParameter("erStartDatePicker");

siteDoctorBacking.emergenciesSearchExamRoomId=examRoomId;
siteDoctorBacking.emergenciesSearchDateStr=erStartDateStr;

siteDoctorBacking.emergenciesSearchResults=new ArrayList<EmergencyCaseBean>(0);
                     
if(examRoomId!=null && erStartDateStr!=null)
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    Date submittedDate = sdf.parse(erStartDateStr);
    siteDoctorBacking.emergenciesSearchResults=siteDoctorBacking.getAllEmergenciesBySearch(examRoomId, submittedDate);
}
else
{
//    Date today=new Date();
//    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
//    String curDate = sdf.format(today);
//    siteDoctorBacking.appointmentsSearchResults=siteDoctorBacking.getAllAppointmentsBySiteAndDate(curDate);
}

if(siteDoctorBacking.emergenciesSearchResults.size()==0)
{
    siteDoctorBacking.infoMessage=langBacking.getLiteral("no_emergencies_found");
}
response.sendRedirect("../emergencies.jsp");
%>