<%@page import="beans.StisBean"%>
<%@page import="backings.LanguageBacking"%>
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
    returnToPage="../editStis.jsp";
}
    
//get new site fields
request.setCharacterEncoding("UTF-8");
String stisTitle=request.getParameter("stisTitle");
String stisHospital=request.getParameter("stisHospital");
String stisIpAddress=request.getParameter("stisIpAddress");
String stisComments=request.getParameter("stisComments");
String stisHospitalFullTitle=request.getParameter("stisHospitalFullTitle");
String stisHospitalPhones=request.getParameter("stisHospitalPhones");
String stisHospitalEmails=request.getParameter("stisHospitalEmails");
String stisHospitalAddress=request.getParameter("stisHospitalAddress");

//check for special characters like  ' -> &#39;
stisTitle=stisTitle.replaceAll("'", "&#39;");
stisTitle=stisTitle.replaceAll("\"", "&#39;");
stisHospital=stisHospital.replaceAll("'", "&#39;");
stisHospital=stisHospital.replaceAll("\"", "&#39;");
stisIpAddress=stisIpAddress.replaceAll("'", "&#39;");
stisIpAddress=stisIpAddress.replaceAll("\"", "&#39;");
stisComments=stisComments.replaceAll("'", "&#39;");
stisComments=stisComments.replaceAll("\"", "&#39;");
stisHospitalFullTitle=stisHospitalFullTitle.replaceAll("'", "&#39;");
stisHospitalFullTitle=stisHospitalFullTitle.replaceAll("\"", "&#39;");
stisHospitalPhones=stisHospitalPhones.replaceAll("'", "&#39;");
stisHospitalPhones=stisHospitalPhones.replaceAll("\"", "&#39;");
stisHospitalEmails=stisHospitalEmails.replaceAll("'", "&#39;");
stisHospitalEmails=stisHospitalEmails.replaceAll("\"", "&#39;");
stisHospitalAddress=stisHospitalAddress.replaceAll("'", "&#39;");
stisHospitalAddress=stisHospitalAddress.replaceAll("\"", "&#39;");

hqAdminBacking.getSelectedStisBeanToEdit().setTitle(stisTitle);
hqAdminBacking.getSelectedStisBeanToEdit().setNosokomeio(stisHospital);
hqAdminBacking.getSelectedStisBeanToEdit().setIpAddress(stisIpAddress);
hqAdminBacking.getSelectedStisBeanToEdit().setComments(stisComments);
hqAdminBacking.getSelectedStisBeanToEdit().setNosokomeioFullTitle(stisHospitalFullTitle);
hqAdminBacking.getSelectedStisBeanToEdit().setNosokomeioPhones(stisHospitalPhones);
hqAdminBacking.getSelectedStisBeanToEdit().setNosokomeioEmails(stisHospitalEmails);
hqAdminBacking.getSelectedStisBeanToEdit().setNosokomeioAddress(stisHospitalAddress);

String existingStisIdWithSameName=hqAdminBacking.stisNameExists(stisTitle);
if(existingStisIdWithSameName!=null && existingStisIdWithSameName.equals(hqAdminBacking.getSelectedStisBeanToEdit().getId())==false)
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("add_stis_same_name");
    response.sendRedirect("../editStis.jsp");
}
else
{
    //insert new stis to DB table
    if(hqAdminBacking.updateStis(hqAdminBacking.getSelectedStisBeanToEdit())==true)
    {
        //if success response OK to stis.jsp
        hqAdminBacking.okMessage=langBacking.getLiteral("edit_stis_ok");
        hqAdminBacking.setSelectedStisBeanToEdit(new StisBean());
        response.sendRedirect("../stis.jsp");
    }
    else
    {
        //if failed response ERROR to sites.jsp
        hqAdminBacking.errorMessage=langBacking.getLiteral("add_stis_failed");
        response.sendRedirect(returnToPage);
    }
}
%>