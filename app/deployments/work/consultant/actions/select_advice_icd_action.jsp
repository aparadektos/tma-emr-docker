

<%@page import="backings.ConsultantBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="backings.LanguageBacking"%>


<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");

//get new fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");

String icdId = request.getParameter("icdId");

if(icdId!=null && icdId.length()>0)
{
    Icd10Bean icdBean=consultantBacking.getIcd10ById(icdId);
    if(icdBean!=null)
    {
        if(consultantBacking.getSelectedTeleAppointment().getAdviceIcdList()==null)
        {
            consultantBacking.getSelectedTeleAppointment().setAdviceIcdList(new ArrayList<Icd10Bean>(0));
        }
        consultantBacking.getSelectedTeleAppointment().getAdviceIcdList().add(icdBean);
        
        //add to DB
        if(consultantBacking.updateAdviceIcdToTeleAppointment(consultantBacking.getSelectedTeleAppointment())==true)
        {
            //SelectedTeleAppointment contains list of ICDs.....
            
//            consultantBacking.setOkMessage(langBacking.getLiteral(""));
        }
        else
        {
            consultantBacking.setErrorMessage(langBacking.getLiteral("add_icd_failed"));
        }
        
        //retrieve adviceIcdList from DB in any case
        consultantBacking.getSelectedTeleAppointment().setAdviceIcdList(consultantBacking.findAdviceIcdListByAppId(consultantBacking.getSelectedTeleAppointment().getId()));
    }
    else
    {
        //"invalid icdId selected");
    }
}
else
{
    //"invalid icdId selected");
}

response.sendRedirect(returnToPage);

%>