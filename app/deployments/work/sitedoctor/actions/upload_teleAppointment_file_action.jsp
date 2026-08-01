

<%@page import="tools.GlobalHelper"%>
<%@page import="java.util.ArrayList"%>
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

HashMap<String, String> fieldsMap=new HashMap<String, String>();
HashMap<String, FileItem> filesMap=new HashMap<String, FileItem>();

ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
servletFileUpload.setHeaderEncoding("UTF-8");
List<FileItem> items = servletFileUpload.parseRequest(request);
for (FileItem item : items) 
{
    if (item.isFormField()) 
    {
        // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
        String fieldname = item.getFieldName();
        String fieldvalue = item.getString("UTF-8");
        fieldsMap.put(fieldname, fieldvalue);
    } 
    else 
    {
        // Process form file field (input type="file").
        String fieldname = item.getFieldName();
        String filename = FilenameUtils.getName(item.getName());
        filesMap.put(fieldname,item);
    }
}

FileItem uploadedFile = filesMap.get("teleAppointmentFile");
if(uploadedFile!=null && uploadedFile.get().length>0 && uploadedFile.getContentType().length()>0)
{
    if(siteDoctorBacking.getNewTeleappointment()==null)
    {
        siteDoctorBacking.getNewTeleappointment().setFileItems(new ArrayList<FileItem>(0));
    }
    //check if content type is valid
    if(GlobalHelper.fileIsValid(uploadedFile.getContentType(), uploadedFile.getName())==true)
    {
        siteDoctorBacking.getNewTeleappointment().getFileItems().add(uploadedFile);
        siteDoctorBacking.okMessage=langBacking.getLiteral("file_added_ok");
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_file_selected");
    }
}
else
{
    siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_file_selected");
}

response.sendRedirect(returnToPage);

%>