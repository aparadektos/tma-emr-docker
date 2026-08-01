<%@page import="beans.EmergencyCaseBean"%>
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

String examRoomId=request.getParameter("roomFilter");
String erStartDateStr=request.getParameter("erStartDatePicker");

paramedicBacking.emergenciesSearchExamRoomId=examRoomId;
paramedicBacking.emergenciesSearchDateStr=erStartDateStr;

paramedicBacking.emergenciesSearchResults=new ArrayList<EmergencyCaseBean>(0);
                     
if(examRoomId!=null && erStartDateStr!=null)
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    Date submittedDate = sdf.parse(erStartDateStr);
    paramedicBacking.emergenciesSearchResults=paramedicBacking.getAllEmergenciesBySearch(examRoomId, submittedDate);
}
else
{
//    Date today=new Date();
//    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
//    String curDate = sdf.format(today);
//    paramedicBacking.appointmentsSearchResults=paramedicBacking.getAllAppointmentsBySiteAndDate(curDate);
}

if(paramedicBacking.emergenciesSearchResults.size()==0)
{
    paramedicBacking.infoMessage=langBacking.getLiteral("no_emergencies_found");
}
response.sendRedirect("../emergencies.jsp");
%>