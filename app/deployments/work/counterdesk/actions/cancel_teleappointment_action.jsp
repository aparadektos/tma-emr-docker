

<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="backings.LanguageBacking"%>
<%
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
    
//get new fields
request.setCharacterEncoding("UTF-8");
String appHash=request.getParameter("appHash");

String rootPage=request.getHeader("Referer");

//validate 
if(appHash!=null && appHash.length()>0 )
{
    TeleAppointmentBean selectedTeleAppointment = counterdeskBacking.getTeleAppointmentFromResults(appHash);
    if(selectedTeleAppointment!=null)
    {
        selectedTeleAppointment.setStatus("Cancelled");
        if(counterdeskBacking.updateTeleAppointmentStatus(selectedTeleAppointment, "Cancelled")==true)
        {
            counterdeskBacking.setOkMessage(langBacking.getLiteral("teleappointment_cancelled_ok"));
            response.sendRedirect(rootPage);
        }
        else
        {
            counterdeskBacking.setInfoMessage(langBacking.getLiteral("action_failed"));
            response.sendRedirect(rootPage);
        }
    }
    else
    {
        counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_tele_appointment"));
        response.sendRedirect(rootPage);
    }
}
else
{
    counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_tele_appointment"));
    response.sendRedirect(rootPage);
}
    
%>