

<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.UserHistoryBean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String appHash=request.getParameter("appHash");
if(appHash!=null)
{
    appointmentsBean APPOINTMENT = siteDoctorBacking.getAppointmentByHash(Integer.parseInt(appHash));
    
    if(APPOINTMENT!=null)
    {
        if(siteDoctorBacking.cancelAppointment(APPOINTMENT.id))
        {
            siteDoctorBacking.okMessage=langBacking.getLiteral("appointment_cancelled_ok");
            siteDoctorBacking.updateAppointmentsResults(langBacking.lang);
            
            UserHistoryBean userHist = new UserHistoryBean();
            userHist.accountId=siteDoctorBacking.AB.id;
            userHist.dateAndTime=new Timestamp(new Date().getTime());
            userHist.siteId=siteDoctorBacking.AB.SB.id;
            userHist.patientId=APPOINTMENT.PB.id;
            userHist.appointmentId=APPOINTMENT.id;
            userHist.doctorId=siteDoctorBacking.AB.docBean.id;
            userHist.transaction="APPOINTMENT_CANCELLED";
            siteDoctorBacking.insertNewUserHistory(userHist);
        }
        else
        {
            siteDoctorBacking.errorMessage=langBacking.getLiteral("appointment_cancelled_failed");
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