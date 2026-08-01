<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.roleBean"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="beans.DoctorBean"%>
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
String docActive=fieldsMap.get("docActive");//request.getParameter("docActive");
String accByPassAd=fieldsMap.get("accByPassAd");

String docName=fieldsMap.get("docName");//request.getParameter("docName");
String docSurname=fieldsMap.get("docSurname");//request.getParameter("docSurname");

String docSpecialtyId=fieldsMap.get("docSpecialtyId");//request.getParameter("docSpecialtyId");
String docMitroo=fieldsMap.get("docMitroo");//request.getParameter("docMitroo");

String docSipConference=fieldsMap.get("docSipConference");
String docSipMedical=fieldsMap.get("docSipMedical");
String docJabberAccount=fieldsMap.get("docJabberAccount");
String docMobilePhone=fieldsMap.get("docMobilePhone");//request.getParameter("docMobilePhone");
String docWorkPhone=fieldsMap.get("docWorkPhone");//request.getParameter("docWorkPhone");
String docHomePhone=fieldsMap.get("docHomePhone");//request.getParameter("docHomePhone");
String docAddress=fieldsMap.get("docAddress");//request.getParameter("docAddress");
String docEmail=fieldsMap.get("docEmail");//request.getParameter("docEmail");
String docDepart=fieldsMap.get("docDepart");//request.getParameter("docDepart");
byte[] photoBytes = null;
if(filesMap.get("accPhoto")!=null && filesMap.get("accPhoto").get().length>0)
{
    photoBytes=filesMap.get("accPhoto").get();
}
String docShortCv = fieldsMap.get("docShortCv");

//replace special chars
docName=docName.replaceAll("\r\n", ", ");
docSurname=docSurname.replaceAll("'", "\"");
docEmail=docEmail.replaceAll("\r\n", ", ");
docWorkPhone=docWorkPhone.replaceAll("'", "\"");
docHomePhone=docHomePhone.replaceAll("'", "\"");
docDepart=docDepart.replaceAll("\r\n", ", ");
docAddress=docAddress.replaceAll("'", "\"");

//validate fields
if(docActive!=null && docActive.length()>0 && docName!=null && docName.length()>0 && 
   docSurname!=null && docSurname.length()>0 && docSpecialtyId!=null && docSpecialtyId.length()>0)
{
    siteAdminBacking.accountToEdit.docBean.name=docName;
    siteAdminBacking.accountToEdit.docBean.surname=docSurname;
    siteAdminBacking.accountToEdit.docBean.specialtyBean=new SpecialtyBean();
    siteAdminBacking.accountToEdit.docBean.specialtyBean.id=docSpecialtyId;
    siteAdminBacking.accountToEdit.docBean.mitroo=docMitroo;
    siteAdminBacking.accountToEdit.docBean.email=docEmail;
    siteAdminBacking.accountToEdit.setSipConference(docSipConference);
    siteAdminBacking.accountToEdit.setSipMedical(docSipMedical);
    siteAdminBacking.accountToEdit.setJabberAccount(docJabberAccount);
    siteAdminBacking.accountToEdit.docBean.mobilePhone=docMobilePhone;
    siteAdminBacking.accountToEdit.docBean.workphone=docWorkPhone;
    siteAdminBacking.accountToEdit.docBean.homephone=docHomePhone;
    siteAdminBacking.accountToEdit.docBean.address=docAddress;
    siteAdminBacking.accountToEdit.docBean.department=docDepart;
    
    siteAdminBacking.accountToEdit.name=docName;
    siteAdminBacking.accountToEdit.surname=docSurname;
    if(accPassword!=null && accPassword.length()>2)
    {
        siteAdminBacking.accountToEdit.password=accPassword;
    }
    siteAdminBacking.accountToEdit.deleted="false";
    siteAdminBacking.accountToEdit.active=docActive;
    
    if(photoBytes!=null)
    {
        siteAdminBacking.accountToEdit.setPhotoBytes(photoBytes);
    }
    siteAdminBacking.accountToEdit.docBean.setShortCv(docShortCv);
    
    boolean passOk=false;
    if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
    {
        siteAdminBacking.accountToEdit.setByPassAd("true");
        if(accPassword!=null && accPassword.length()>0)
        {
            siteAdminBacking.accountToEdit.password=accPassword;
        }
        else
        {
            siteAdminBacking.accountToEdit.password="OLD";
        }
        passOk=true;
    }
    else
    {
        siteAdminBacking.accountToEdit.setByPassAd("false");
        siteAdminBacking.accountToEdit.password="1234567890";
        passOk=true;
    }
    
    if(passOk)
    {
        //insert new doctor to DB table
        if(siteAdminBacking.editDoctorAccount()==true)
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
            response.sendRedirect("../editSiteDoctorAccount.jsp");
        }
    }
    else
    {
        siteAdminBacking.infoMessage=langBacking.getLiteral("edit_doctor_required_fields");
        response.sendRedirect("../editSiteDoctorAccount.jsp");
    }
}
else
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("edit_doctor_required_fields");
    response.sendRedirect("../editSiteDoctorAccount.jsp");
}
%>