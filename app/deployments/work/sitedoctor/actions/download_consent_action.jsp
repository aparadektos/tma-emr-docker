

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
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

String returnToPage=request.getHeader("Referer");

if(siteDoctorBacking.selectedPatientToViewHistory!=null)
{
    byte[] fileByteArray = siteDoctorBacking.downloadConsentFile(siteDoctorBacking.selectedPatientToViewHistory.id);
    if(fileByteArray!=null && fileByteArray.length>0)
    {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/octet-stream");
        String userAgent = request.getHeader("User-Agent");
        String fileName = siteDoctorBacking.selectedPatientToViewHistory.surname+"_"+siteDoctorBacking.selectedPatientToViewHistory.name+"_"+siteDoctorBacking.selectedPatientToViewHistory.getDeclarationFileName();
        if(userAgent.indexOf("Firefox")>0 || userAgent.indexOf("firefox")>0)
        {
            response.setHeader("Content-Disposition","attachment;filename="+MimeUtility.encodeWord(fileName));
        }
        else
        {
            response.setHeader("Content-Disposition","attachment;filename="+URLEncoder.encode(fileName, "utf-8"));
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
        siteDoctorBacking.infoMessage=langBacking.getLiteral("file_not_found");
        response.sendRedirect(returnToPage);
    }
}
else
{
    siteDoctorBacking.errorMessage=langBacking.getLiteral("invalid_selection");
    response.sendRedirect(returnToPage);
}

%>