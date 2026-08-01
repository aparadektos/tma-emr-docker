<%@page import="beans.TeleAppointmentBean"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");

//get fields
request.setCharacterEncoding("UTF-8");

String consultantSpecialtyId1=request.getParameter("consultantSpecialtyId1");
String consultantSpecialtyId2=request.getParameter("consultantSpecialtyId2");
String previewDatePicker=request.getParameter("previewDatePicker");

if(consultantSpecialtyId1!=null && previewDatePicker!=null)
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    Date submittedDate = sdf.parse(previewDatePicker);
    submittedDate.setHours(23);
    submittedDate.setMinutes(59);
    submittedDate.setSeconds(59);
    if(submittedDate.before(new Date()))
    {
        paramedicBacking.infoMessage=langBacking.getLiteral("invalid_date_search");
    }
    else
    {
        paramedicBacking.getNewTeleappointment().setConsultantBean1(null);
        paramedicBacking.getNewTeleappointment().setConsultantBean2(null);
        paramedicBacking.getNewTeleappointment().setStisBean1(null);
        paramedicBacking.getNewTeleappointment().setStisBean2(null);
        
        paramedicBacking.getNewTeleappointment().setStartdatetime(new Timestamp(submittedDate.getTime()));
        
        SpecialtyBean reqSpecialty1 = new SpecialtyBean();
        reqSpecialty1.setId(consultantSpecialtyId1);
        paramedicBacking.getNewTeleappointment().setRequestedSpecialtyBean1(reqSpecialty1);
        
        if(consultantSpecialtyId2!=null && consultantSpecialtyId2.length()>1)
        {
            SpecialtyBean reqSpecialty2 = new SpecialtyBean();
            reqSpecialty2.setId(consultantSpecialtyId2);
            paramedicBacking.getNewTeleappointment().setRequestedSpecialtyBean2(reqSpecialty2);
        }
        else
        {
            paramedicBacking.getNewTeleappointment().setStisBean2(null);
            paramedicBacking.getNewTeleappointment().setRequestedSpecialtyBean2(null);
            paramedicBacking.getNewTeleappointment().setConsultantBean2(null);
        }
        
        paramedicBacking.searchEfimeriesByDateAndSpecialties(consultantSpecialtyId1,consultantSpecialtyId2,submittedDate);
        
        if(paramedicBacking.getAvailableEfimeriesResults()!=null && paramedicBacking.getAvailableEfimeriesResults().size()==0)
        {
            paramedicBacking.infoMessage=langBacking.getLiteral("no_efimeries_found");
        }
        else
        {
            //gia na deixnei ta apotelesmata mono otan exei ginei anazitisi prwta. stin selida provolis, meta ton pinaka ginetai false.
            paramedicBacking.setShowAvailableEfimeriesResults(true);
        }
    }
}
else
{
    paramedicBacking.infoMessage=langBacking.getLiteral("invalid_search");
}

response.sendRedirect("../newTeleAppointment.jsp");
%>