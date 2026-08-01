

<%@page import="beans.EmergencyCaseBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

//String returnToPage=request.getHeader("Referer");
String returnToPage="../popupNewEmergencyFile.jsp";

String erFileId=request.getParameter("erFileId");

if(siteDoctorBacking.getSelectedEmergencyCaseBean()!=null)
{
    if(erFileId!=null && erFileId.length()>0)
    {
        if(siteDoctorBacking.removeEmergencyFileFromCase(siteDoctorBacking.getSelectedEmergencyCaseBean(), erFileId)==true)
        {

        }
        else
        {
            siteDoctorBacking.errorMessage=langBacking.getLiteral("update_emergency_files_failed");
        }
    }
    else
    {
        siteDoctorBacking.errorMessage=langBacking.getLiteral("invalid_selection");
    }
    
    //retrieve again updated emergency case and update current results
    siteDoctorBacking.setSelectedEmergencyCaseBean(siteDoctorBacking.getEmergencyCaseById(siteDoctorBacking.getSelectedEmergencyCaseBean().id));
    for(int i=0; i<siteDoctorBacking.emergenciesSearchResults.size(); i++)
    {
        EmergencyCaseBean curCase = siteDoctorBacking.emergenciesSearchResults.get(i);
        if(curCase.id.equals(siteDoctorBacking.getSelectedEmergencyCaseBean().id))
        {
            siteDoctorBacking.emergenciesSearchResults.remove(i);
            siteDoctorBacking.emergenciesSearchResults.add(i,siteDoctorBacking.getSelectedEmergencyCaseBean());
        }
    }
}
else
{
    siteDoctorBacking.errorMessage=langBacking.getLiteral("invalid_selection");
}



response.sendRedirect(returnToPage);

%>