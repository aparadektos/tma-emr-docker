



<%@page import="java.text.SimpleDateFormat"%>
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
        if(selectedAppointment.getDeltioContent()==null || selectedAppointment.getDeltioContent().length()<100)
        {
            int yearlyDeltioNumber = siteUserBacking.savePrintedDeltioNumberToAppointment(selectedAppointment);
            selectedAppointment.setYearlyDeltioNum(yearlyDeltioNumber);
            
            String htmlContent="<html><head>";
            htmlContent+="<meta http-equiv='content-type' content='text/html; charset=utf-8'/>";
            htmlContent+="<title>Δελτίο Παροχής Υπηρεσιών - "+selectedAppointment.PB.name+" "+selectedAppointment.PB.surname+"</title></head>";
            htmlContent+="<body>";

            htmlContent+="<table border='0' width='100%'>";

            htmlContent+="<tr>";
            htmlContent+="<td colspan='2' align='left'><b>"+selectedAppointment.SB.getSitePrintTitleHtml()+"</b>";
            htmlContent+="</td>";
            htmlContent+="<td colspan='2' align='right' valign='top'>"+new Date().toLocaleString();
                htmlContent+="<br/><br/><table border='0'>";
                htmlContent+="<tr>";
                htmlContent+="<td align='right'>NO: ";
                htmlContent+="</td>";
                htmlContent+="<td>"+selectedAppointment.getYearlyDeltioNum();
                htmlContent+="</td>";
                htmlContent+="</tr>";
                htmlContent+="<tr>";
                htmlContent+="<td align='right'>ΣΕΙΡΑ: ";
                htmlContent+="</td>";
                htmlContent+="<td>Γ3";
                htmlContent+="</td>";
                htmlContent+="</tr>";
                htmlContent+="<tr>";
                htmlContent+="<td align='right'>ΟΙΚΟΝ. ΕΤΟΣ: ";
                htmlContent+="</td>";
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
                htmlContent+="<td>"+sdf.format(selectedAppointment.startdatetime);
                htmlContent+="</td>";
                htmlContent+="</tr>";
                htmlContent+="</table>";
            htmlContent+="</td>";
            htmlContent+="</tr>";
            
            htmlContent+="<tr>";
            htmlContent+="<td colspan='6' align='left'><br/><b>ΕΚΔΟΤΗΣ:</b> "+siteUserBacking.AB.name+" "+siteUserBacking.AB.surname+" ";
            htmlContent+="</td>";
            htmlContent+="</tr>";
            
            htmlContent+="<tr>";
            htmlContent+="<td colspan='6' align='left'><b>TMHMA:</b> ΓΡΑΜΜΑΤΕΙΑ ΕΞΩΤΕΡΙΚΩΝ ΙΑΤΡΕΙΩΝ";
            htmlContent+="</td>";
            htmlContent+="</tr>";

            htmlContent+="<tr>";
            htmlContent+="<td colspan='6' align='center'><br/><b>ΔΕΛΤΙΟ ΠΑΡΟΧΗΣ ΥΠΗΡΕΣΙΩΝ</b><br/>Αθεώρητο βάσει της Α.Υ.Ο ΠΟΛ. 1083/2003";
            htmlContent+="</td>";
            htmlContent+="</tr>";
            htmlContent+="</table>";
            
            htmlContent+="<br/>";
            
            htmlContent+="<table border='0' width='100%' style='border: 1px solid gray;border-collapse: collapse;'>";
            htmlContent+="<tr>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΑΜΚΑ</b>";
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΟΝ/ΜΟ</b>";
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΠΑΤΡΩΝΥΜΟ</b>";
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΑΣΦ. ΦΟΡΕΑΣ</b>";
            htmlContent+="</td>";
            htmlContent+="</tr>";
            
            htmlContent+="<tr>";
            htmlContent+="<td align='left' style='border: 1px solid gray;'>"+selectedAppointment.PB.getSsn();
            htmlContent+="</td>";
            htmlContent+="<td align='left' style='border: 1px solid gray;'>"+selectedAppointment.PB.name+" "+selectedAppointment.PB.surname;
            htmlContent+="</td>";
            htmlContent+="<td align='left' style='border: 1px solid gray;'>"+selectedAppointment.PB.fathersName;
            htmlContent+="</td>";
            htmlContent+="<td align='left' style='border: 1px solid gray;'>"+selectedAppointment.PB.insurancename;
            htmlContent+="</td>";
            htmlContent+="</tr>";
            
            htmlContent+="<tr>";
            htmlContent+="<td colspan='6' align='left'><b>ΔΙΕΥΘΥΝΣΗ: </b>"+selectedAppointment.PB.getAddressStr();
            htmlContent+="</td>";
            htmlContent+="</tr>";
            htmlContent+="</table>";
            
            htmlContent+="<br/><br/>Ο ΑΝΑΓΡΑΦΟΜΕΝΟΣ ΠΛΗΡΩΣΕ ΤΑ ΑΚΟΛΟΥΘΑ ΠΟΣΑ<br/><br/>";
            
            htmlContent+="<table border='0' width='100%' style='border: 1px solid gray;border-collapse: collapse;'>";
            htmlContent+="<tr>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΑΙΤΙΟΛΟΓΙΑ</b>";
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΑΡ.ΤΙΜ.</b>";
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΧΡΗΣΗ</b>";
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΠΟΣΟ</b>";
            htmlContent+="</td>";
            if(selectedAppointment.ETB.getComments()!=null && selectedAppointment.ETB.getComments().length()>0)
            {
                htmlContent+="<td align='center' style='border: 1px solid gray;'><b>ΠΑΡΑΤΗΡΗΣΕΙΣ</b></td>";
            }
            htmlContent+="</tr>";
            
            htmlContent+="<tr>";
            htmlContent+="<td align='left' style='border: 1px solid gray;'>"+selectedAppointment.ETB.getDescriptionEl();
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'>"+selectedAppointment.ETB.getCode();
            htmlContent+="</td>";
            sdf = new SimpleDateFormat("yyyy");
            htmlContent+="<td align='center' style='border: 1px solid gray;'>"+sdf.format(selectedAppointment.startdatetime);
            htmlContent+="</td>";
            htmlContent+="<td align='center' style='border: 1px solid gray;'>"+selectedAppointment.ETB.getCost();
            htmlContent+="</td>";
            if(selectedAppointment.ETB.getComments()!=null && selectedAppointment.ETB.getComments().length()>0)
            {
                htmlContent+="<td align='left' style='border: 1px solid gray;'>"+selectedAppointment.ETB.getComments();
            }
            htmlContent+="</tr>";
            
            htmlContent+="</table>";
            
            htmlContent+="<br/>";
            
            htmlContent+="<table>";
            htmlContent+="<tr>";
            htmlContent+="<td align='right'>ΕΙΣΠΡΑΧΘΗΚΑΝ: ";
            htmlContent+="</td>";
            htmlContent+="<td>"+selectedAppointment.ETB.getCostEl();
            htmlContent+="</td>";
            htmlContent+="</tr>";
            htmlContent+="<tr>";
            htmlContent+="<td align='right'>ΣΥΝΟΛΟ: ";
            htmlContent+="</td>";
            htmlContent+="<td>"+selectedAppointment.ETB.getCost()+" Ευρώ";
            htmlContent+="</td>";
            htmlContent+="</tr>";
            htmlContent+="</table>";
            
            htmlContent+="<table border='0' width='100%'>";
            htmlContent+="<tr>";
            htmlContent+="<td width='50%'> ";
            htmlContent+="</td>";
            htmlContent+="<td width='50%' align='center'>";
            sdf = new SimpleDateFormat("dd-MM-yyyy");
            htmlContent+="ΑΤΤΙΚΗΣ, "+sdf.format(new Date());
            htmlContent+="<br/><br/><br/><br/>";
            htmlContent+="<b>Ο ΕΙΣΠΡΑΞΑΣ</b>";
            htmlContent+="</td>";
            htmlContent+="</table>";
            
            htmlContent+="</body></html>";
            
            out.println(htmlContent);
            
            //..... add to database
            selectedAppointment.setDeltioContent(htmlContent);
            siteUserBacking.savePrintedDeltioToAppointment(selectedAppointment);
        }
        else
        {
            out.println(selectedAppointment.getDeltioContent());
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