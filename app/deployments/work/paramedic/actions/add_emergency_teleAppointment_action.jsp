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

String returnToPage=request.getHeader("Referer");
if(returnToPage==null || returnToPage.length()==0)
{
    returnToPage="../popupAssignConsultant.jsp";
}

//retrieve form data
String selectedEmergencyEfimeriaId = request.getParameter("selectedEmergencyEfimeriaId");
String selectedEmergencyTime = request.getParameter("selectedEmergencyTime");

if(selectedEmergencyEfimeriaId!=null && selectedEmergencyEfimeriaId.length()>0 && 
   selectedEmergencyTime!=null && selectedEmergencyTime.length()>0)
{
    paramedicBacking.setNewTeleappointment(new TeleAppointmentBean());
    paramedicBacking.getNewTeleappointment().setAccountid(paramedicBacking.AB.id);
    paramedicBacking.getNewTeleappointment().setStatus("Pending");
    paramedicBacking.getNewTeleappointment().setParamedicBean(paramedicBacking.AB.getParamedicBean());
    paramedicBacking.getNewTeleappointment().setPatientBean(paramedicBacking.getSelectedEmergencyCaseBean().patientBean);
    paramedicBacking.getNewTeleappointment().setEmergencyCaseId(paramedicBacking.getSelectedEmergencyCaseBean().id);
    
    EfimeriaBean selectedEfimeriaBean = null;
    for(EfimeriaBean curEfimeria : paramedicBacking.getAvailableEfimeriesForEmergencyResults())
    {
        if(curEfimeria.getId().equals(selectedEmergencyEfimeriaId))
        {
            selectedEfimeriaBean=curEfimeria;
            paramedicBacking.getNewTeleappointment().setStisBean1(selectedEfimeriaBean.getStisBean());
            paramedicBacking.getNewTeleappointment().setConsultantBean1(selectedEfimeriaBean.getConsultantBean());
            paramedicBacking.getNewTeleappointment().setRequestedSpecialtyBean1(selectedEfimeriaBean.getConsultantBean().getSpecialtyBean());
            break;
        }
    }
    
    Date selectedDateTime = null;
    try
    {
        SimpleDateFormat sdfDate = new SimpleDateFormat(langBacking.getDateFormat());
        String curDateStr=sdfDate.format(new Date());
        
        SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
        selectedDateTime = sdf.parse(curDateStr+" "+selectedEmergencyTime);
        paramedicBacking.getNewTeleappointment().setStartdatetime(new Timestamp(selectedDateTime.getTime()));
    }
    catch(Exception e)
    {
        selectedDateTime = null;
        paramedicBacking.getNewTeleappointment().setStartdatetime(null);
    }
    
    if(selectedDateTime==null || paramedicBacking.getNewTeleappointment().getStartdatetime()==null)
    {
        paramedicBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
        response.sendRedirect(returnToPage);
    }
    else
    {
        Calendar endCal = Calendar.getInstance();
        endCal.setTime((Date)paramedicBacking.getNewTeleappointment().getStartdatetime().clone());
        endCal.add(Calendar.MINUTE, 30);
        paramedicBacking.getNewTeleappointment().setEnddatetime(new Timestamp(endCal.getTime().getTime()));
        
        //indicate emergency tele-appointment
        paramedicBacking.getNewTeleappointment().setEmergency("true");
        
        paramedicBacking.getNewTeleappointment().setSB(paramedicBacking.AB.SB);
        
        //validations
        if(paramedicBacking.getNewTeleappointment().getAccountid()!=null && paramedicBacking.getNewTeleappointment().getParamedicBean()!=null &&
           paramedicBacking.getNewTeleappointment().getRequestedSpecialtyBean1()!=null && paramedicBacking.getNewTeleappointment().getConsultantBean1()!=null &&
           paramedicBacking.getNewTeleappointment().getPatientBean()!=null && 
           paramedicBacking.getNewTeleappointment().getStartdatetime()!=null && paramedicBacking.getNewTeleappointment().getStisBean1()!=null &&
           paramedicBacking.getNewTeleappointment().getStartdatetime().after(new Timestamp(new Date().getTime())))
        {
            //check if there is a conflict with other teleApp in same STIS
            if(paramedicBacking.checkTeleAppointmentConflict(paramedicBacking.getNewTeleappointment().getStisBean1().getId(), paramedicBacking.getNewTeleappointment().getStartdatetime(), paramedicBacking.getNewTeleappointment().getEnddatetime())==false)
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
                    if(paramedicBacking.newTeleAppointmentAlert(langBacking.getLiteral("new_emergency_case"),newTeleAppMessage,paramedicBacking.getNewTeleappointment())==false)
                    {
                        paramedicBacking.setOkMessage(paramedicBacking.okMessage+"<br/><font color='red'>"+langBacking.getLiteral("new_tele_app_email_alert_failed")+"</font>");
                    }
                    
                    paramedicBacking.setNewTeleappointment(new TeleAppointmentBean());
                    paramedicBacking.setAvailableEfimeriesResults(new ArrayList<EfimeriaBean>(0));
                    paramedicBacking.setAvailableEfimeriesForEmergencyResults(new ArrayList<EfimeriaBean>(0));
                    response.sendRedirect(returnToPage);
                }
                else
                {
                    paramedicBacking.errorMessage=langBacking.getLiteral("add_teleappointment_failed");
                    response.sendRedirect(returnToPage);
                }
            }
            else
            {
                paramedicBacking.infoMessage=langBacking.getLiteral("appointment_conflict");
                response.sendRedirect(returnToPage);
            }
        }
        else
        {
            paramedicBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
            response.sendRedirect(returnToPage);
        }
    }
}
else
{
    paramedicBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
    response.sendRedirect(returnToPage);
}

%>