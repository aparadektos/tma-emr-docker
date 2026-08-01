<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="beans.ConsultantBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.StisBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.roleBean"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

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
String accActive=fieldsMap.get("accActive");//request.getParameter("accActive");
String accRoleId=fieldsMap.get("accRoleId");//request.getParameter("accRoleId");
String accByPassAd=fieldsMap.get("accByPassAd");
String accName=fieldsMap.get("accName");//request.getParameter("accName");
String accSurname=fieldsMap.get("accSurname");//request.getParameter("accSurname");
String consSpecialtyId=fieldsMap.get("consSpecialtyId");//request.getParameter("consSpecialtyId");
String consMitroo=fieldsMap.get("consMitroo");//request.getParameter("consMitroo");
String consMobilePhone=fieldsMap.get("consMobilePhone");//request.getParameter("consMobilePhone");
String consWorkPhone=fieldsMap.get("consWorkPhone");//request.getParameter("consWorkPhone");
String consHomePhone=fieldsMap.get("consHomePhone");//request.getParameter("consHomePhone");
String consAddress=fieldsMap.get("consAddress");//request.getParameter("consAddress");
String consEmail=fieldsMap.get("consEmail");//request.getParameter("consEmail");
String consShortCv=fieldsMap.get("consShortCv");
String consSipConference=fieldsMap.get("consSipConference");
String consSipMedical=fieldsMap.get("consSipMedical");
String consJabberAccount=fieldsMap.get("consJabberAccount");
ArrayList<StisBean> stisList = new ArrayList<StisBean>(0);
ArrayList<StisBean> allStisList=hqAdminBacking.getAllStis();
for(StisBean curStis : allStisList)
{
    String curStisSelected = fieldsMap.get("stis#"+curStis.getId());//request.getParameter("stis#"+curStis.getId());
    if(curStisSelected!=null && curStisSelected.length()>0)
    {
        stisList.add(curStis);
    }
}

hqAdminBacking.setNewConsultantBean(new ConsultantBean());
hqAdminBacking.getNewConsultantBean().setName(accName);
hqAdminBacking.getNewConsultantBean().setSurname(accSurname);
hqAdminBacking.getNewConsultantBean().setSpecialtyBean(new SpecialtyBean());
hqAdminBacking.getNewConsultantBean().getSpecialtyBean().setId(consSpecialtyId);
hqAdminBacking.getNewConsultantBean().setEmail(consEmail);
hqAdminBacking.getNewConsultantBean().setMobilePhone(consMobilePhone);
hqAdminBacking.getNewConsultantBean().setWorkphone(consWorkPhone);
hqAdminBacking.getNewConsultantBean().setHomephone(consHomePhone);
hqAdminBacking.getNewConsultantBean().setAddress(consAddress);
hqAdminBacking.getNewConsultantBean().setMitroo(consMitroo);
hqAdminBacking.getNewConsultantBean().setStisList(stisList);
hqAdminBacking.getNewConsultantBean().setShortCv(consShortCv);

hqAdminBacking.newAccountBean=new accountBean();
hqAdminBacking.newAccountBean.RB=new roleBean(accRoleId, "");
hqAdminBacking.newAccountBean.name=accName;
hqAdminBacking.newAccountBean.surname=accSurname;
hqAdminBacking.newAccountBean.username=accUsername;
hqAdminBacking.newAccountBean.password=accPassword;
hqAdminBacking.newAccountBean.deleted="false";
hqAdminBacking.newAccountBean.active=accActive;
hqAdminBacking.newAccountBean.consultantBean=hqAdminBacking.getNewConsultantBean();
hqAdminBacking.newAccountBean.email=consEmail;
hqAdminBacking.newAccountBean.setPhotoBytes(filesMap.get("accPhoto").get());
hqAdminBacking.newAccountBean.setSipConference(consSipConference);
hqAdminBacking.newAccountBean.setSipMedical(consSipMedical);
hqAdminBacking.newAccountBean.setJabberAccount(consJabberAccount);

//check if username exists.
if(hqAdminBacking.usernameExists(accUsername)==true)
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("username_exists");
    response.sendRedirect("../newConsultantAccount.jsp");
}
else
{
    //validate fields
    if(accUsername!=null && accUsername.length()>0 && 
       accActive!=null && accActive.length()>0 && accName!=null && accName.length()>0 && 
       accSurname!=null && accSurname.length()>0 && consSpecialtyId!=null && consSpecialtyId.length()>0)
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
        if(stisList.size()>0)
        {
            if(passOk)
            {
                //insert DB table
                if(hqAdminBacking.insertNewConsultantAccount()==true)
                {
                    //if success response OK 
                    hqAdminBacking.okMessage=langBacking.getLiteral("add_consultant_ok");
                    hqAdminBacking.newAccountBean=new accountBean();
                    hqAdminBacking.setNewConsultantBean(new ConsultantBean());
                    response.sendRedirect("../accounts.jsp");
                }
                else
                {
                    //if failed response ERROR 
                    hqAdminBacking.errorMessage=langBacking.getLiteral("add_consultant_failed");
                    response.sendRedirect("../newConsultantAccount.jsp");
                }
            }
            else
            {
                hqAdminBacking.infoMessage=langBacking.getLiteral("new_consultant_required_fields");
                response.sendRedirect("../newConsultantAccount.jsp");
            }
        }
        else
        {
            hqAdminBacking.infoMessage=langBacking.getLiteral("no_stis_selected");
            response.sendRedirect("../newConsultantAccount.jsp");
        }
    }
    else
    {
        hqAdminBacking.infoMessage=langBacking.getLiteral("new_consultant_required_fields");
        response.sendRedirect("../newConsultantAccount.jsp");
    }
}




        
%>