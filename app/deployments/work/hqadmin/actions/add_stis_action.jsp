<%@page import="tools.GlobalHelper"%>
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


hqAdminBacking.setNewStisBean(new StisBean());
hqAdminBacking.getNewStisBean().setTitle(stisTitle);
hqAdminBacking.getNewStisBean().setNosokomeio(stisHospital);
hqAdminBacking.getNewStisBean().setIpAddress(stisIpAddress);
hqAdminBacking.getNewStisBean().setComments(stisComments);
hqAdminBacking.getNewStisBean().setNosokomeioFullTitle(stisHospitalFullTitle);
hqAdminBacking.getNewStisBean().setNosokomeioPhones(stisHospitalPhones);
hqAdminBacking.getNewStisBean().setNosokomeioEmails(stisHospitalEmails);
hqAdminBacking.getNewStisBean().setNosokomeioAddress(stisHospitalAddress);

String existingStisIdWithSameName=hqAdminBacking.stisNameExists(stisTitle);
if(existingStisIdWithSameName!=null)
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("add_stis_same_name");
    response.sendRedirect("../newStis.jsp");
}
else
{
    int stisNum = hqAdminBacking.getTotalStis();//13
    if(stisNum<GlobalHelper.totalStis)
    {
        //insert new stis to DB table
        if(hqAdminBacking.insertNewStis(hqAdminBacking.getNewStisBean())==true)
        {
            //if success response OK to stis.jsp
            hqAdminBacking.okMessage=langBacking.getLiteral("add_stis_ok");
            hqAdminBacking.setNewStisBean(new StisBean());
            response.sendRedirect("../stis.jsp");
        }
        else
        {
            //if failed response ERROR to sites.jsp
            hqAdminBacking.errorMessage=langBacking.getLiteral("add_stis_failed");
            response.sendRedirect("../stis.jsp");
        }
    }
    else
    {
        hqAdminBacking.errorMessage=langBacking.getLiteral("stis_max_num")+": "+GlobalHelper.totalStis;
        response.sendRedirect("../stis.jsp");
    }
}
%>