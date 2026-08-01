

<%@page import="backings.ConsultantBacking"%>
<%@page import="beans.EmergencyFileBean"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="javax.mail.internet.MimeUtility"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="beans.ReferralBean"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="backings.LanguageBacking"%>


<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");

String returnToPage=request.getHeader("Referer");

String erFileId=request.getParameter("erFileId");
String erCaseId=request.getParameter("erCaseId");
if(erFileId!=null && erFileId.trim().length()>0 && erCaseId!=null && erCaseId.trim().length()>0)
{
    EmergencyCaseBean selectedErCase = null;
    for(EmergencyCaseBean curErCase : consultantBacking.getSelectedPatientEmergenciesResults())
    {
        if(curErCase.id.equals(erCaseId))
        {
            selectedErCase=curErCase;
            break;
        }
    }
    
    if(selectedErCase!=null)
    {
        EmergencyFileBean selectedErFile = null;
        for(EmergencyFileBean curErFile : selectedErCase.getFileList())
        {
            if(curErFile.getId().equals(erFileId))
            {
                selectedErFile=curErFile;
                break;
            }
        }
        
        if(selectedErFile!=null)
        {
            byte[] fileByteArray = consultantBacking.downloadEmergencyFile(selectedErFile.getId());
            if(fileByteArray!=null && fileByteArray.length>0)
            {
                response.setContentType("application/octet-stream");
                response.setCharacterEncoding("UTF-8");
                String userAgent = request.getHeader("User-Agent");
                if(userAgent.indexOf("Firefox")>0 || userAgent.indexOf("firefox")>0)
                {
                    response.setHeader("Content-Disposition","attachment;filename="+MimeUtility.encodeWord(selectedErFile.getFileName()));
                }
                else
                {
                    response.setHeader("Content-Disposition","attachment;filename="+URLEncoder.encode(selectedErFile.getFileName(), "utf-8"));
                }            
                InputStream in = new ByteArrayInputStream(fileByteArray);
                ServletOutputStream out2 = response.getOutputStream();
                byte[] outputByte = new byte[20480];//20MB
                //copy binary contect to output stream
                while(in.read(outputByte, 0, 20480) != -1)
                {
                    out2.write(outputByte, 0, 20480);
                }
                in.close();
                out2.flush();
                out2.close();
            }
            else
            {
                consultantBacking.setInfoMessage(langBacking.getLiteral("file_not_found"));
                response.sendRedirect(returnToPage);
            }
        }
        else
        {
            consultantBacking.setErrorMessage(langBacking.getLiteral("invalid_file_selected"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        consultantBacking.setErrorMessage(langBacking.getLiteral("invalid_file_selected"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    consultantBacking.setInfoMessage(langBacking.getLiteral("invalid_file_selected"));
    response.sendRedirect(returnToPage);
}

%>