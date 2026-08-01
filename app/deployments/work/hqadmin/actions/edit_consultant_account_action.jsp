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
String accActive=fieldsMap.get("accActive");//request.getParameter("accActive");
String accName=fieldsMap.get("accName");//request.getParameter("accName");
String accSurname=fieldsMap.get("accSurname");//request.getParameter("accSurname");
String accByPassAd=fieldsMap.get("accByPassAd");
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

hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setName(accName);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setSurname(accSurname);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setSpecialtyBean(new SpecialtyBean());
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getSpecialtyBean().setId(consSpecialtyId);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setEmail(consEmail);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setMobilePhone(consMobilePhone);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setWorkphone(consWorkPhone);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setHomephone(consHomePhone);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setAddress(consAddress);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setMitroo(consMitroo);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setStisList(stisList);
hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.setShortCv(consShortCv);

hqAdminBacking.getSelectedConsultantAccountToEdit().name=accName;
hqAdminBacking.getSelectedConsultantAccountToEdit().surname=accSurname;
hqAdminBacking.getSelectedConsultantAccountToEdit().active=accActive;
if(filesMap.get("accPhoto")!=null && filesMap.get("accPhoto").get().length>0)
{
    hqAdminBacking.getSelectedConsultantAccountToEdit().setPhotoBytes(filesMap.get("accPhoto").get());
}
hqAdminBacking.getSelectedConsultantAccountToEdit().setSipConference(consSipConference);
hqAdminBacking.getSelectedConsultantAccountToEdit().setSipMedical(consSipMedical);
hqAdminBacking.getSelectedConsultantAccountToEdit().setJabberAccount(consJabberAccount);

//validate fields
if(accActive!=null && accActive.length()>0 && accName!=null && accName.length()>0 && consMitroo!=null && consMitroo.length()>0 &&
   accSurname!=null && accSurname.length()>0 && consSpecialtyId!=null && consSpecialtyId.length()>0)
{
    boolean passOk=false;
    if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
    {
        hqAdminBacking.getSelectedConsultantAccountToEdit().setByPassAd("true");
        if(accPassword!=null && accPassword.length()>0)
        {
            hqAdminBacking.getSelectedConsultantAccountToEdit().password=accPassword;
        }
        else
        {
            hqAdminBacking.getSelectedConsultantAccountToEdit().password="OLD";
        }
        passOk=true;
    }
    else
    {
        hqAdminBacking.getSelectedConsultantAccountToEdit().setByPassAd("false");
        hqAdminBacking.getSelectedConsultantAccountToEdit().password="1234567890";
        passOk=true;
    }
    if(stisList.size()>0)
    {
        if(passOk)
        {
            //insert DB table
            if(hqAdminBacking.updateConsultantAccount(hqAdminBacking.getSelectedConsultantAccountToEdit())==true)
            {
                //if success response OK 
                hqAdminBacking.okMessage=langBacking.getLiteral("edit_consultant_ok");
                hqAdminBacking.setSelectedConsultantAccountToEdit(new accountBean());
                response.sendRedirect("../accounts.jsp");
            }
            else
            {
                //if failed response ERROR 
                hqAdminBacking.errorMessage=langBacking.getLiteral("action_failed");
                response.sendRedirect(returnToPage);
            }
        }
        else
        {
            hqAdminBacking.infoMessage=langBacking.getLiteral("edit_consultant_required_fields");
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        hqAdminBacking.infoMessage=langBacking.getLiteral("no_stis_selected");
        response.sendRedirect(returnToPage);
    }
}
else
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("edit_consultant_required_fields");
    response.sendRedirect(returnToPage);
}

%>