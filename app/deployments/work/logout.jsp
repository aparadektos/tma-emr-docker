<%@page import="backings.CounterdeskBacking"%>
<%@page import="tools.RisLogger"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.UserHistoryBean"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="tools.DBHelper"%>

<%
//close DB connection
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
if(DBH!=null)
{
    String logData="";
    ArrayList<UserHistoryBean> recentHist =  DBH.getRecentHistory(100);
    for(UserHistoryBean curHist : recentHist)
    {
        logData+=curHist.dateAndTime.toString()+"\t"+curHist.transaction+"\r\n";
    }
    RisLogger.addLogRecord(logData,null);
    
}

/*
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
if(siteUserBacking!=null && siteUserBacking.DBH!=null)
{
    siteUserBacking.DBH.closeConnection();
}

SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
if(siteDoctorBacking!=null && siteDoctorBacking.DBH!=null)
{
    siteDoctorBacking.DBH.closeConnection();
}

SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
if(siteAdminBacking!=null && siteAdminBacking.DBH!=null)
{
    siteAdminBacking.DBH.closeConnection();
}

HqAdminBacking hqAdminBacking = (HqAdminBacking)session.getAttribute("hqAdminBacking");
if(hqAdminBacking!=null && hqAdminBacking.DBH!=null)
{
    hqAdminBacking.DBH.closeConnection();
}

CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");
if(counterdeskBacking!=null)
{
    counterdeskBacking.closeConnection();
}
*/

//empty session
session.invalidate();

//go to login again
response.sendRedirect(request.getContextPath()+"/index.jsp");

System.out.println ("User logged off");
%>