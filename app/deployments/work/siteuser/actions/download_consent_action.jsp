

<%@page import="backings.SiteUserBacking"%>
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
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

String returnToPage=request.getHeader("Referer");

if(siteUserBacking.selectedPatientToViewHistory!=null)
{
    byte[] fileByteArray = siteUserBacking.downloadConsentFile(siteUserBacking.selectedPatientToViewHistory.id);
    if(fileByteArray!=null && fileByteArray.length>0)
    {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/octet-stream");
        String userAgent = request.getHeader("User-Agent");
        String fileName = siteUserBacking.selectedPatientToViewHistory.surname+"_"+siteUserBacking.selectedPatientToViewHistory.name+"_"+siteUserBacking.selectedPatientToViewHistory.getDeclarationFileName();
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
        siteUserBacking.infoMessage=langBacking.getLiteral("file_not_found");
        response.sendRedirect(returnToPage);
    }
}
else
{
    siteUserBacking.errorMessage=langBacking.getLiteral("invalid_selection");
    response.sendRedirect(returnToPage);
}

%>