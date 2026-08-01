
<%@page import="tools.GlobalHelper"%>
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

//String returnToPage=request.getHeader("Referer");
String returnToPage="../popupNewEmergencyFile.jsp";

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

if(paramedicBacking.getSelectedEmergencyCaseBean()!=null)
{
    ArrayList<EmergencyFileBean> newFilesList = new ArrayList<EmergencyFileBean>(0);
    
    for(int i=1; i<=4; i++)
    {
        FileItem uploadedFile = filesMap.get("emergencyFile"+i);
        if(uploadedFile!=null && uploadedFile.get().length>0 && uploadedFile.getContentType().length()>0)
        {
            //check if content type is valid
            if(GlobalHelper.fileIsValid(uploadedFile.getContentType(), uploadedFile.getName())==true)
            {
                EmergencyFileBean curErFile = new EmergencyFileBean();
                curErFile.setEmergencyCaseId(paramedicBacking.getSelectedEmergencyCaseBean().id);
                curErFile.setFileItem(uploadedFile);
                curErFile.setFileName(uploadedFile.getName());
                curErFile.setContentType(uploadedFile.getContentType());
                newFilesList.add(curErFile);
            }
            else
            {
                paramedicBacking.infoMessage=langBacking.getLiteral("uploading_some_files_failed");
            }
        }
    }
    
    //update to db
    if(paramedicBacking.insertEmergencyFilesToCase(paramedicBacking.getSelectedEmergencyCaseBean(), newFilesList)==true)
    {
        
    }
    else
    {
        paramedicBacking.errorMessage=langBacking.getLiteral("update_emergency_files_failed");
    }
    
    //retrieve again updated emergency case and update current results
    paramedicBacking.setSelectedEmergencyCaseBean(paramedicBacking.getEmergencyCaseById(paramedicBacking.getSelectedEmergencyCaseBean().id));
    for(int i=0; i<paramedicBacking.emergenciesSearchResults.size(); i++)
    {
        EmergencyCaseBean curCase = paramedicBacking.emergenciesSearchResults.get(i);
        if(curCase.id.equals(paramedicBacking.getSelectedEmergencyCaseBean().id))
        {
            paramedicBacking.emergenciesSearchResults.remove(i);
            paramedicBacking.emergenciesSearchResults.add(i,paramedicBacking.getSelectedEmergencyCaseBean());
        }
    }
}
else
{
    paramedicBacking.errorMessage=langBacking.getLiteral("invalid_selection");
}



response.sendRedirect(returnToPage);

%>