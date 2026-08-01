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
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");
if(returnToPage==null || returnToPage.length()==0)
{
    returnToPage="../myEfimeries.jsp";
}
    
//get new fields
request.setCharacterEncoding("UTF-8");
String efimeriaHash=request.getParameter("efimeriaHash");

//validate 
if(efimeriaHash!=null && efimeriaHash.length()>0)
{
    EfimeriaBean selectedEfimeria = consultantBacking.getMyEfimeriaFromResultsByHash(efimeriaHash);
    if(selectedEfimeria!=null)
    {
        //check if it is after 30' minutes from creation
        Calendar halfCal = Calendar.getInstance();
        halfCal.setTime(new Date(selectedEfimeria.getAddedDateTime().getTime()));
        halfCal.add(Calendar.MINUTE, 30);//an mpike stis 10.00 to halfCal tha einai 10.30
        if(halfCal.getTime().after(new Date()) || halfCal.getTime().equals(new Date()))//an h trexousa wra einai <= tis 10.30
        {
            //check if there are any appointments on this efimeria
            if(consultantBacking.getTeleAppointmentsByEfimeria(selectedEfimeria).size()>0)
            {
                consultantBacking.setInfoMessage(langBacking.getLiteral("efimeria_teleappointments_exist"));
                response.sendRedirect(returnToPage);
            }
            else
            {
                selectedEfimeria.setStatus("Deleted");
                if(consultantBacking.updateEfimeria(selectedEfimeria)==true)
                {
                    consultantBacking.setOkMessage(langBacking.getLiteral("cancel_efimeria_ok"));
                    response.sendRedirect(returnToPage);
                }
                else
                {
                    consultantBacking.setErrorMessage(langBacking.getLiteral("cancel_efimeria_failed"));
                    response.sendRedirect(returnToPage);
                }
            }
        }
        else
        {
            consultantBacking.setInfoMessage(langBacking.getLiteral("out_of_change_time_window"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        consultantBacking.setInfoMessage(langBacking.getLiteral("invalid_efimeria_selection"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    consultantBacking.setInfoMessage(langBacking.getLiteral("invalid_efimeria_selection"));
    response.sendRedirect(returnToPage);
}

%>