
<%@page import="backings.ConsultantBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="backings.LanguageBacking"%>


<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");

//get new fields
request.setCharacterEncoding("UTF-8");

consultantBacking.setIcdResultsList(new ArrayList<Icd10Bean>(0));

String icdDescr=request.getParameter("icdDescr");
consultantBacking.setIcdDescrSearchString("");
if(icdDescr!=null)
{
    consultantBacking.setIcdDescrSearchString(icdDescr);
    consultantBacking.setIcdResultsList(consultantBacking.searchIcd10ByDescr(icdDescr));
}

response.sendRedirect(request.getHeader("Referer"));
%>