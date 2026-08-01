<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<%
accountBean AB=(accountBean)session.getAttribute("AB");

if(AB!=null)
{
    if(AB.RB.roleName.equals("siteadmin")==false)
    {
        //empty session
        session.invalidate();

        //go to login again
        response.sendRedirect("../index.jsp");
    }
}
else
{
    //empty session
    session.invalidate();
    
    //go to login again
    response.sendRedirect("../index.jsp");
}
%>