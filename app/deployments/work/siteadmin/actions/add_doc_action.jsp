<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.util.List"%>
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

String docUsername=fieldsMap.get("docUsername");//request.getParameter("docUsername");
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
byte[] photoBytes = filesMap.get("accPhoto").get();
String docShortCv = fieldsMap.get("docShortCv");

//replace special chars
docName=docName.replaceAll("\r\n", ", ");
docSurname=docSurname.replaceAll("'", "\"");
docEmail=docEmail.replaceAll("\r\n", ", ");
docWorkPhone=docWorkPhone.replaceAll("'", "\"");
docHomePhone=docHomePhone.replaceAll("'", "\"");
docDepart=docDepart.replaceAll("\r\n", ", ");
docAddress=docAddress.replaceAll("'", "\"");

//check if username exists.
if(siteAdminBacking.usernameExists(docUsername)==true)
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("username_exists");
    response.sendRedirect("../newSiteDoctorAccount.jsp");
}
else
{
//validate fields
    if(docUsername!=null && docUsername.length()>0 && 
       docActive!=null && docActive.length()>0 && docName!=null && docName.length()>0 && 
       docSurname!=null && docSurname.length()>0 && docSpecialtyId!=null && docSpecialtyId.length()>0)
    {
        //create new doctor bean
        DoctorBean docBean=new DoctorBean("", docName, docSurname, null, docEmail, docWorkPhone, docHomePhone, docAddress, docDepart, null);
        docBean.name=docName;
        docBean.surname=docSurname;
        docBean.specialtyBean=new SpecialtyBean();
        docBean.specialtyBean.id=docSpecialtyId;
        docBean.email=docEmail;
        docBean.mobilePhone=docMobilePhone;
        docBean.workphone=docWorkPhone;
        docBean.homephone=docHomePhone;
        docBean.address=docAddress;
        docBean.department=docDepart;
        docBean.mitroo=docMitroo;
        docBean.setShortCv(docShortCv);

        siteAdminBacking.newAccountBean=new accountBean();
        siteAdminBacking.newAccountBean.RB=new roleBean("5", "");
        siteAdminBacking.newAccountBean.name=docName;
        siteAdminBacking.newAccountBean.surname=docSurname;
        siteAdminBacking.newAccountBean.username=docUsername;
        siteAdminBacking.newAccountBean.password=accPassword;
        siteAdminBacking.newAccountBean.deleted="false";
        siteAdminBacking.newAccountBean.active=docActive;
        siteAdminBacking.newAccountBean.docBean=docBean;
        siteAdminBacking.newAccountBean.setPhotoBytes(photoBytes);
        siteAdminBacking.newAccountBean.setSipConference(docSipConference);
        siteAdminBacking.newAccountBean.setSipMedical(docSipMedical);
        siteAdminBacking.newAccountBean.setJabberAccount(docJabberAccount);
        
        boolean passOk=false;
        if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
        {
            siteAdminBacking.newAccountBean.setByPassAd("true");
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
            siteAdminBacking.newAccountBean.setByPassAd("false");
            siteAdminBacking.newAccountBean.password="1234567890";
            passOk=true;
        }

        if(passOk)
        {
            //insert new doctor to DB table
            if(siteAdminBacking.insertNewDoctorAccount()==true)
            {
                //if success response OK 
                siteAdminBacking.okMessage=langBacking.getLiteral("add_doctor_ok");
                siteAdminBacking.newAccountBean=new accountBean();
                response.sendRedirect("../localAccounts.jsp");
            }
            else
            {
                //if failed response ERROR 
                siteAdminBacking.errorMessage=langBacking.getLiteral("add_doctor_failed");
                response.sendRedirect("../newSiteDoctorAccount.jsp");
            }
        }
        else
        {
            siteAdminBacking.infoMessage=langBacking.getLiteral("new_doctor_required_fields");
            response.sendRedirect("../newSiteDoctorAccount.jsp");
        }
    }
    else
    {
        siteAdminBacking.infoMessage=langBacking.getLiteral("new_doctor_required_fields");
        response.sendRedirect("../newSiteDoctorAccount.jsp");
    }
}
%>