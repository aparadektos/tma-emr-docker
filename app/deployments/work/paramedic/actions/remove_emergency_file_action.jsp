

<%@page import="beans.EmergencyCaseBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");

//String returnToPage=request.getHeader("Referer");
String returnToPage="../popupNewEmergencyFile.jsp";

String erFileId=request.getParameter("erFileId");

if(paramedicBacking.getSelectedEmergencyCaseBean()!=null)
{
    if(erFileId!=null && erFileId.length()>0)
    {
        if(paramedicBacking.removeEmergencyFileFromCase(paramedicBacking.getSelectedEmergencyCaseBean(), erFileId)==true)
        {

        }
        else
        {
            paramedicBacking.errorMessage=langBacking.getLiteral("update_emergency_files_failed");
        }
    }
    else
    {
        paramedicBacking.errorMessage=langBacking.getLiteral("invalid_selection");
    }
    
    //retrieve again updated emergency case and update current results
    paramedicBacking.setSelectedEmergencyCaseBean(paramedicBacking.getEmergencyCaseById(paramedicBacking.getSelectedEmergencyCaseBean().id));
    for(int i=0; i<paramedicBacking.emergenciesSearchResults.size(); i++)
    {
        EmergencyCaseBean curCase = paramedicBacking.emergenciesSearchResults.get(i);
        if(curCase.id.equals(paramedicBacking.getSelectedEmergencyCaseBean().id))
        {
            paramedicBacking.emergenciesSearchResults.remove(i);
            paramedicBacking.emergenciesSearchResults.add(i,paramedicBacking.getSelectedEmergencyCaseBean());
        }
    }
}
else
{
    paramedicBacking.errorMessage=langBacking.getLiteral("invalid_selection");
}



response.sendRedirect(returnToPage);

%>