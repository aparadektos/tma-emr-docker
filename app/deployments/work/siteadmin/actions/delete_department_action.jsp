<%@page import="beans.DepartmentBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="tools.DBHelper"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");

String departmentToDeleteHash = request.getParameter("departmentToDeleteHash");

DepartmentBean selectedDepartmentToDelete=null;
for(DepartmentBean curDepart : siteAdminBacking.getAllSiteDepartments())
{
    if(curDepart.hashCode()==Integer.parseInt(departmentToDeleteHash))
    {
        selectedDepartmentToDelete=curDepart;
        break;
    }
}

if(selectedDepartmentToDelete!=null)
{
    if(siteAdminBacking.deleteDepartment(selectedDepartmentToDelete)==true)
    {
        siteAdminBacking.okMessage=langBacking.getLiteral("delete_department_ok");
        response.sendRedirect("../departments.jsp");
    }
    else
    {
        siteAdminBacking.errorMessage=langBacking.getLiteral("delete_department_failed");
        response.sendRedirect("../departments.jsp");
    }
}
else
{
    siteAdminBacking.errorMessage=langBacking.getLiteral("invalid_department");
    response.sendRedirect("../departments.jsp");
}
%>
   
