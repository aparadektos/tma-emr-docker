

<%@page import="backings.SiteDoctorBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="backings.LanguageBacking"%>


<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

//get new fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");

String icdId = request.getParameter("icdId");

if(icdId!=null && icdId.length()>0)
{
    for(Icd10Bean curIcd : siteDoctorBacking.getSelectedTeleAppointment().getDiagnosisIcdList())
    {
        if(curIcd.id.equals(icdId))
        {
            siteDoctorBacking.getSelectedTeleAppointment().getDiagnosisIcdList().remove(curIcd);
            break;
        }
    }
    
    if(siteDoctorBacking.updateDiagnosisIcdToTeleAppointment(siteDoctorBacking.getSelectedTeleAppointment())==true)
    {
        //SelectedTeleAppointment contains list of ICDs.....

//            consultantBacking.setOkMessage(langBacking.getLiteral(""));
    }
    else
    {
        siteDoctorBacking.setErrorMessage(langBacking.getLiteral("remove_icd_failed"));
    }
    
    //retrieve list from DB in any case
    siteDoctorBacking.getSelectedTeleAppointment().setDiagnosisIcdList(siteDoctorBacking.findDiagnosisIcdListByAppId(siteDoctorBacking.getSelectedTeleAppointment().getId()));
}
else
{
    //"invalid icdId selected");
}

response.sendRedirect(returnToPage);

%>