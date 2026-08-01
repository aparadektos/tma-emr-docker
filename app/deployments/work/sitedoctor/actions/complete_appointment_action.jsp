<%@page import="java.util.Date"%>
<%@page import="beans.UserHistoryBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.timeslotBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String appId=request.getParameter("appId");
if(appId!=null)
{
    appointmentsBean APPOINTMENT= siteDoctorBacking.getAppointmentByIdAndSite(appId);
    
    if(APPOINTMENT!=null)
    {
        if(siteDoctorBacking.updateAppointmentStatusByDoctor(APPOINTMENT.id,"Completed",siteDoctorBacking.AB.docBean.id))
        {
            siteDoctorBacking.okMessage=langBacking.getLiteral("appointment_completed_ok");
            siteDoctorBacking.updateAppointmentsResults(langBacking.lang);
            
            UserHistoryBean userHist = new UserHistoryBean();
            userHist.accountId=siteDoctorBacking.AB.id;
            userHist.dateAndTime=new Timestamp(new Date().getTime());
            userHist.siteId=siteDoctorBacking.AB.SB.id;
            userHist.patientId=APPOINTMENT.PB.id;
            userHist.appointmentId=APPOINTMENT.id;
            userHist.doctorId=siteDoctorBacking.AB.docBean.id;
            userHist.transaction="APPOINTMENT_COMPLETED";
            siteDoctorBacking.insertNewUserHistory(userHist);
        }
        else
        {
            siteDoctorBacking.errorMessage=langBacking.getLiteral("appointment_completed_failed");
        }
    }
    else
    {
        siteDoctorBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
    }
}
else
{
    siteDoctorBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
}

response.sendRedirect(returnToPage);

%>