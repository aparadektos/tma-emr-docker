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
String accUsername=request.getParameter("accUsername");
String accPassword=request.getParameter("accPassword");
String accRoleId="3";
String accByPassAd=request.getParameter("accByPassAd");
String accSiteId=siteAdminBacking.AB.SB.id;
String accActive=request.getParameter("accActive");
String accName=request.getParameter("accName");
String accSurname=request.getParameter("accSurname");
String accEmail=request.getParameter("accEmail");
String accMobilePhone=request.getParameter("accMobilePhone");
String accOtherInfo=request.getParameter("accOtherInfo");

siteAdminBacking.newAccountBean = new accountBean();
siteAdminBacking.newAccountBean.RB=new roleBean(accRoleId, "");
siteAdminBacking.newAccountBean.name=accName;
siteAdminBacking.newAccountBean.surname=accSurname;
siteAdminBacking.newAccountBean.username=accUsername;
siteAdminBacking.newAccountBean.password=accPassword;
siteAdminBacking.newAccountBean.SB=siteAdminBacking.AB.SB;
siteAdminBacking.newAccountBean.mobilePhone=accMobilePhone;
siteAdminBacking.newAccountBean.email=accEmail;
siteAdminBacking.newAccountBean.otherInfo=accOtherInfo;
siteAdminBacking.newAccountBean.deleted="false";
siteAdminBacking.newAccountBean.active=accActive;

//check if username exists.
if(siteAdminBacking.usernameExists(accUsername)==true)
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("username_exists");
    response.sendRedirect("../newSiteUserAccount.jsp");
}
else
{
    //validate fields
    if(accUsername!=null && accUsername.length()>0 && accName!=null && accName.length()>0 && 
       accSurname!=null && accSurname.length()>0 && accRoleId!=null && accRoleId.length()>0)
    {
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
            
            
            
            if(siteAdminBacking.insertNewAccount()==true)
            {
                siteAdminBacking.newAccountBean=new accountBean();
                siteAdminBacking.okMessage=langBacking.getLiteral("add_account_ok");
                response.sendRedirect("../localAccounts.jsp");
            }
            else
            {
                siteAdminBacking.errorMessage=langBacking.getLiteral("add_account_failed");
                response.sendRedirect("../newSiteUserAccount.jsp");
            }
        }
        else
        {
            siteAdminBacking.infoMessage=langBacking.getLiteral("new_site_user_required_fields");
            response.sendRedirect("../newSiteUserAccount.jsp");
        }
    }
    else
    {
        siteAdminBacking.infoMessage=langBacking.getLiteral("new_site_user_required_fields");
        response.sendRedirect("../newSiteUserAccount.jsp");
    }
}
%>