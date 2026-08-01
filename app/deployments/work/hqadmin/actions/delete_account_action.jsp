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

//validate fields
if(hqAdminBacking.accountToEdit!=null)
{    
    if(hqAdminBacking.deleteAccount()==true)
    {
        hqAdminBacking.accountToEdit=new accountBean();
        hqAdminBacking.okMessage=langBacking.getLiteral("delete_account_ok");
        response.sendRedirect("../accounts.jsp");
    }
    else
    {
        hqAdminBacking.errorMessage=langBacking.getLiteral("delete_account_failed");
        response.sendRedirect("../editAccount.jsp");
    }
}
else
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("delete_account_failed");
    response.sendRedirect("../editAccount.jsp");
}
%>