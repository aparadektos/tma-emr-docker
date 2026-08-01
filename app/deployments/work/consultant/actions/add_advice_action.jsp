

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="backings.LanguageBacking"%>
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
String teleAppId=request.getParameter("teleAppId");
String adviceText=request.getParameter("adviceText");

adviceText=adviceText.replaceAll("'", "&quot;");
adviceText=adviceText.replaceAll("\"", "&quot;");
adviceText=adviceText.replaceAll("'", "&quot;");
adviceText=adviceText.replaceAll("\"", "&quot;");

adviceText=adviceText.replaceAll("\r", "&nbsp;&nbsp;");
adviceText=adviceText.replaceAll("\n", "&nbsp;&nbsp;");
adviceText=adviceText.replaceAll("\r\n", "&nbsp;&nbsp;");

//validate 
if(teleAppId!=null && teleAppId.length()>0 && adviceText!=null && adviceText.length()>0)
{
    if(consultantBacking.getSelectedTeleAppointment()!=null && teleAppId.equals(consultantBacking.getSelectedTeleAppointment().getId()))
    {
        Date now = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
        //adviceText+="<div align=\"center\">"+consultantBacking.getAB().getFullName()+"<br/>"+consultantBacking.getAB().consultantBean.getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>"+sdf.format(now)+"</div>";
        if(consultantBacking.insertAdviceToTeleAppointment(consultantBacking.getSelectedTeleAppointment(),adviceText)==true)
        {
            //if success response OK
            consultantBacking.setOkMessage(langBacking.getLiteral("add_advice_ok"));
            response.sendRedirect("../popupAddAdvice.jsp");
        }
        else
        {
            //if failed response ERROR
            consultantBacking.setErrorMessage(langBacking.getLiteral("add_advice_failed"));
            response.sendRedirect(returnToPage);
        }
    }
    else
    {
        consultantBacking.setErrorMessage(langBacking.getLiteral("invalid_selection"));
        response.sendRedirect(returnToPage);
    }
}
else
{
    consultantBacking.setInfoMessage(langBacking.getLiteral("add_advice_failed"));
    response.sendRedirect(returnToPage);
}

%>