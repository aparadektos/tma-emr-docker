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

//retrieve form data
String teleAppointmentComments = request.getParameter("teleAppointmentComments");
if(teleAppointmentComments!=null && teleAppointmentComments.length()>0)
{
    siteDoctorBacking.getNewTeleappointment().setComments(teleAppointmentComments);
}

//stisBean and consultantBean already set in newTeleAppointment.jsp
siteDoctorBacking.getNewTeleappointment().setAccountid(siteDoctorBacking.AB.id);
siteDoctorBacking.getNewTeleappointment().setStatus("Pending");
siteDoctorBacking.getNewTeleappointment().setSiteDoctorBean(siteDoctorBacking.AB.docBean);
siteDoctorBacking.getNewTeleappointment().setRequestedSpecialtyBean1(siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getSpecialtyBean());
if(siteDoctorBacking.getNewTeleappointment().getConsultantBean2()!=null)
{
    siteDoctorBacking.getNewTeleappointment().setRequestedSpecialtyBean2(siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getSpecialtyBean());
}

Calendar endCal = Calendar.getInstance();
endCal.setTime((Date)siteDoctorBacking.getNewTeleappointment().getStartdatetime().clone());
if(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean1().getId().equals("74"))
{
    endCal.add(Calendar.MINUTE, 60);
}
else
{
    endCal.add(Calendar.MINUTE, 30);
}
siteDoctorBacking.getNewTeleappointment().setEnddatetime(new Timestamp(endCal.getTime().getTime()));

siteDoctorBacking.getNewTeleappointment().setSB(siteDoctorBacking.AB.SB);

//check if there are any appointments already for the selected slots
//TeleAppointmentBean retrievedTeleAppoint = siteDoctorBacking.findTeleAppointmentByStisAndDateTimeFromResults(curStis.getId(),reqDateCal.getTime());


//validations
if(siteDoctorBacking.getNewTeleappointment().getAccountid()!=null && siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean()!=null &&
   siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean1()!=null && siteDoctorBacking.getNewTeleappointment().getConsultantBean1()!=null &&
   siteDoctorBacking.getNewTeleappointment().getPatientBean()!=null && siteDoctorBacking.getNewTeleappointment().getSiteDoctorBean()!=null && 
   siteDoctorBacking.getNewTeleappointment().getStartdatetime()!=null && siteDoctorBacking.getNewTeleappointment().getStisBean1()!=null &&
   siteDoctorBacking.getNewTeleappointment().getStartdatetime().after(new Timestamp(new Date().getTime())))
{
    //check if there is a conflict with other teleApp in same STIS1
    boolean stis1Conflict=false;
    boolean stis2Conflict=false;
    stis1Conflict=siteDoctorBacking.checkTeleAppointmentConflict(siteDoctorBacking.getNewTeleappointment().getStisBean1().getId(), siteDoctorBacking.getNewTeleappointment().getStartdatetime(), siteDoctorBacking.getNewTeleappointment().getEnddatetime());
    if(siteDoctorBacking.getNewTeleappointment().getStisBean2()!=null && siteDoctorBacking.getNewTeleappointment().getStisBean2().getId()!=null &&
       siteDoctorBacking.getNewTeleappointment().getStisBean2().getId().length()>0)
    {
        stis2Conflict=siteDoctorBacking.checkTeleAppointmentConflict(siteDoctorBacking.getNewTeleappointment().getStisBean2().getId(), siteDoctorBacking.getNewTeleappointment().getStartdatetime(), siteDoctorBacking.getNewTeleappointment().getEnddatetime());
    }
    
    if(stis1Conflict==false && stis2Conflict==false)
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
            if(siteDoctorBacking.newTeleAppointmentAlert(langBacking.getLiteral("new_tele_appointment"),newTeleAppMessage,siteDoctorBacking.getNewTeleappointment())==false)
            {
                siteDoctorBacking.setOkMessage(siteDoctorBacking.okMessage+"<br/><font color='red'>"+langBacking.getLiteral("new_tele_app_email_alert_failed")+"</font>");
            }
            
            siteDoctorBacking.setNewTeleappointment(new TeleAppointmentBean());
            siteDoctorBacking.setAvailableEfimeriesResults(new ArrayList<EfimeriaBean>(0));
            
            response.sendRedirect("../teleAppointmentConfirmation.jsp");
        }
        else
        {
            siteDoctorBacking.errorMessage=langBacking.getLiteral("add_teleappointment_failed");
            response.sendRedirect("../newTeleAppointment.jsp");
        }
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("appointment_conflict");
        response.sendRedirect("../newTeleAppointment.jsp");
    }
}
else
{
    siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_new_teleappointment");
    response.sendRedirect("../newTeleAppointment.jsp");
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