
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.DoctorBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="java.util.Date"%>
<%@page import="beans.UserHistoryBean"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="tools.DBHelper"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.PacsBean"%>
<%@page import="beans.patBean"%>

<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

if(request.getParameter("apid")!=null && request.getParameter("apid").trim().length()>0)
{
    appointmentsBean APPOINTMENT= siteDoctorBacking.getAppointmentByIdAndSite(request.getParameter("apid"));
    
    if(siteDoctorBacking.AB.docBean!=null && APPOINTMENT!=null)
    {
        //select data regarding the appointment
        String exType="No^description^of^exam^type";
        if(APPOINTMENT.ETB!=null && APPOINTMENT.ETB.getDescriptionEn()!=null)
        {
            exType=APPOINTMENT.ETB.getDescriptionEn().replaceAll(" ", "^");
        }
        String patName=APPOINTMENT.PB.name.replaceAll(" ", "^");
        String patSurname=APPOINTMENT.PB.surname.replaceAll(" ", "^");

        //2012-11-15 15:45:00.0 => (20121115154500) YYYYMMDDHHMMSS
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String appDatetime=sdf.format(new Date(APPOINTMENT.startdatetime.getTime()));
        //String appDatetime=(APPOINTMENT.startdatetime.getYear()+1900)+""+(APPOINTMENT.startdatetime.getMonth()+1)+""+APPOINTMENT.startdatetime.getDate()+""+APPOINTMENT.startdatetime.getHours()+""+APPOINTMENT.startdatetime.getMinutes()+""+APPOINTMENT.startdatetime.getSeconds();
        
        if(APPOINTMENT.PB.birthDate!=null && APPOINTMENT.PB.sex!=null)
        {
            sdf = new SimpleDateFormat("yyyyMMdd");
            String patientDob=sdf.format(APPOINTMENT.PB.birthDate);

            String urlString="http://"+siteDoctorBacking.mirthPacsBean.ip+":"+siteDoctorBacking.mirthPacsBean.port+"/"+siteDoctorBacking.mirthPacsBean.context+"?";
            urlString+="patientName="+patName+"&patientSurname="+patSurname;
            urlString+="&patientDob="+patientDob;
            urlString+="&examtype="+exType;
            urlString+="&scheduledProcedureStepStart="+appDatetime;//YYYYMMDDHHMMSS
            urlString+="&appointmentID="+APPOINTMENT.id;
            urlString+="&modalityName="+APPOINTMENT.MB.type.replaceAll(" ", "^");
            urlString+="&orc21="+APPOINTMENT.id+"";//Placer Order Number
            urlString+="&obr21="+APPOINTMENT.id+"";//should be same as orc2.1. IT IS USED ALSO AS THE APPOINTMENT ID THAT WILL BE SENT BACK TO RIS (in the ccontext of study info)
            urlString+="&obr31="+APPOINTMENT.id+"";//same as ORC2.1
            urlString+="&obr18="+APPOINTMENT.id+"1";//Accession Number
            urlString+="&obr19="+APPOINTMENT.id+"2";//Requested Procedure ID
            urlString+="&obr20="+APPOINTMENT.id+"3";//Scheduled Procedure Step ID
            urlString+="&patientID="+APPOINTMENT.PB.id;//
            //einai protimotero to uniqueID tou ORDER na einai to idio me tou appointment giati me ton tropo ayto an ksanastalei to order,
            //epeidi to appointmentID tha einai to idio, tha antikatasthsei to proigoumeno order kai den tha ftiaxtei ena neo me ta idia
            //stoixeia rantebou.
            String sex = "U";//F Female M Male H Hermaphrodite, Undetermined T Transsexual O Other U Unknown
            if(APPOINTMENT.PB.sex.startsWith("F") || APPOINTMENT.PB.sex.startsWith("f"))
            {
                sex="F";
            }
            else if(APPOINTMENT.PB.sex.startsWith("M") || APPOINTMENT.PB.sex.startsWith("m"))
            {
                sex="M";
            }
            urlString+="&sex="+sex;//
            urlString+="&msh101="+APPOINTMENT.id+"-"+APPOINTMENT.PB.id+"-"+new Date().getTime()+"-"+(int)(Math.random()*100000);//

            urlString=siteDoctorBacking.convertToGreeklish(urlString);

            System.out.println("urlString= "+urlString);

            //send HTTP request
            UserHistoryBean userHist = new UserHistoryBean();
            userHist.accountId=siteDoctorBacking.AB.id;
            userHist.dateAndTime=new Timestamp(new Date().getTime());
            userHist.siteId=siteDoctorBacking.AB.SB.id;
            userHist.patientId=APPOINTMENT.PB.id;
            userHist.appointmentId=APPOINTMENT.id;
            userHist.doctorId=siteDoctorBacking.AB.docBean.id;
    
            try
            {
                URL mirthRequest = new URL(urlString);
                URLConnection mirthConn = mirthRequest.openConnection();
                BufferedReader in = new BufferedReader(new InputStreamReader(mirthConn.getInputStream()));

                if (mirthConn!=null)
                {
                    siteDoctorBacking.okMessage=langBacking.getLiteral("send_pacs_ok");
                    siteDoctorBacking.updateAppointmentStatusByDoctor(APPOINTMENT.id,"send_pacs_ok",siteDoctorBacking.AB.docBean.id);
                    userHist.transaction="APPOINTMENT_SENT_TO_PACS";
                }
                else
                {
                    siteDoctorBacking.errorMessage=langBacking.getLiteral("send_pacs_failed");
                    userHist.transaction="APPOINTMENT_SEND_TO_PACS_FAILED";
                    siteDoctorBacking.updateAppointmentStatusByDoctor(APPOINTMENT.id,"send_pacs_failed",siteDoctorBacking.AB.docBean.id);
                }
            }
            catch(Exception e)
            {
                e.printStackTrace();
                userHist.transaction="APPOINTMENT_SEND_TO_PACS_FAILED";
                siteDoctorBacking.updateAppointmentStatusByDoctor(APPOINTMENT.id,"send_pacs_failed",siteDoctorBacking.AB.SB.id);
                siteDoctorBacking.errorMessage=langBacking.getLiteral("send_pacs_failed");
            }

            siteDoctorBacking.insertNewUserHistory(userHist);
        }
        else
        {
            siteDoctorBacking.infoMessage=langBacking.getLiteral("missing_patient_required_fields");
        }
    }
    else
    {
        siteDoctorBacking.errorMessage="Invalid appointment or doctor";
    }
}
else
{
    siteDoctorBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
}

siteDoctorBacking.updateAppointmentsResults(langBacking.lang);

response.sendRedirect(returnToPage);
 %>