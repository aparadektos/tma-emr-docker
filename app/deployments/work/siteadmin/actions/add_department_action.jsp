<%@page import="beans.DepartmentBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
%>

<%
//get new site fields
request.setCharacterEncoding("UTF-8");

String departName=request.getParameter("departName");
String departComment=request.getParameter("departComment");
String departActive=request.getParameter("departActive");

siteAdminBacking.setNewDepartmentBean(new DepartmentBean());
siteAdminBacking.getNewDepartmentBean().setName(departName);
siteAdminBacking.getNewDepartmentBean().setComments(departComment);
siteAdminBacking.getNewDepartmentBean().setActive(departActive);

if(siteAdminBacking.getNewDepartmentBean()!=null && siteAdminBacking.getNewDepartmentBean().getName()!=null && 
   siteAdminBacking.getNewDepartmentBean().getName().trim().length()>0)
{
    if(siteAdminBacking.insertNewDepartment()==true)
    {
        siteAdminBacking.okMessage=langBacking.getLiteral("add_department_ok");
        siteAdminBacking.setNewDepartmentBean(new DepartmentBean());
        response.sendRedirect("../departments.jsp");
    }
    else
    {
        siteAdminBacking.errorMessage=langBacking.getLiteral("add_department_failed");
        response.sendRedirect("../addNewDepartment.jsp");
    }
}
else
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("new_department_required_fields");
    response.sendRedirect("../addNewDepartment.jsp");
}
%>