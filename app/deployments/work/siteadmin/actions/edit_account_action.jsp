<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.roleBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new account fields
request.setCharacterEncoding("UTF-8");
String accPassword=request.getParameter("accPassword");
String accActive=request.getParameter("accActive");
String accName=request.getParameter("accName");
String accSurname=request.getParameter("accSurname");
String accEmail=request.getParameter("accEmail");
String accMobilePhone=request.getParameter("accMobilePhone");
String accOtherInfo=request.getParameter("accOtherInfo");
String accByPassAd=request.getParameter("accByPassAd");
if(accPassword!=null && accPassword.trim().length()>2)
{
    siteAdminBacking.accountToEdit.password=accPassword;
}
siteAdminBacking.accountToEdit.name=accName;
siteAdminBacking.accountToEdit.surname=accSurname;
siteAdminBacking.accountToEdit.mobilePhone=accMobilePhone;
siteAdminBacking.accountToEdit.email=accEmail;
siteAdminBacking.accountToEdit.otherInfo=accOtherInfo;
siteAdminBacking.accountToEdit.deleted="false";
siteAdminBacking.accountToEdit.active=accActive;

//validate fields
if(accName!=null && accName.length()>0 && accSurname!=null && accSurname.length()>0 &&
   accActive!=null && accActive.length()>0)
{
    boolean passOk=false;
    if(accByPassAd!=null && accByPassAd.equalsIgnoreCase("on"))
    {
        siteAdminBacking.accountToEdit.setByPassAd("true");
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
        siteAdminBacking.accountToEdit.setByPassAd("false");
        siteAdminBacking.accountToEdit.password="1234567890";
        passOk=true;
    }
    
    if(passOk)
    {
        if(siteAdminBacking.editAccount()==true)
        {
            siteAdminBacking.accountToEdit=new accountBean();
            siteAdminBacking.okMessage=langBacking.getLiteral("edit_account_ok");
            response.sendRedirect("../localAccounts.jsp");
        }
        else
        {
            siteAdminBacking.errorMessage=langBacking.getLiteral("edit_account_failed");
            response.sendRedirect("../editSiteUserAccount.jsp");
        }
    }
    else
    {
        siteAdminBacking.infoMessage=langBacking.getLiteral("edit_site_user_account_required_fields");
        response.sendRedirect("../editSiteUserAccount.jsp");
    }
}
else
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("edit_site_user_account_required_fields");
    response.sendRedirect("../editSiteUserAccount.jsp");
}
%>