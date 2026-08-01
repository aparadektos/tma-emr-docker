

<%@page import="backings.SiteDoctorBacking"%>
<%@page import="beans.PatientFileBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="beans.TeleAppointmentFileBean"%>
<%@page import="backings.ConsultantBacking"%>
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
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

String returnToPage=request.getHeader("Referer");

String patFileId=request.getParameter("patFileId");
if(patFileId!=null && patFileId.trim().length()>0)
{
    PatientFileBean selectedPatFile = null;
    for(PatientFileBean curPatFile : siteDoctorBacking.getAllPatientFilesResults())
    {
        if(curPatFile.getId().equals(patFileId))
        {
            selectedPatFile=curPatFile;
            break;
        }
    }
    
    if(selectedPatFile!=null)
    {
        byte[] fileByteArray = siteDoctorBacking.downloadPatientFileById(patFileId);
        if(fileByteArray!=null && fileByteArray.length>0)
        {
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/octet-stream");
            String userAgent = request.getHeader("User-Agent");
            if(userAgent.indexOf("Firefox")>0 || userAgent.indexOf("firefox")>0)
            {
                //response.setHeader("Content-Disposition","attachment;filename="+MimeUtility.encodeWord(selectedFile.getFileName()));
                response.addHeader("Content-Disposition", "attachment; filename*='UTF-8'" + URLEncoder.encode(selectedPatFile.getFileName(), "UTF-8"));
            }
            else
            {
                response.setHeader("Content-Disposition","attachment;filename="+URLEncoder.encode(selectedPatFile.getFileName(), "utf-8"));
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
            siteDoctorBacking.setErrorMessage(langBacking.getLiteral("invalid_file_selected"));
            //retrieve again patients' files and update results
            siteDoctorBacking.retrieveAllPatientFiles();
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
    siteDoctorBacking.setInfoMessage(langBacking.getLiteral("invalid_file_selected"));
    response.sendRedirect(returnToPage);
}

%>