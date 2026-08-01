

<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="beans.PatientFileBean"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

String returnToPage=request.getHeader("Referer");

String patFileHash=request.getParameter("patFileHash");

if(patFileHash!=null && patFileHash.trim().length()>0)
{
    PatientFileBean selectedPatFile = null;
    for(PatientFileBean curPatFile : siteDoctorBacking.getAllPatientFilesResults())
    {
        if(patFileHash.equals(curPatFile.hashCode()+""))
        {
            selectedPatFile=curPatFile;
            break;
        }
    }
    
    if(selectedPatFile!=null)
    {
        if(siteDoctorBacking.removeFileFromPatient(selectedPatFile)==true)
        {
            siteDoctorBacking.setOkMessage(langBacking.getLiteral("delete_ok"));
            //update already retrieved files
            siteDoctorBacking.retrieveAllPatientFiles();
            response.sendRedirect(returnToPage);
        }
        else
        {
            siteDoctorBacking.setErrorMessage(langBacking.getLiteral("action_failed"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        siteDoctorBacking.setInfoMessage(langBacking.getLiteral("invalid_file_selected"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    siteDoctorBacking.setErrorMessage(langBacking.getLiteral("invalid_selection"));
    response.sendRedirect(returnToPage);
}


%>