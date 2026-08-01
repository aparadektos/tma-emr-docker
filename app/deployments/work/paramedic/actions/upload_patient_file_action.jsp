
<%@page import="tools.GlobalHelper"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.PatientFileBean"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.EmergencyFileBean"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");

String returnToPage=request.getHeader("Referer");
//String returnToPage="../popupNewEmergencyFile.jsp";

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


FileItem patFile = filesMap.get("patFile"); 
String comments=fieldsMap.get("comments");

if(patFile!=null && patFile.get().length>0 && patFile.getContentType().length()>0)
{
    if(GlobalHelper.fileIsValid(patFile.getContentType(), patFile.getName())==true)
    {
        PatientFileBean newPatFile = new PatientFileBean();
        newPatFile.setAB(paramedicBacking.getAB());
        newPatFile.setComments(comments);
        newPatFile.setDateTime(new Timestamp(new Date().getTime()));
        newPatFile.setFileItem(patFile);
        newPatFile.setFileName(patFile.getName());
        newPatFile.setPatientId(paramedicBacking.selectedPatientToViewHistory.id);
        newPatFile.setUploadSiteBean(paramedicBacking.getAB().getParamedicBean().getSB());

        //update to db
        if(paramedicBacking.insertFileToPatient(newPatFile)==true)
        {
            paramedicBacking.okMessage=langBacking.getLiteral("file_added_ok");
            //retrieve again patients' files and update results
            paramedicBacking.retrieveAllPatientFiles();
        }
        else
        {
            paramedicBacking.errorMessage=langBacking.getLiteral("action_failed");
        }
    }
    else
    {
        paramedicBacking.infoMessage=langBacking.getLiteral("invalid_file_selected");
    }
}
else
{
    paramedicBacking.errorMessage=langBacking.getLiteral("invalid_file_selected");
}


response.sendRedirect(returnToPage);

%>