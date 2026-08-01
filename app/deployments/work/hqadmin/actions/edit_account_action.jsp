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

//get new account fields
request.setCharacterEncoding("UTF-8");
String accUsername=request.getParameter("accUsername");
String accPassword=request.getParameter("accPassword");
String accRoleId=request.getParameter("accRoleId");
String accSiteId="-1";//request.getParameter("accSiteId");
String accActive=request.getParameter("accActive");
String accName=request.getParameter("accName");
String accSurname=request.getParameter("accSurname");
String accEmail=request.getParameter("accEmail");
String accMobilePhone=request.getParameter("accMobilePhone");
String accOtherInfo=request.getParameter("accOtherInfo");
String accByPassAd=request.getParameter("accByPassAd");

if(accPassword!=null && accPassword.trim().length()>2)
{
    hqAdminBacking.accountToEdit.password=accPassword;
}
hqAdminBacking.accountToEdit.RB=new roleBean(accRoleId, "");
hqAdminBacking.accountToEdit.name=accName;
hqAdminBacking.accountToEdit.surname=accSurname;
hqAdminBacking.accountToEdit.SB=new siteBean("-1","", "", "");
hqAdminBacking.accountToEdit.mobilePhone=accMobilePhone;
hqAdminBacking.accountToEdit.email=accEmail;
hqAdminBacking.accountToEdit.otherInfo=accOtherInfo;
hqAdminBacking.accountToEdit.deleted="false";
hqAdminBacking.accountToEdit.active=accActive;

//validate fields
if(accName!=null && accName.length()>0 && accSurname!=null && accSurname.length()>0 &&
   accRoleId!=null && accRoleId.length()>0)
{
    boolean passOk=false;
    if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
    {
        hqAdminBacking.accountToEdit.setByPassAd("true");
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
        hqAdminBacking.accountToEdit.setByPassAd("false");
        hqAdminBacking.accountToEdit.password="1234567890";
        passOk=true;
    }
    
    if(passOk)
    {
        if(hqAdminBacking.editAccount()==true)
        {
            hqAdminBacking.accountToEdit=new accountBean();
            hqAdminBacking.okMessage=langBacking.getLiteral("edit_account_ok");
            response.sendRedirect("../accounts.jsp");
        }
        else
        {
            hqAdminBacking.errorMessage=langBacking.getLiteral("edit_account_failed");
            response.sendRedirect("../editAccount.jsp");
        }
    }
    else
    {
        hqAdminBacking.infoMessage=langBacking.getLiteral("edit_account_required_fields");
        response.sendRedirect("../editAccount.jsp");
    }
}
else
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("edit_account_required_fields");
    response.sendRedirect("../editAccount.jsp");
}
%>