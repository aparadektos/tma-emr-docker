<%@page import="tools.GlobalHelper"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.roleBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
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

//get new site fields
String accPassword=fieldsMap.get("accPassword");//request.getParameter("docPassword");
String accActive=fieldsMap.get("accActive");//request.getParameter("docActive");
String accByPassAd=fieldsMap.get("accByPassAd");

String name=fieldsMap.get("name");//request.getParameter("docName");
String surname=fieldsMap.get("surname");//request.getParameter("docSurname");

String paramTypeId=fieldsMap.get("paramTypeId");//request.getParameter("docSpecialtyId");
String mitroo=fieldsMap.get("mitroo");//request.getParameter("docMitroo");

String sipConference=fieldsMap.get("sipConference");
String sipMedical=fieldsMap.get("sipMedical");
String jabberAccount=fieldsMap.get("jabberAccount");
String mobilePhone=fieldsMap.get("mobilePhone");//request.getParameter("docMobilePhone");
String workPhone=fieldsMap.get("workPhone");//request.getParameter("docWorkPhone");
String homePhone=fieldsMap.get("homePhone");//request.getParameter("docHomePhone");
String address=fieldsMap.get("address");//request.getParameter("docAddress");
String email=fieldsMap.get("email");//request.getParameter("docEmail");
String department=fieldsMap.get("department");//request.getParameter("docDepart");
byte[] photoBytes = null;
if(filesMap.get("accPhoto")!=null && filesMap.get("accPhoto").get().length>0)
{
    photoBytes=filesMap.get("accPhoto").get();
}
String shortCv = fieldsMap.get("shortCv");

//replace special chars
name=name.replaceAll("\r\n", ", ");
surname=surname.replaceAll("'", "\"");
email=email.replaceAll("\r\n", ", ");
workPhone=workPhone.replaceAll("'", "\"");
homePhone=homePhone.replaceAll("'", "\"");
department=department.replaceAll("\r\n", ", ");
address=address.replaceAll("'", "\"");

//validate fields
if(accActive!=null && accActive.length()>0 && name!=null && name.length()>0 && 
   surname!=null && surname.length()>0 && paramTypeId!=null && paramTypeId.length()>0 &&
   siteAdminBacking.accountToEdit!=null && siteAdminBacking.accountToEdit.getParamedicBean()!=null )
{
    siteAdminBacking.accountToEdit.getParamedicBean().setName(name);
    siteAdminBacking.accountToEdit.getParamedicBean().setSurname(surname);
    siteAdminBacking.accountToEdit.getParamedicBean().getParamTypeBean().setId(paramTypeId);
    siteAdminBacking.accountToEdit.getParamedicBean().setMitroo(mitroo);
    siteAdminBacking.accountToEdit.getParamedicBean().setEmail(email);
    siteAdminBacking.accountToEdit.getParamedicBean().setMobilePhone(mobilePhone);
    siteAdminBacking.accountToEdit.getParamedicBean().setWorkphone(workPhone);
    siteAdminBacking.accountToEdit.getParamedicBean().setHomephone(homePhone);
    siteAdminBacking.accountToEdit.getParamedicBean().setAddress(address);
    siteAdminBacking.accountToEdit.getParamedicBean().setDepartment(department);
    siteAdminBacking.accountToEdit.setSipConference(sipConference);
    siteAdminBacking.accountToEdit.setSipMedical(sipMedical);
    siteAdminBacking.accountToEdit.setJabberAccount(jabberAccount);
    
    siteAdminBacking.accountToEdit.name=name;
    siteAdminBacking.accountToEdit.surname=surname;
    
    siteAdminBacking.accountToEdit.deleted="false";
    siteAdminBacking.accountToEdit.active=accActive;
    
    if(photoBytes!=null)
    {
        siteAdminBacking.accountToEdit.setPhotoBytes(photoBytes);
    }
    siteAdminBacking.accountToEdit.getParamedicBean().setShortCv(shortCv);
    
    boolean passPolicyOk=false;
    if(accPassword!=null && accPassword.length()>0)
    {
        if(GlobalHelper.checkPasswordPolicyMin(accPassword)==true)
        {
            //then password will change to new one
            siteAdminBacking.accountToEdit.password=accPassword;
            passPolicyOk=true;
        }
        else
        {
            passPolicyOk=false;
        }
    }
    else
    {
        //password will remain the same
        siteAdminBacking.accountToEdit.password="OLD";
        passPolicyOk=true;
    }
    
    boolean adByPassOk=false;
    if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
    {
        siteAdminBacking.accountToEdit.setByPassAd("true");
        adByPassOk=true;
        //o parakatw elegxos prepei na ginetai mono sto add new account giati sto edit den ypoxrewtiko na balei o admin to pass tou xristi.
//        if(accPassword!=null && accPassword.length()>0)
//        {
//            passOk=true;
//        }
//        else
//        {
//            passOk=false;
//        }
    }
    else
    {
        //exei tsekarei na min ginei bypass to AD
        siteAdminBacking.accountToEdit.setByPassAd("false");
        adByPassOk=true;
    }
    
    if(adByPassOk)
    {
        if(passPolicyOk)
        {
            if(siteAdminBacking.editParamedicAccount()==true)
            {
                //if success response OK 
                siteAdminBacking.okMessage=langBacking.getLiteral("edit_account_ok");
                siteAdminBacking.accountToEdit=new accountBean();
                response.sendRedirect("../localAccounts.jsp");
            }
            else
            {
                //if failed response ERROR 
                siteAdminBacking.errorMessage=langBacking.getLiteral("edit_account_failed");
                response.sendRedirect("../editParamedicAccount.jsp");
            }
        }
        else
        {
            siteAdminBacking.infoMessage=langBacking.getLiteral("pass_policy_info_min");
            response.sendRedirect("../editParamedicAccount.jsp");
        }
    }
    else
    {
        siteAdminBacking.infoMessage=langBacking.getLiteral("edit_paramedic_required_fields");
        response.sendRedirect("../editParamedicAccount.jsp");
    }
}
else
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("edit_paramedic_required_fields");
    response.sendRedirect("../editParamedicAccount.jsp");
}
%>