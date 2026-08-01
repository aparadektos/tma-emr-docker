



<%@page import="java.util.Date"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteUserBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<%
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

//get fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String appointmentId=request.getParameter("appointmentId");

if(appointmentId!=null && appointmentId.length()>0)
{
    appointmentsBean selectedAppointment = null;
    for(appointmentsBean curAppoint : siteUserBacking.selectedPatientToViewHistoryAppointmentResults)
    {
        if(appointmentId.equals(curAppoint.id))
        {
            selectedAppointment=curAppoint;
            break;
        }
    }
    
    if(selectedAppointment!=null)
    {
        if(selectedAppointment.getProselefsiContent()==null || selectedAppointment.getProselefsiContent().length()<100)
        {
            String htmlContent="<html><head>";
            htmlContent+="<meta http-equiv='content-type' content='text/html; charset=utf-8'/>";
            htmlContent+="<title>Προσέλευση Ραντεβού - "+selectedAppointment.PB.name+" "+selectedAppointment.PB.surname+"</title></head>";
            htmlContent+="<body>";

            htmlContent+="<table border='0' width='100%'>";

            htmlContent+="<tr>";
            htmlContent+="<td colspan='2' align='left'><b>"+selectedAppointment.SB.getSitePrintTitleHtml()+"</b>";
            htmlContent+="</td>";
            htmlContent+="<td colspan='2' align='right' valign='top'>"+new Date().toLocaleString();
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td colspan='6' align='center'><h3>ΠΡΟΣΕΛΕΥΣΗ ΡΑΝΤΕΒΟΥ</h3>";
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >Κωδικός:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.getAutoIncrementNum();
            htmlContent+="</td>";
            htmlContent+="<td align='right' >Αύξων Αριθμός:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.getDailyIncrementNum();
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >Ασθενής:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.PB.name+" "+selectedAppointment.PB.surname;
            htmlContent+="</td>";
            htmlContent+="<td align='right' >Πατρώνυμο:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.PB.fathersName;
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >Ημ. Γέννησης:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.PB.getBirthDateStr(langBacking.getDateFormat());
            htmlContent+="</td>";
            htmlContent+="<td align='right' >Ασφαλιστικός Φορέας:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.PB.insurancename;
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >AMKA:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.PB.getSsn();
            htmlContent+="</td>";
            htmlContent+="<td align='right' >Τηλ:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.PB.getPhoneToPrint();
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >Τμήμα:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.ExamRoomBean.getDepartmentBean().getName();
            htmlContent+="</td>";
            htmlContent+="<td align='right' >Εξεταστήριο:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.ExamRoomBean.name;
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >Ημ. Ώρα Ραντεβού:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.getAppointmentDateTimeStr(langBacking.getDateFormat());
            htmlContent+="</td>";
            htmlContent+="<td align='right'>Διάρκεια: ";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.duration+"'";
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td align='right' >Σχόλια:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.comments;
            htmlContent+="</td>";
            htmlContent+="<td align='right' >Σύμπτωμα:";
            htmlContent+="</td>";
            htmlContent+="<td align='left'>"+selectedAppointment.complaint;
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="</table>";

            htmlContent+="<br/><b>Ιατρική Πράξη:</b> "+selectedAppointment.ETB.getDescriptionEl();
            if(selectedAppointment.MB!=null && selectedAppointment.MB.type!=null && selectedAppointment.MB.type.length()>0)
            {
                htmlContent+="<br/>Εξοπλισμός: "+selectedAppointment.MB.name+" / "+selectedAppointment.MB.type+" / "+selectedAppointment.MB.aeTitle;
            }

            htmlContent+="</body></html>";

            out.println(htmlContent);

            //..... add to database
            selectedAppointment.setProselefsiContent(htmlContent);
            siteUserBacking.savePrintedProselefsiToAppointment(selectedAppointment);
        }
        else
        {
            out.println(selectedAppointment.getProselefsiContent());
        }
        
        out.println("<script language='javascript'>print(); setTimeout(function(){window.close();}, 500); </script>");
    }
    else
    {
//        siteUserBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
//        response.sendRedirect(returnToPage);
        out.println("<script language='javascript'>window.close();</script>");
    }
}
else
{
//    siteUserBacking.errorMessage=langBacking.getLiteral("invalid_appointment");
//    response.sendRedirect(returnToPage);
    out.println("<script language='javascript'>window.close();</script>");
}

%>