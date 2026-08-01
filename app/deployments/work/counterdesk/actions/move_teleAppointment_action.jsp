
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="backings.LanguageBacking"%>
<%
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");
if(returnToPage==null || returnToPage.length()==0)
{
    returnToPage="../popupShowTeleAppointmentDetails.jsp";
}
returnToPage="../popupShowTeleAppointmentDetails.jsp";

//retrieve form data
String selectedEfimeriaId = request.getParameter("selectedEfimeriaId");
String selectedTime = request.getParameter("selectedTime");

if(selectedEfimeriaId!=null && selectedEfimeriaId.length()>0 && 
   selectedTime!=null && selectedTime.length()>0 && counterdeskBacking.getSelectedTeleAppointment()!=null)
{
    EfimeriaBean selectedEfimeriaBean = null;
    for(EfimeriaBean curEfimeria : counterdeskBacking.getKavatzaEfimeriesResults())
    {
        if(curEfimeria.getId().equals(selectedEfimeriaId))
        {
            selectedEfimeriaBean=curEfimeria;
            counterdeskBacking.getSelectedTeleAppointment().setStisBean1(selectedEfimeriaBean.getStisBean());
            counterdeskBacking.getSelectedTeleAppointment().setConsultantBean1(selectedEfimeriaBean.getConsultantBean());
            counterdeskBacking.getSelectedTeleAppointment().setRequestedSpecialtyBean1(selectedEfimeriaBean.getConsultantBean().getSpecialtyBean());
            break;
        }
    }
    
    Date selectedDateTime = null;
    try
    {
        SimpleDateFormat sdfDate = new SimpleDateFormat(langBacking.getDateFormat());
        String curDateStr=sdfDate.format(new Date());
        
        SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
        selectedDateTime = sdf.parse(curDateStr+" "+selectedTime);
        counterdeskBacking.getSelectedTeleAppointment().setStartdatetime(new Timestamp(selectedDateTime.getTime()));
    }
    catch(Exception e)
    {
        selectedDateTime = null;
        counterdeskBacking.getSelectedTeleAppointment().setStartdatetime(null);
    }
    
    if(selectedDateTime==null || counterdeskBacking.getSelectedTeleAppointment().getStartdatetime()==null)
    {
        counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_tele_appointment"));
        response.sendRedirect(returnToPage);
    }
    else
    {
        Calendar endCal = Calendar.getInstance();
        endCal.setTime((Date)counterdeskBacking.getSelectedTeleAppointment().getStartdatetime().clone());
        endCal.add(Calendar.MINUTE, 30);
        counterdeskBacking.getSelectedTeleAppointment().setEnddatetime(new Timestamp(endCal.getTime().getTime()));
        
        //stis1, consultant1, specialty1, startdatetime, enddatetime
        if(counterdeskBacking.moveTeleAppointment(counterdeskBacking.getSelectedTeleAppointment())==true)
        {
            counterdeskBacking.setOkMessage(langBacking.getLiteral("move_appointment_ok"));
            response.sendRedirect(returnToPage);
        }
        else
        {
            counterdeskBacking.setErrorMessage(langBacking.getLiteral("move_appointment_failed"));
            response.sendRedirect(returnToPage);
        }
    }
}
else
{
    counterdeskBacking.setInfoMessage(langBacking.getLiteral("invalid_tele_appointment"));
    response.sendRedirect(returnToPage);
}
%>