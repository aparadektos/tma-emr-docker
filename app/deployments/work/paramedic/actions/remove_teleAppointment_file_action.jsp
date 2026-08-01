
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.ParamedicBacking"%>
<%
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");

//retrieve form data
String fileHash = request.getParameter("fileHash");
if(fileHash!=null && fileHash.length()>0)
{
    try
    {
        FileItem selectedFileItem=null;
        for(FileItem curFileItem : paramedicBacking.getNewTeleappointment().getFileItems())
        {
            if(curFileItem.hashCode()==Integer.parseInt(fileHash))
            {
                selectedFileItem=curFileItem;
                break;
            }
        }
        if(selectedFileItem!=null)
        {
            paramedicBacking.getNewTeleappointment().getFileItems().remove(selectedFileItem);
            paramedicBacking.okMessage=langBacking.getLiteral("remove_tele_appointment_file_ok");
        }
        else
        {
            paramedicBacking.infoMessage=langBacking.getLiteral("invalid_tele_appointment_file");
        }
    }
    catch(Exception e)
    {
        e.printStackTrace();
        paramedicBacking.errorMessage=langBacking.getLiteral("remove_tele_appointment_file_failed");
    }
}

response.sendRedirect(returnToPage);

%>