

<%@page import="beans.Icd10Bean"%>
<%@page import="beans.appointmentsBean"%>
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
    appointmentsBean newAppBean = (appointmentsBean)session.getAttribute("newAppBean");
    for(Icd10Bean curIcd : newAppBean.icdList)
    {
        if(curIcd.id.equals(icdId))
        {
            newAppBean.icdList.remove(curIcd);
            break;
        }
    }
}
else
{
    //"invalid icdId selected");
}

response.sendRedirect(returnToPage);

%>