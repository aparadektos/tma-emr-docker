

<%@page import="beans.PatientFileBean"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");

String returnToPage=request.getHeader("Referer");

String patFileHash=request.getParameter("patFileHash");

if(patFileHash!=null && patFileHash.trim().length()>0)
{
    PatientFileBean selectedPatFile = null;
    for(PatientFileBean curPatFile : paramedicBacking.getAllPatientFilesResults())
    {
        if(patFileHash.equals(curPatFile.hashCode()+""))
        {
            selectedPatFile=curPatFile;
            break;
        }
    }
    
    if(selectedPatFile!=null)
    {
        if(paramedicBacking.removeFileFromPatient(selectedPatFile)==true)
        {
            paramedicBacking.okMessage=langBacking.getLiteral("delete_ok");
            //update already retrieved files
            paramedicBacking.retrieveAllPatientFiles();
            response.sendRedirect(returnToPage);
        }
        else
        {
            paramedicBacking.errorMessage=langBacking.getLiteral("action_failed");
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        paramedicBacking.infoMessage=langBacking.getLiteral("invalid_file_selected");
        response.sendRedirect(returnToPage);
    }
}
else
{
    paramedicBacking.errorMessage=langBacking.getLiteral("invalid_selection");
    response.sendRedirect(returnToPage);
}


%>