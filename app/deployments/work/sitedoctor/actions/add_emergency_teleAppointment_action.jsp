<%@page import="beans.EfimeriaBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.Icd10Bean"%>
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
    siteDoctorBacking.setNewTeleappointment(new TeleAppointmentBean());
    siteDoctorBacking.getNewTeleappointment().setAccountid(siteDoctorBacking.AB.id);
    siteDoctorBacking.getNewTeleappointment().setStatus("Pending");
    siteDoctorBacking.getNewTeleappointment().setSiteDoctorBean(siteDoctorBacking.AB.docBean);
    siteDoctorBacking.getNewTeleappointment().setPatientBean(siteDoctorBacking.getSelectedEmergencyCaseBean().patientBean);
    siteDoctorBacking.getNewTeleappointment().setEmergencyCaseId(siteDoctorBacking.getSelectedEmergencyCaseBean().id);
    
    EfimeriaBean selectedEfimeriaBean = null;
    for(EfimeriaBean curEfimeria : siteDoctorBacking.getAvailableEfimeriesForEmergencyResults())
    {
        if(curEfimeria.getId().equals(selectedEmergencyEfimeriaId))
        {
            selectedEfimeriaBean=curEfimeria;
            siteDoctorBacking.getNewTeleappointment().setStisBean1(selectedEfimeriaBean.getStisBean());
            siteDoctorBacking.getNewTeleappointment().setConsultantBean1(selectedEfimeriaBean.getConsultantBean());
            siteDoctorBacking.getNewTeleappointment().setRequestedSpecialtyBean1(selectedEfimeriaBean.getConsultantBean().getSpecialtyBean());
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
        siteDoctorBacking.getNewTeleappointment().setStartdatetime(new Timestamp(selectedDateTime.getTime()));
    }
    catch(Exception e)
    {
        selectedDateTime = null;
        siteDoctorBacking.getNewTeleappointment().setStartdatetime(null);
    }
    
    if(selectedDateTime==null || siteDoctorBacking.getNewTeleappointment().getStartdatetime()==null)
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
        response.sendRedirect(returnToPage);
    }
    else
    {
        Calendar endCal = Calendar.getInstance();
        endCal.setTime((Date)siteDoctorBacking.getNewTeleappointment().getStartdatetime().clone());
        endCal.add(Calendar.MINUTE, 30);
        siteDoctorBacking.getNewTeleappointment().setEnddatetime(new Timestamp(endCal.getTime().getTime()));
        
        //indicate emergency tele-appointment
        siteDoctorBacking.getNewTeleappointment().setEmergency("true");
        
        siteDoctorBacking.getNewTeleappointment().setSB(siteDoctorBacking.AB.SB);
        
        //validations
        if(siteDoctorBacking.getNewTeleappointment().getAccountid()!=null && siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean()!=null &&
           siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean1()!=null && siteDoctorBacking.getNewTeleappointment().getConsultantBean1()!=null &&
           siteDoctorBacking.getNewTeleappointment().getPatientBean()!=null && siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean()!=null && 
           siteDoctorBacking.getNewTeleappointment().getStartdatetime()!=null && siteDoctorBacking.getNewTeleappointment().getStisBean1()!=null &&
           siteDoctorBacking.getNewTeleappointment().getStartdatetime().after(new Timestamp(new Date().getTime())))
        {
            //check if there is a conflict with other teleApp in same STIS
            if(siteDoctorBacking.checkTeleAppointmentConflict(siteDoctorBacking.getNewTeleappointment().getStisBean1().getId(), siteDoctorBacking.getNewTeleappointment().getStartdatetime(), siteDoctorBacking.getNewTeleappointment().getEnddatetime())==false)
            {
                //insert new 
                if(siteDoctorBacking.insertNewTeleAppointment(siteDoctorBacking.getNewTeleappointment())==true)
                {
                    siteDoctorBacking.okMessage=langBacking.getLiteral("add_teleappointment_ok");
                    
                    String newTeleAppMessage = "";
                    newTeleAppMessage+=langBacking.getLiteral("patient")+": "+siteDoctorBacking.getNewTeleappointment().getPatientBean().name+" "+siteDoctorBacking.getNewTeleappointment().getPatientBean().surname+"\n";
                    newTeleAppMessage+=langBacking.getLiteral("sitedoctor")+": "+siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean().getFullName()+" ("+siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean().specialtyBean.getNameByLang(langBacking.lang)+")"+"\n";
                    newTeleAppMessage+=langBacking.getLiteral("site")+": "+siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean().SB.name+"\n";
                    newTeleAppMessage+=langBacking.getLiteral("date_time")+": "+siteDoctorBacking.getNewTeleappointment().getStartEndDateTimeStr(langBacking.getDateFormat())+"\n";
                    if(siteDoctorBacking.getNewTeleappointment().getConsultantBean1()!=null && siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getId()!=null && siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getId().length()>0)
                    {
                        newTeleAppMessage+=langBacking.getLiteral("consultant")+": "+siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getFullName()+" ("+siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                    }
                    if(siteDoctorBacking.getNewTeleappointment().getConsultantBean2()!=null && siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getId()!=null && siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getId().length()>0)
                    {
                        newTeleAppMessage+="\n"+langBacking.getLiteral("consultant")+": "+siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getFullName()+" ("+siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                    }
                    if(siteDoctorBacking.newTeleAppointmentAlert(langBacking.getLiteral("new_emergency_case"),newTeleAppMessage,siteDoctorBacking.getNewTeleappointment())==false)
                    {
                        siteDoctorBacking.setOkMessage(siteDoctorBacking.okMessage+"<br/><font color='red'>"+langBacking.getLiteral("new_tele_app_email_alert_failed")+"</font>");
                    }
                    
                    siteDoctorBacking.setNewTeleappointment(new TeleAppointmentBean());
                    siteDoctorBacking.setAvailableEfimeriesResults(new ArrayList<EfimeriaBean>(0));
                    siteDoctorBacking.setAvailableEfimeriesForEmergencyResults(new ArrayList<EfimeriaBean>(0));
                    response.sendRedirect(returnToPage);
                }
                else
                {
                    siteDoctorBacking.errorMessage=langBacking.getLiteral("add_teleappointment_failed");
                    response.sendRedirect(returnToPage);
                }
            }
            else
            {
                siteDoctorBacking.infoMessage=langBacking.getLiteral("appointment_conflict");
                response.sendRedirect(returnToPage);
            }
        }
        else
        {
            siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
            response.sendRedirect(returnToPage);
        }
    }
}
else
{
    siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
    response.sendRedirect(returnToPage);
}











/*


//validate fields
if(examRoomID.length()>0 && selectedAppDatetime.length()>0 || externalPat.length()>0)
{
    
    appointmentsBean newAppBean=(appointmentsBean)session.getAttribute("newAppBean");
    newAppBean.ExamRoomBean=DBH.getExamRoomByID(examRoomID);
    if(newAppBean.ExamRoomBean!=null)
    {
        //add modality bean
        newAppBean.MB=newAppBean.ExamRoomBean.modBean;
        //add date and timeslot  -  11/15/2012 14:00 - 14:15
        String tmpDatetime[]=selectedAppDatetime.split(" ");
        //tmpDatetime[0]=11/15/2012, tmpDatetime[1]=14:00, tmpDatetime[2]=-, tmpDatetime[3]=16:15
        String tmp[]=tmpDatetime[0].split("/");
        //tmp[0]=11, tmp[1]=15, tmp[2]=2012
        newAppBean.startdatetimeStr=tmp[2]+"-"+tmp[0]+"-"+tmp[1]+" "+tmpDatetime[1];
        newAppBean.enddatetimeStr=tmp[2]+"-"+tmp[0]+"-"+tmp[1]+" "+tmpDatetime[3];
        //add if it is external
        newAppBean.isexternal=externalPat;
        //add status
        newAppBean.status="Pending";
        //add comments
        newAppBean.comments=appComments;
        
        newAppBean.complaint=patComplaint;
        newAppBean.presentIllness=patPresentIllness;
        newAppBean.medication=patMedication;
        newAppBean.alergies=patAlergies;
        newAppBean.pastHistory=patPastHistory;
        newAppBean.familyHistory=patFamilyHistory;
        
        //2016-04-24 9:00
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        newAppBean.startdatetime=new Timestamp((sdf.parse(newAppBean.startdatetimeStr)).getTime());
    
        //insert new appointment to DB
        if(siteDoctorBacking.insertNewAppointment(newAppBean)==true)
        {
            //clear temporary info from session
            session.setAttribute("examRoomsResults", null);
            //newAppBean will be cleared from session after the confirmation view is loaded
            siteDoctorBacking.updateAppointmentsResults(langBacking.lang);
            
            siteDoctorBacking.clearAppointmentVariables();

            response.sendRedirect("../patients.jsp?action=confirmApp");
        }
        else
        {
            siteDoctorBacking.errorMessage=langBacking.getLiteral("add_appointment_failed");
            response.sendRedirect("../patients.jsp?action=newAppoint&patid="+newAppBean.PB.id+"&onDate="+tmpDatetime[0]);
        }
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("new_appointment_required_fields");
        response.sendRedirect("../patients.jsp?action=newAppoint&patid="+newAppBean.PB.id);
    }
}
else
{
    response.sendRedirect("../patients.jsp?results=invalidParams");
}
        */
%>