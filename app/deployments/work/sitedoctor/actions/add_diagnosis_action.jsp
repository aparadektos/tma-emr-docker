

<%@page import="beans.TeleAppointmentBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");
if(returnToPage==null || returnToPage.length()==0)
{
    returnToPage="../popupAddDiagnosis.jsp";
}
    
//get new fields
request.setCharacterEncoding("UTF-8");
String teleAppId=request.getParameter("teleAppId");
String diagnosisText=request.getParameter("diagnosisText");

diagnosisText=diagnosisText.replaceAll("'", "&quot;");
diagnosisText=diagnosisText.replaceAll("\"", "&quot;");
diagnosisText=diagnosisText.replaceAll("'", "&quot;");
diagnosisText=diagnosisText.replaceAll("\"", "&quot;");

diagnosisText=diagnosisText.replaceAll("\r", "&nbsp;&nbsp;");
diagnosisText=diagnosisText.replaceAll("\n", "&nbsp;&nbsp;");
diagnosisText=diagnosisText.replaceAll("\r\n", "&nbsp;&nbsp;");

//validate 
if(teleAppId!=null && teleAppId.length()>0 && diagnosisText!=null && diagnosisText.length()>0)
{
    if(siteDoctorBacking.getSelectedTeleAppointment()!=null && teleAppId.equals(siteDoctorBacking.getSelectedTeleAppointment().getId()))
    {
        if(siteDoctorBacking.insertDiagnosisToTeleAppointment(siteDoctorBacking.getSelectedTeleAppointment(),diagnosisText)==true)
        {
            //if success response OK
            siteDoctorBacking.setOkMessage(langBacking.getLiteral("add_diagnosis_ok"));
            
            //update tele-appointment results (that was retrieved by date) with the new tele-appointment object since diagnosis was updated
            for(TeleAppointmentBean curTeleApp : siteDoctorBacking.teleAppointmentsSearchResults)
            {
                if(curTeleApp.getId().equals(siteDoctorBacking.getSelectedTeleAppointment().getId()))
                {
                    curTeleApp.setDiagnosis((siteDoctorBacking.getTeleAppointmentById(siteDoctorBacking.getSelectedTeleAppointment().getId())).getDiagnosis());
                    break;
                }
            }
            response.sendRedirect("../popupAddDiagnosis.jsp");
        }
        else
        {
            //if failed response ERROR
            siteDoctorBacking.setErrorMessage(langBacking.getLiteral("add_diagnosis_failed"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        siteDoctorBacking.setErrorMessage(langBacking.getLiteral("invalid_selection"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    siteDoctorBacking.setInfoMessage(langBacking.getLiteral("add_diagnosis_failed"));
    response.sendRedirect(returnToPage);
}

%>