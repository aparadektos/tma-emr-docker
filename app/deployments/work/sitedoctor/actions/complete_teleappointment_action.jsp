<%@page import="beans.TeleAppointmentBean"%>
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

<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String teleAppHash=request.getParameter("teleAppHash");
if(teleAppHash!=null)
{
    TeleAppointmentBean selectedTeleAppointment = null;
    for(TeleAppointmentBean curTeleAppointmentBean : siteDoctorBacking.teleAppointmentsSearchResults)
    {
        if((curTeleAppointmentBean.hashCode()+"").equals(teleAppHash))
        {
            selectedTeleAppointment=curTeleAppointmentBean;
            break;
        }
    }
    
    if(selectedTeleAppointment!=null)
    {
        if(siteDoctorBacking.updateTeleAppointmentStatus(selectedTeleAppointment,"Completed"))
        {
            siteDoctorBacking.okMessage=langBacking.getLiteral("appointment_completed_ok");
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