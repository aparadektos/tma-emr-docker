<%@page import="beans.StisBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.UserHistoryBean"%>
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
String stisHash=request.getParameter("stisHash");

StisBean selectedStis = null;
for(StisBean curStis : hqAdminBacking.getAllStisResults())
{
    if(stisHash.equals(curStis.hashCode()+""))
    {
        selectedStis=curStis;
        break;
    }
}

//validate fields
if(selectedStis!=null)
{
    if(hqAdminBacking.deleteStisById(selectedStis.getId())==true)
    {
        hqAdminBacking.okMessage=langBacking.getLiteral("delete_ok");
        response.sendRedirect("../stis.jsp");
    }
    else
    {
        //if failed response ERROR to sites.jsp
        hqAdminBacking.errorMessage=langBacking.getLiteral("delete_failed");
        response.sendRedirect("../stis.jsp?");
    }
}
else
{
    hqAdminBacking.errorMessage=langBacking.getLiteral("delete_failed");
    response.sendRedirect("../stis.jsp");
}
%>