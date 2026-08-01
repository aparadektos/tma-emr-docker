<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.roleBean"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
HqAdminBacking hqAdminBacking = (HqAdminBacking)session.getAttribute("hqAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");
if(returnToPage==null || returnToPage.length()==0)
{
    returnToPage="../accounts.jsp";
}

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

//get new account fields
request.setCharacterEncoding("UTF-8");
String accPassword=fieldsMap.get("accPassword");//request.getParameter("accPassword");
String accSiteId=fieldsMap.get("accSiteId");//request.getParameter("accSiteId");
String accActive=fieldsMap.get("accActive");//request.getParameter("accActive");
String accName=fieldsMap.get("accName");//request.getParameter("accName");
String accSurname=fieldsMap.get("accSurname");//request.getParameter("accSurname");
String accEmail=fieldsMap.get("accEmail");//request.getParameter("accEmail");
String accMobilePhone=fieldsMap.get("accMobilePhone");//request.getParameter("accMobilePhone");
String accOtherInfo=fieldsMap.get("accOtherInfo");//request.getParameter("accOtherInfo");
String accByPassAd=fieldsMap.get("accByPassAd");

hqAdminBacking.getSelectedSiteAdminAccountToEdit().name=accName;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().surname=accSurname;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().password=accPassword;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().SB=new siteBean("-1", "", "", "");
hqAdminBacking.getSelectedSiteAdminAccountToEdit().SB.id=accSiteId;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().mobilePhone=accMobilePhone;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().email=accEmail;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().otherInfo=accOtherInfo;
hqAdminBacking.getSelectedSiteAdminAccountToEdit().active=accActive;
if(filesMap.get("accPhoto")!=null && filesMap.get("accPhoto").get().length>0)
{
    hqAdminBacking.getSelectedSiteAdminAccountToEdit().setPhotoBytes(filesMap.get("accPhoto").get());
}

//validate fields
if(accName!=null && accName.length()>0 && accSurname!=null && accSurname.length()>0 && accActive!=null && accActive.length()>0 &&
   accSiteId!=null && accSiteId.length()>0)
{
    boolean passOk=false;
    if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
    {
        hqAdminBacking.getSelectedSiteAdminAccountToEdit().setByPassAd("true");
        if(accPassword!=null && accPassword.length()>0)
        {
            passOk=true;
        }
        else
        {
            passOk=false;
        }
    }
    else
    {
        hqAdminBacking.getSelectedSiteAdminAccountToEdit().setByPassAd("false");
        hqAdminBacking.getSelectedSiteAdminAccountToEdit().password="1234567890";
        passOk=true;
    }
    
    if(passOk)
    {
        if(hqAdminBacking.updateSiteAdminAccount(hqAdminBacking.getSelectedSiteAdminAccountToEdit())==true)
        {
            hqAdminBacking.setSelectedSiteAdminAccountToEdit(new accountBean());
            hqAdminBacking.okMessage=langBacking.getLiteral("edit_account_ok");
            response.sendRedirect("../accounts.jsp");
        }
        else
        {
            hqAdminBacking.errorMessage=langBacking.getLiteral("edit_account_failed");
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        hqAdminBacking.infoMessage=langBacking.getLiteral("fill_required_fields");
        response.sendRedirect(returnToPage);
    }
}
else
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("fill_required_fields");
    response.sendRedirect(returnToPage);
}

%>