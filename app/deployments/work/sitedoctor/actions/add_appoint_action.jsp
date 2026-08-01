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

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String examRoomID="";
if(request.getParameter("examRoomIDHidden")!=null && request.getParameter("examRoomIDHidden").trim().length()>0)
{
    examRoomID=request.getParameter("examRoomIDHidden").trim();
}
String selectedAppDatetime="";
if(request.getParameter("selectedAppDatetime")!=null && request.getParameter("selectedAppDatetime").trim().length()>0)
{
    selectedAppDatetime=request.getParameter("selectedAppDatetime").trim();
}
String externalPat="";
if(request.getParameter("externalPat")!=null && request.getParameter("externalPat").trim().length()>0)
{
    externalPat=request.getParameter("externalPat").trim();
}
String appComments="";
if(request.getParameter("appComments")!=null && request.getParameter("appComments").trim().length()>0)
{
    appComments=request.getParameter("appComments").trim();
}

String patComplaint="";
if(request.getParameter("patComplaint")!=null)
    patComplaint=request.getParameter("patComplaint");

String patPresentIllness="";
if(request.getParameter("patPresentIllness")!=null)
    patPresentIllness=request.getParameter("patPresentIllness");

String patMedication="";
if(request.getParameter("patMedication")!=null)
    patMedication=request.getParameter("patMedication");

String patAlergies="";
if(request.getParameter("patAlergies")!=null)
    patAlergies=request.getParameter("patAlergies");

String patPastHistory="";
if(request.getParameter("patPastHistory")!=null)
    patPastHistory=request.getParameter("patPastHistory");

String patFamilyHistory="";
if(request.getParameter("patFamilyHistory")!=null)
    patFamilyHistory=request.getParameter("patFamilyHistory");

//replace special chars
//not necessary for this action

//validate fields
if(examRoomID.length()>0 && selectedAppDatetime.length()>0 || externalPat.length()>0)
{
    //retrieve DB
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");
    GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
    
    //newAppBean already contains: patientBean, examTypeBean, duration, siteid, accountid, patid
    //add exam room info
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
%>