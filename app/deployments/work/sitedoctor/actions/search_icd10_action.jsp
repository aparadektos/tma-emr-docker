
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

//get new fields
request.setCharacterEncoding("UTF-8");

siteDoctorBacking.icdResultsList=new ArrayList<Icd10Bean>(0);

String icdDescr=request.getParameter("icdDescr");
siteDoctorBacking.icdDescrSearchString="";
if(icdDescr!=null)
{
    siteDoctorBacking.icdDescrSearchString=icdDescr;
    siteDoctorBacking.icdResultsList=siteDoctorBacking.searchIcd10ByDescr(icdDescr);
}

response.sendRedirect(request.getHeader("Referer"));
%>