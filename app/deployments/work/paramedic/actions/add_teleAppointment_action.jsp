<%@page import="beans.EfimeriaBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.timeslotBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<%
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String teleAppointmentComments = request.getParameter("teleAppointmentComments");
if(teleAppointmentComments!=null && teleAppointmentComments.length()>0)
{
    paramedicBacking.getNewTeleappointment().setComments(teleAppointmentComments);
}

//stisBean and consultantBean already set in newTeleAppointment.jsp
paramedicBacking.getNewTeleappointment().setAccountid(paramedicBacking.AB.id);
paramedicBacking.getNewTeleappointment().setStatus("Pending");
paramedicBacking.getNewTeleappointment().setSiteDoctorBean(null);
paramedicBacking.getNewTeleappointment().setParamedicBean(paramedicBacking.AB.getParamedicBean());
paramedicBacking.getNewTeleappointment().setRequestedSpecialtyBean1(paramedicBacking.getNewTeleappointment().getConsultantBean1().getSpecialtyBean());
if(paramedicBacking.getNewTeleappointment().getConsultantBean2()!=null)
{
    paramedicBacking.getNewTeleappointment().setRequestedSpecialtyBean2(paramedicBacking.getNewTeleappointment().getConsultantBean2().getSpecialtyBean());
}

Calendar endCal = Calendar.getInstance();
endCal.setTime((Date)paramedicBacking.getNewTeleappointment().getStartdatetime().clone());
if(paramedicBacking.getNewTeleappointment().getRequestedSpecialtyBean1().getId().equals("74"))
{
    endCal.add(Calendar.MINUTE, 60);
}
else
{
    endCal.add(Calendar.MINUTE, 30);
}
paramedicBacking.getNewTeleappointment().setEnddatetime(new Timestamp(endCal.getTime().getTime()));

paramedicBacking.getNewTeleappointment().setSB(paramedicBacking.AB.SB);
        
//check if there are any appointments already for the selected slots
//TeleAppointmentBean retrievedTeleAppoint = paramedicBacking.findTeleAppointmentByStisAndDateTimeFromResults(curStis.getId(),reqDateCal.getTime());


//validations
if(paramedicBacking.getNewTeleappointment().getAccountid()!=null && paramedicBacking.getNewTeleappointment().getParamedicBean()!=null &&
   paramedicBacking.getNewTeleappointment().getRequestedSpecialtyBean1()!=null && paramedicBacking.getNewTeleappointment().getConsultantBean1()!=null &&
   paramedicBacking.getNewTeleappointment().getPatientBean()!=null &&  
   paramedicBacking.getNewTeleappointment().getStartdatetime()!=null && paramedicBacking.getNewTeleappointment().getStisBean1()!=null &&
   paramedicBacking.getNewTeleappointment().getStartdatetime().after(new Timestamp(new Date().getTime())))
{
    //check if there is a conflict with other teleApp in same STIS1
    if(paramedicBacking.checkTeleAppointmentConflict(paramedicBacking.getNewTeleappointment().getStisBean1().getId(), paramedicBacking.getNewTeleappointment().getStartdatetime(), paramedicBacking.getNewTeleappointment().getEnddatetime())==false)
    {
        boolean stis2Conflict=false;
        if(paramedicBacking.getNewTeleappointment().getStisBean2()!=null && paramedicBacking.getNewTeleappointment().getStisBean2().getId()!=null && 
           paramedicBacking.getNewTeleappointment().getStisBean2().getId().length()>0)
        {
            stis2Conflict=paramedicBacking.checkTeleAppointmentConflict(paramedicBacking.getNewTeleappointment().getStisBean2().getId(), paramedicBacking.getNewTeleappointment().getStartdatetime(), paramedicBacking.getNewTeleappointment().getEnddatetime());
        }
        
        if(stis2Conflict==false)
        {
            //insert new 
            if(paramedicBacking.insertNewTeleAppointment(paramedicBacking.getNewTeleappointment())==true)
            {
                paramedicBacking.okMessage=langBacking.getLiteral("add_teleappointment_ok");
                
                String newTeleAppMessage = "";
                newTeleAppMessage+=langBacking.getLiteral("patient")+": "+paramedicBacking.getNewTeleappointment().getPatientBean().name+" "+paramedicBacking.getNewTeleappointment().getPatientBean().surname+"\n";
                newTeleAppMessage+=langBacking.getLiteral("paramedic")+": "+paramedicBacking.getNewTeleappointment().getParamedicBean().getFullName()+" ("+paramedicBacking.getNewTeleappointment().getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")"+"\n";
                newTeleAppMessage+=langBacking.getLiteral("site")+": "+paramedicBacking.getNewTeleappointment().getSB().name+"\n";
                newTeleAppMessage+=langBacking.getLiteral("date_time")+": "+paramedicBacking.getNewTeleappointment().getStartEndDateTimeStr(langBacking.getDateFormat())+"\n";
                if(paramedicBacking.getNewTeleappointment().getConsultantBean1()!=null && paramedicBacking.getNewTeleappointment().getConsultantBean1().getId()!=null && paramedicBacking.getNewTeleappointment().getConsultantBean1().getId().length()>0)
                {
                    newTeleAppMessage+=langBacking.getLiteral("consultant")+": "+paramedicBacking.getNewTeleappointment().getConsultantBean1().getFullName()+" ("+paramedicBacking.getNewTeleappointment().getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                }
                if(paramedicBacking.getNewTeleappointment().getConsultantBean2()!=null && paramedicBacking.getNewTeleappointment().getConsultantBean2().getId()!=null && paramedicBacking.getNewTeleappointment().getConsultantBean2().getId().length()>0)
                {
                    newTeleAppMessage+="\n"+langBacking.getLiteral("consultant")+": "+paramedicBacking.getNewTeleappointment().getConsultantBean2().getFullName()+" ("+paramedicBacking.getNewTeleappointment().getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                }
                if(paramedicBacking.newTeleAppointmentAlert(langBacking.getLiteral("new_tele_appointment"),newTeleAppMessage,paramedicBacking.getNewTeleappointment())==false)
                {
                    paramedicBacking.setOkMessage(paramedicBacking.okMessage+"<br/><font color='red'>"+langBacking.getLiteral("new_tele_app_email_alert_failed")+"</font>");
                }
                
                paramedicBacking.setNewTeleappointment(new TeleAppointmentBean());
                paramedicBacking.setAvailableEfimeriesResults(new ArrayList<EfimeriaBean>(0));
                response.sendRedirect("../teleAppointmentConfirmation.jsp");
            }
            else
            {
                paramedicBacking.errorMessage=langBacking.getLiteral("add_teleappointment_failed");
                response.sendRedirect("../newTeleAppointment.jsp");
            }
        }
        else
        {
            paramedicBacking.infoMessage=langBacking.getLiteral("appointment_conflict");
            response.sendRedirect("../newTeleAppointment.jsp");
        }
    }
    else
    {
        paramedicBacking.infoMessage=langBacking.getLiteral("appointment_conflict");
        response.sendRedirect("../newTeleAppointment.jsp");
    }
}
else
{
    paramedicBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
    response.sendRedirect("../newTeleAppointment.jsp");
}

%>