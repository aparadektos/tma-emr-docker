

<%@page import="backings.SiteUserBacking"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.UserHistoryBean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String appHash=request.getParameter("appHash");
if(appHash!=null)
{
    appointmentsBean APPOINTMENT = siteUserBacking.getAppointmentByHash(Integer.parseInt(appHash));
    
    if(APPOINTMENT!=null)
    {
        if(siteUserBacking.cancelAppointment(APPOINTMENT.id))
        {
            siteUserBacking.okMessage=langBacking.getLiteral("appointment_cancelled_ok");
            siteUserBacking.updateAppointmentsResults(langBacking.lang);
            
            UserHistoryBean userHist = new UserHistoryBean();
            userHist.accountId=siteUserBacking.AB.id;
            userHist.dateAndTime=new Timestamp(new Date().getTime());
            userHist.siteId=siteUserBacking.AB.SB.id;
            userHist.patientId=APPOINTMENT.PB.id;
            userHist.appointmentId=APPOINTMENT.id;
            //userHist.doctorId=siteDoctorBacking.AB.docBean.id;
            userHist.transaction="APPOINTMENT_CANCELLED";
            siteUserBacking.insertNewUserHistory(userHist);
        }
        else
        {
            siteUserBacking.errorMessage=langBacking.getLiteral("appointment_cancelled_failed");
        }
    }
    else
    {
        siteUserBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
    }
}
else
{
    siteUserBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
}

response.sendRedirect(returnToPage);

%>