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
String siteID=request.getParameter("sid").trim();

//validate fields
if(siteID!=null && siteID.length()>0)
{
    //get centerid that new site belongs to
    accountBean AB=(accountBean)session.getAttribute("AB");
    //prosorina einai AB.centerID alla prepei na to pairnoyme apo to centerBean AB.CB.centerID

    //create new siteBean
    siteBean SB=new siteBean(siteID, "", "", "");

    //retrieve DB
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");
    
    //delete site from DB table
    if(DBH.deleteSite(SB)==true)
    {
        //if success response OK to sites.jsp
        UserHistoryBean userHist = new UserHistoryBean();
        userHist.accountId=AB.id;
        userHist.dateAndTime=new Timestamp(new Date().getTime());
        userHist.siteId=AB.SB.id;
        userHist.transaction="DELETE_SITE";
        userHist.comments="Site: "+SB.name+", deleted site id: "+SB.id;
        DBH.insertNewUserHistory(userHist);
        
        hqAdminBacking.okMessage=langBacking.getLiteral("delete_site_ok");
        response.sendRedirect("../sites.jsp?result=siteDeleted");
    }
    else
    {
        //if failed response ERROR to sites.jsp
        hqAdminBacking.errorMessage=langBacking.getLiteral("delete_site_failed");
        response.sendRedirect("../sites.jsp?result=error4delete");
    }
}
else
{
    hqAdminBacking.errorMessage=langBacking.getLiteral("delete_site_failed");
    response.sendRedirect("../sites.jsp?result=error");
}
%>