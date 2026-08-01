<%@page import="backings.LanguageBacking"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="java.util.Date"%>
<%@page import="beans.timeslotBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new patient fields
request.setCharacterEncoding("UTF-8");
String patId=request.getParameter("patId").trim();

//validate fields
if(patId!=null && patId.length()>0)
{    
    //update patient to DB table
    if(paramedicBacking.deletePatient(patId)==true)
    {
        //if success response OK 
        paramedicBacking.okMessage=langBacking.getLiteral("patient_delete_ok");
        paramedicBacking.patientSearchResults=new ArrayList<patBean>(0);
        response.sendRedirect("../patients.jsp");
    }
    else
    {
        //if failed response ERROR 
        paramedicBacking.errorMessage=langBacking.getLiteral("patient_delete_failed");
        response.sendRedirect("../patients.jsp");
    }
}
else
{
    paramedicBacking.errorMessage=langBacking.getLiteral("patient_delete_failed");
    response.sendRedirect("../patients.jsp");
}
%>