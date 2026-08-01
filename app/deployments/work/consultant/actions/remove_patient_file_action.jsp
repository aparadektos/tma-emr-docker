

<%@page import="backings.ConsultantBacking"%>
<%@page import="beans.PatientFileBean"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");

String returnToPage=request.getHeader("Referer");

String patFileHash=request.getParameter("patFileHash");

if(patFileHash!=null && patFileHash.trim().length()>0)
{
    PatientFileBean selectedPatFile = null;
    for(PatientFileBean curPatFile : consultantBacking.getAllPatientFilesResults())
    {
        if(patFileHash.equals(curPatFile.hashCode()+""))
        {
            selectedPatFile=curPatFile;
            break;
        }
    }
    
    if(selectedPatFile!=null)
    {
        if(consultantBacking.removeFileFromPatient(selectedPatFile)==true)
        {
            consultantBacking.setOkMessage(langBacking.getLiteral("delete_ok"));
            //update already retrieved files
            consultantBacking.retrieveAllPatientFiles();
            response.sendRedirect(returnToPage);
        }
        else
        {
            consultantBacking.setErrorMessage(langBacking.getLiteral("action_failed"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        consultantBacking.setInfoMessage(langBacking.getLiteral("invalid_file_selected"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    consultantBacking.setErrorMessage(langBacking.getLiteral("invalid_selection"));
    response.sendRedirect(returnToPage);
}


%>