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
        if(siteDoctorBacking.updateTeleAppointmentStatus(selectedTeleAppointment,"Cancelled"))
        {
            siteDoctorBacking.okMessage=langBacking.getLiteral("appointment_cancelled_ok");
            
            String newTeleAppMessage = "";
            newTeleAppMessage+=langBacking.getLiteral("patient")+": "+selectedTeleAppointment.getPatientBean().name+" "+selectedTeleAppointment.getPatientBean().surname+"\n";
            newTeleAppMessage+=langBacking.getLiteral("sitedoctor")+": "+selectedTeleAppointment.getSiteDoctorBean().getFullName()+" ("+selectedTeleAppointment.getSiteDoctorBean().specialtyBean.getNameByLang(langBacking.lang)+")"+"\n";
            newTeleAppMessage+=langBacking.getLiteral("site")+": "+selectedTeleAppointment.getSB().name+"\n";
            newTeleAppMessage+=langBacking.getLiteral("date_time")+": "+selectedTeleAppointment.getStartEndDateTimeStr(langBacking.getDateFormat())+"\n";
            if(selectedTeleAppointment.getConsultantBean1()!=null && selectedTeleAppointment.getConsultantBean1().getId()!=null && selectedTeleAppointment.getConsultantBean1().getId().length()>0)
            {
                newTeleAppMessage+=langBacking.getLiteral("consultant")+": "+selectedTeleAppointment.getConsultantBean1().getFullName()+" ("+selectedTeleAppointment.getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
            }
            if(selectedTeleAppointment.getConsultantBean2()!=null && selectedTeleAppointment.getConsultantBean2().getId()!=null && selectedTeleAppointment.getConsultantBean2().getId().length()>0)
            {
                newTeleAppMessage+="\n"+langBacking.getLiteral("consultant")+": "+selectedTeleAppointment.getConsultantBean2().getFullName()+" ("+selectedTeleAppointment.getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
            }
            if(siteDoctorBacking.cancelTeleAppointmentAlert(langBacking.getLiteral("cancel_appointment"),newTeleAppMessage,selectedTeleAppointment)==false)
            {
                siteDoctorBacking.setOkMessage(siteDoctorBacking.okMessage+"<br/><font color='red'>"+langBacking.getLiteral("cancel_tele_app_email_alert_failed")+"</font>");
            }
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