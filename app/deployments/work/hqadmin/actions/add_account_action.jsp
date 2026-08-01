<%@page import="tools.GlobalHelper"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
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
String accUsername=fieldsMap.get("accUsername");//request.getParameter("accUsername");
String accPassword=fieldsMap.get("accPassword");//request.getParameter("accPassword");
String accRoleId=fieldsMap.get("accRoleId");//request.getParameter("accRoleId");
String accSiteId=fieldsMap.get("accSiteId");//request.getParameter("accSiteId");
String accActive=fieldsMap.get("accActive");//request.getParameter("accActive");
String accByPassAd=fieldsMap.get("accByPassAd");
String accName=fieldsMap.get("accName");//request.getParameter("accName");
String accSurname=fieldsMap.get("accSurname");//request.getParameter("accSurname");
String accEmail=fieldsMap.get("accEmail");//request.getParameter("accEmail");
String accMobilePhone=fieldsMap.get("accMobilePhone");//request.getParameter("accMobilePhone");
String accOtherInfo=fieldsMap.get("accOtherInfo");//request.getParameter("accOtherInfo");

accUsername=accUsername.replaceAll("\r\n", ", ");
accUsername=accUsername.replaceAll("'", "");


hqAdminBacking.newAccountBean = new accountBean();
hqAdminBacking.newAccountBean.RB=new roleBean(accRoleId, "");
hqAdminBacking.newAccountBean.name=accName;
hqAdminBacking.newAccountBean.surname=accSurname;
hqAdminBacking.newAccountBean.username=accUsername;
hqAdminBacking.newAccountBean.password=accPassword;
hqAdminBacking.newAccountBean.SB=new siteBean("-1", "", "", "");
hqAdminBacking.newAccountBean.mobilePhone=accMobilePhone;
hqAdminBacking.newAccountBean.email=accEmail;
hqAdminBacking.newAccountBean.otherInfo=accOtherInfo;
hqAdminBacking.newAccountBean.deleted="false";
hqAdminBacking.newAccountBean.active=accActive;
hqAdminBacking.newAccountBean.setPhotoBytes(filesMap.get("accPhoto").get());

//check if username exists.
if(hqAdminBacking.usernameExists(accUsername)==true)
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("username_exists");
    response.sendRedirect("../newAccount.jsp");
}
else
{
    //validate fields
    if(accUsername!=null && accUsername.length()>0 && accName!=null && accName.length()>0 && 
       accSurname!=null && accSurname.length()>0 && accRoleId!=null && accRoleId.length()>0)
    {
        boolean passOk=false;
        if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
        {
            hqAdminBacking.newAccountBean.setByPassAd("true");
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
            hqAdminBacking.newAccountBean.setByPassAd("false");
            hqAdminBacking.newAccountBean.password="1234567890";
            passOk=true;
        }
        
        boolean passPolicyOk=false;
        if(accPassword!=null && accPassword.length()>0)
        {
            if(GlobalHelper.checkPasswordPolicy(accPassword)==true)
            {
                //then password will change to new one
                hqAdminBacking.newAccountBean.password=accPassword;
                passPolicyOk=true;
            }
            else
            {
                passPolicyOk=false;
            }
        }
        else
        {
            //password is not even there
            passPolicyOk=false;
        }
        
        if(passOk)
        {
//            if(passPolicyOk==true)
//            {
                if(hqAdminBacking.insertNewAccount()==true)
                {
                    hqAdminBacking.newAccountBean=new accountBean();
                    hqAdminBacking.okMessage=langBacking.getLiteral("add_account_ok");
                    response.sendRedirect("../accounts.jsp");
                }
                else
                {
                    hqAdminBacking.errorMessage=langBacking.getLiteral("add_account_failed");
                    response.sendRedirect("../newAccount.jsp");
                }
//            }
//            else
//            {
//                hqAdminBacking.infoMessage=langBacking.getLiteral("pass_policy_info");
//                response.sendRedirect("../newAccount.jsp");
//            }
        }
        else
        {
            hqAdminBacking.infoMessage=langBacking.getLiteral("new_consultant_required_fields");
            response.sendRedirect("../newAccount.jsp");
        }
    }
    else
    {
        hqAdminBacking.infoMessage=langBacking.getLiteral("new_account_required_fields");
        response.sendRedirect("../newAccount.jsp");
    }
}
%>