

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
    Icd10Bean icdBean=siteDoctorBacking.getIcd10ById(icdId);
    if(icdBean!=null)
    {
        if(siteDoctorBacking.getSelectedTeleAppointment().getDiagnosisIcdList()==null)
        {
            siteDoctorBacking.getSelectedTeleAppointment().setDiagnosisIcdList(new ArrayList<Icd10Bean>(0));
        }
        siteDoctorBacking.getSelectedTeleAppointment().getDiagnosisIcdList().add(icdBean);
        
        //add to DB
        if(siteDoctorBacking.updateDiagnosisIcdToTeleAppointment(siteDoctorBacking.getSelectedTeleAppointment())==true)
        {
            //SelectedTeleAppointment contains list of ICDs.....
            
//            consultantBacking.setOkMessage(langBacking.getLiteral(""));
        }
        else
        {
            siteDoctorBacking.setErrorMessage(langBacking.getLiteral("add_icd_failed"));
        }
        
        //retrieve adviceIcdList from DB in any case
        siteDoctorBacking.getSelectedTeleAppointment().setDiagnosisIcdList(siteDoctorBacking.findDiagnosisIcdListByAppId(siteDoctorBacking.getSelectedTeleAppointment().getId()));
    }
    else
    {
        //"invalid icdId selected");
    }
}
else
{
    //"invalid icdId selected");
}

response.sendRedirect(returnToPage);

%>