<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteUserBacking"%>
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
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

//get new patient fields
request.setCharacterEncoding("UTF-8");
String patId=request.getParameter("patId").trim();

//validate fields
if(patId!=null && patId.length()>0)
{    
    //update patient to DB table
    if(siteUserBacking.deletePatient(patId)==true)
    {
        //if success response OK 
        siteUserBacking.okMessage=langBacking.getLiteral("patient_delete_ok");
        siteUserBacking.patientSearchResults=new ArrayList<patBean>(0);
        response.sendRedirect("../patients.jsp");
    }
    else
    {
        //if failed response ERROR 
        siteUserBacking.errorMessage=langBacking.getLiteral("patient_delete_failed");
        response.sendRedirect("../patients.jsp");
    }
}
else
{
    siteUserBacking.errorMessage=langBacking.getLiteral("patient_delete_failed");
    response.sendRedirect("../patients.jsp");
}
%>