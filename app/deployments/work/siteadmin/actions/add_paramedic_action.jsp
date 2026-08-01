<%@page import="tools.GlobalHelper"%>
<%@page import="beans.ParamedicTypeBean"%>
<%@page import="beans.ParamedicBean"%>
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

String username=fieldsMap.get("username");//request.getParameter("docUsername");
String password=fieldsMap.get("password");//request.getParameter("docPassword");
String active=fieldsMap.get("active");//request.getParameter("docActive");
String byPassAd=fieldsMap.get("byPassAd");

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
byte[] photoBytes = filesMap.get("photo").get();
String shortCv = fieldsMap.get("shortCv");

//replace special chars
name=name.replaceAll("\r\n", ", ");
surname=surname.replaceAll("'", "\"");
email=email.replaceAll("\r\n", ", ");
workPhone=workPhone.replaceAll("'", "\"");
homePhone=homePhone.replaceAll("'", "\"");
department=department.replaceAll("\r\n", ", ");
address=address.replaceAll("'", "\"");

//check if username exists.
if(siteAdminBacking.usernameExists(username)==true)
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("username_exists");
    response.sendRedirect("../newParamedicAccount.jsp");
}
else
{
//validate fields
    if(username!=null && username.length()>0 && 
       active!=null && active.length()>0 && name!=null && name.length()>0 && 
       surname!=null && surname.length()>0 && paramTypeId!=null && paramTypeId.length()>0)
    {
        //create new paramedic bean
        ParamedicBean newParamedicBean = new ParamedicBean();
        newParamedicBean.setName(name);
        newParamedicBean.setSurname(surname);
        newParamedicBean.setAddress(address);
        newParamedicBean.setDepartment(department);
        newParamedicBean.setEmail(email);
        newParamedicBean.setHomephone(homePhone);
        newParamedicBean.setMitroo(mitroo);
        newParamedicBean.setMobilePhone(mobilePhone);
        newParamedicBean.getParamTypeBean().setId(paramTypeId);
        newParamedicBean.setSB(siteAdminBacking.AB.SB);
        newParamedicBean.setShortCv(shortCv);
        newParamedicBean.setWorkphone(workPhone);

        siteAdminBacking.newAccountBean=new accountBean();
        siteAdminBacking.newAccountBean.RB=new roleBean("9", "");
        siteAdminBacking.newAccountBean.name=name;
        siteAdminBacking.newAccountBean.surname=surname;
        siteAdminBacking.newAccountBean.username=username;
        siteAdminBacking.newAccountBean.deleted="false";
        siteAdminBacking.newAccountBean.active=active;
        siteAdminBacking.newAccountBean.setParamedicBean(newParamedicBean);
        siteAdminBacking.newAccountBean.setPhotoBytes(photoBytes);
        siteAdminBacking.newAccountBean.SB=siteAdminBacking.AB.SB;
        siteAdminBacking.newAccountBean.setSipConference(sipConference);
        siteAdminBacking.newAccountBean.setSipMedical(sipMedical);
        siteAdminBacking.newAccountBean.setJabberAccount(jabberAccount);
        
        boolean passPolicyOk=false;
        if(password!=null && password.length()>0)
        {
            if(GlobalHelper.checkPasswordPolicyMin(password)==true)
            {
                //then password will change to new one
                siteAdminBacking.newAccountBean.password=password;
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
        
        boolean adByPassOk=false;
        if(byPassAd!=null && byPassAd.equalsIgnoreCase("on"))
        {
            siteAdminBacking.newAccountBean.setByPassAd("true");
            if(password!=null && password.length()>0)
            {
                adByPassOk=true;
            }
            else
            {
                adByPassOk=false;
            }
        }
        else
        {
            siteAdminBacking.newAccountBean.setByPassAd("false");
            siteAdminBacking.newAccountBean.password="1234567890";
            adByPassOk=true;
        }

        if(adByPassOk)
        {
            if(passPolicyOk)
            {
                //insert new to DB table
                if(siteAdminBacking.insertNewParamedicAccount()==true)
                {
                    //if success response OK 
                    siteAdminBacking.okMessage=langBacking.getLiteral("add_paramedic_ok");
                    siteAdminBacking.newAccountBean=new accountBean();
                    response.sendRedirect("../localAccounts.jsp");
                }
                else
                {
                    //if failed response ERROR 
                    siteAdminBacking.errorMessage=langBacking.getLiteral("add_paramedic_failed");
                    response.sendRedirect("../newParamedicAccount.jsp");
                }
            }
            else
            {
                siteAdminBacking.infoMessage=langBacking.getLiteral("pass_policy_info_min");
                response.sendRedirect("../newParamedicAccount.jsp");
            }
        }
        else
        {
            siteAdminBacking.infoMessage=langBacking.getLiteral("new_paramedic_required_fields");
            response.sendRedirect("../newParamedicAccount.jsp");
        }
    }
    else
    {
        siteAdminBacking.infoMessage=langBacking.getLiteral("new_paramedic_required_fields");
        response.sendRedirect("../newParamedicAccount.jsp");
    }
}
%>