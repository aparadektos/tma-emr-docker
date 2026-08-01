<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.roleBean"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//validate fields
if(siteAdminBacking.accountToEdit!=null)
{    
    if(siteAdminBacking.deleteAccount()==true)
    {
        siteAdminBacking.accountToEdit=new accountBean();
        siteAdminBacking.okMessage=langBacking.getLiteral("delete_account_ok");
        response.sendRedirect("../localAccounts.jsp");
    }
    else
    {
        siteAdminBacking.errorMessage=langBacking.getLiteral("delete_account_failed");
        response.sendRedirect("../localAccounts.jsp");
    }
}
else
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("delete_account_failed");
    response.sendRedirect("../localAccounts.jsp");
}
%>