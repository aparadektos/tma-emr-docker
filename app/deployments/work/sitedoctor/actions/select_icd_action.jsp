

<%@page import="java.util.ArrayList"%>
<%@page import="beans.appointmentsBean"%>
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

String returnToPage=request.getHeader("Referer");

String icdId = request.getParameter("icdId");

if(icdId!=null && icdId.length()>0)
{
    Icd10Bean icdBean=siteDoctorBacking.getIcd10ById(icdId);
    if(icdBean!=null)
    {
        appointmentsBean newAppBean = (appointmentsBean)session.getAttribute("newAppBean");
        if(newAppBean.icdList!=null)
        {
            newAppBean.icdList.add(icdBean);
        }
        else
        {
            newAppBean.icdList=new ArrayList<Icd10Bean>(0);
        }
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