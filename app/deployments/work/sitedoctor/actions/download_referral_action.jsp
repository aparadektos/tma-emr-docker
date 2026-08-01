

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

String referralId=request.getParameter("referralId");
if(referralId!=null && referralId.trim().length()>0)
{
    ReferralBean selectedReferralBean = null;
    for(ReferralBean curRef : siteDoctorBacking.selectedPatientToViewHistory.referralsList)
    {
        if(curRef.id.equals(referralId))
        {
            selectedReferralBean=curRef;
            break;
        }
    }
    
    if(selectedReferralBean!=null)
    {
        byte[] fileByteArray = siteDoctorBacking.downloadReferralFile(referralId);
        if(fileByteArray!=null && fileByteArray.length>0)
        {
            response.setCharacterEncoding("UTF-8");
            response.setContentType("application/octet-stream");
            String userAgent = request.getHeader("User-Agent");
            if(userAgent.indexOf("Firefox")>0 || userAgent.indexOf("firefox")>0)
            {
                response.setHeader("Content-Disposition","attachment;filename="+MimeUtility.encodeWord(selectedReferralBean.fileName));
            }
            else
            {
                response.setHeader("Content-Disposition","attachment;filename="+URLEncoder.encode(selectedReferralBean.fileName, "utf-8"));
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
            siteDoctorBacking.infoMessage="file not found in database";
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        siteDoctorBacking.errorMessage="file not found in selected patient list ";
        response.sendRedirect(returnToPage);
    }
}
else
{
    siteDoctorBacking.infoMessage="invalid file";
    response.sendRedirect(returnToPage);
}

%>