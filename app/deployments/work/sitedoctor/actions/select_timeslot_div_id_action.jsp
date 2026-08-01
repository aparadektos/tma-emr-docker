
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="beans.appointmentsBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

//get new fields
request.setCharacterEncoding("UTF-8");

//String returnToPage=request.getHeader("Referer");

String divId = request.getParameter("divId");
String examRoomId = request.getParameter("examRoomId");
String appointmentComment = request.getParameter("appointmentComment");

if(divId!=null && divId.length()>0 && examRoomId!=null && examRoomId.length()>0)
{
    siteDoctorBacking.selectedTimeslotDivId=divId;
    siteDoctorBacking.selectedExamRoomId=examRoomId;
    
    appointmentsBean newAppBean=(appointmentsBean)session.getAttribute("newAppBean");
    newAppBean.comments=appointmentComment;
    
//    System.out.print(siteDoctorBacking.selectedTimeslotDivId);
}
else
{
    //"invalid icdId selected");
}

//response.sendRedirect(returnToPage);

%>