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


    
//get new fields
request.setCharacterEncoding("UTF-8");
String efimeriaStartDate=request.getParameter("efimeriaStartDate");
String efimeriaStartTime=request.getParameter("efimeriaStartTime");
String efimeriaEndDate=request.getParameter("efimeriaEndDate");
String efimeriaEndTime=request.getParameter("efimeriaEndTime");
String stisId=request.getParameter("stisId");

//validate 
if(stisId!=null && stisId.length()>0 && efimeriaStartDate!=null && efimeriaStartDate.length()>0 && 
   efimeriaStartTime!=null && efimeriaStartTime.length()>0 && efimeriaEndDate!=null && efimeriaEndDate.length()>0 && 
   efimeriaEndTime!=null && efimeriaEndTime.length()>0 )
{
    StisBean selectedStisBean = null;
    for(StisBean curStis : consultantBacking.getAB().consultantBean.getStisList())
    {
        if(curStis.getId().equals(stisId))
        {
            selectedStisBean=curStis;
            break;
        }
    }
    
    if(selectedStisBean!=null)
    {
        consultantBacking.setNewEfimeriaBean(new EfimeriaBean());
        consultantBacking.getNewEfimeriaBean().setAddedDateTime(new Timestamp(new Date().getTime()));
        consultantBacking.getNewEfimeriaBean().setStisBean(selectedStisBean);
        consultantBacking.getNewEfimeriaBean().setConsultantBean(consultantBacking.getAB().consultantBean);
        SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
        boolean validity=false;
        try
        {
            consultantBacking.getNewEfimeriaBean().setStartDateTime(new Timestamp((sdf.parse(efimeriaStartDate+" "+efimeriaStartTime)).getTime()));
            consultantBacking.getNewEfimeriaBean().setEndDateTime(new Timestamp((sdf.parse(efimeriaEndDate+" "+efimeriaEndTime)).getTime()));
            if(consultantBacking.getNewEfimeriaBean().getStartDateTime().after(new Date()) && 
               consultantBacking.getNewEfimeriaBean().getStartDateTime().before(consultantBacking.getNewEfimeriaBean().getEndDateTime()))
            {
                //check conflicts
                if(consultantBacking.checkEfimeriaConflicts(consultantBacking.getNewEfimeriaBean())==true)
                {
                    validity=false;
                    consultantBacking.setInfoMessage(langBacking.getLiteral("availability_conflict"));
                }
                else
                {
                    validity=true;
                }
            }
            else
            {
                validity=false;
                consultantBacking.setInfoMessage(langBacking.getLiteral("invalid_availability"));
            }
        }
        catch(Exception e)
        {
            validity=false;
            consultantBacking.setInfoMessage(langBacking.getLiteral("invalid_availability"));
        }
        //insert new stis to DB table
        if(validity==true)
        {
            if(consultantBacking.insertNewEfimeria(consultantBacking.getNewEfimeriaBean())==true)
            {
                //if success response OK
                consultantBacking.setOkMessage(langBacking.getLiteral("add_availability_ok"));
                consultantBacking.setNewEfimeriaBean(new EfimeriaBean());
                response.sendRedirect("../myEfimeries.jsp");
            }
            else
            {
                //if failed response ERROR
                consultantBacking.setErrorMessage(langBacking.getLiteral("add_availability_failed"));
                response.sendRedirect("../myEfimeries.jsp");
            }
        }
        else
        {
            response.sendRedirect("../myEfimeries.jsp");
        }
    }
    else
    {
        consultantBacking.setInfoMessage(langBacking.getLiteral("add_availability_failed"));
        response.sendRedirect("../myEfimeries.jsp");
    }
}
else
{
    consultantBacking.setInfoMessage(langBacking.getLiteral("add_availability_failed"));
    response.sendRedirect("../myEfimeries.jsp");
}





%>