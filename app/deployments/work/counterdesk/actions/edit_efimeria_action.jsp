

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
String efimeriaHash=request.getParameter("efimeriaHash");
String efimeriaStartTime=request.getParameter("efimeriaStartTime");
String efimeriaEndTime=request.getParameter("efimeriaEndTime");

String rootPage=request.getHeader("Referer");

//validate 
if(efimeriaHash!=null && efimeriaHash.length()>0 && efimeriaStartTime!=null && efimeriaStartTime.length()>0 && 
   efimeriaEndTime!=null && efimeriaEndTime.length()>0)
{
    EfimeriaBean selectedEfimeria = counterdeskBacking.getEfimeriaFromResults(efimeriaHash);
    if(selectedEfimeria!=null)
    {
        SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
        boolean validity=false;
        try
        {
            selectedEfimeria.setStartDateTime(new Timestamp((sdf.parse(selectedEfimeria.getStartDateStr(langBacking.getDateFormat())+" "+efimeriaStartTime)).getTime()));
            selectedEfimeria.setEndDateTime(new Timestamp((sdf.parse(selectedEfimeria.getStartDateStr(langBacking.getDateFormat())+" "+efimeriaEndTime)).getTime()));
            
            validity=true;
        }
        catch(Exception e)
        {
            validity=false;
            counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_availability"));
        }
        
        if(validity==true)
        {
            //check if existing teleAppointments for this siteId and consultantId are also included in new efimeria timeslots
            if(counterdeskBacking.efimeriaIncludesExistingTeleAppointments(selectedEfimeria)==true)
            {
                if(counterdeskBacking.updateEfimeria(selectedEfimeria)==true)
                {
                    //if success response OK
                    counterdeskBacking.setOkMessage(langBacking.getLiteral("edit_efimeria_ok"));
                }
                else
                {
                    //if failed response ERROR
                    counterdeskBacking.setErrorMessage(langBacking.getLiteral("edit_efimeria_failed"));
                }
                response.sendRedirect(rootPage);
            }
            else
            {
                counterdeskBacking.setInfoMessage(langBacking.getLiteral("edit_efimeria_tele_appointments"));
                response.sendRedirect(rootPage);
            }
        }
        else
        {
            response.sendRedirect(rootPage);
        }
    }
    else
    {
        counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_efimeria_selection"));
        response.sendRedirect(rootPage);
    }
}
else
{
    counterdeskBacking.setInfoMessage(langBacking.getLiteral("edit_efimeria_failed"));
    response.sendRedirect(rootPage);
}
    
%>