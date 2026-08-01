<%@page import="beans.WebinarBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="beans.StisBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<%
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");
if(returnToPage==null || returnToPage.length()==0)
{
    returnToPage="../webinars.jsp";
}
    
//get new fields
request.setCharacterEncoding("UTF-8");
String webinarHash=request.getParameter("webinarHash");

//validate 
if(webinarHash!=null && webinarHash.length()>0)
{
    WebinarBean selectedWebinar = counterdeskBacking.getWebinarFromResultsByHash(webinarHash);
    if(selectedWebinar!=null)
    {
        selectedWebinar.setDeleted("true");
        if(counterdeskBacking.deleteWebinar(selectedWebinar)==true)
        {
            counterdeskBacking.setOkMessage(langBacking.getLiteral("delete_webinar_ok"));
            response.sendRedirect(returnToPage);
        }
        else
        {
            counterdeskBacking.setErrorMessage(langBacking.getLiteral("delete_webinar_failed"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_webinar_selection"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_webinar_selection"));
    response.sendRedirect(returnToPage);
}

%>