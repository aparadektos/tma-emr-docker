
<%@page import="backings.SiteUserBacking"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ExamTypeBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

String returnToPage=request.getHeader("Referer");

String examTypeId = request.getParameter("examTypeId");

if(examTypeId!=null && examTypeId.length()>0)
{
    ExamTypeBean examTypeBean=siteUserBacking.getExamTypeByID(examTypeId);
    if(examTypeBean!=null && examTypeBean.getId()!=null && examTypeBean.getId().length()>0)
    {
        appointmentsBean newAppBean = (appointmentsBean)session.getAttribute("newAppBean");
        newAppBean.ETB=examTypeBean;
        session.setAttribute("newAppBean", newAppBean);
        
        //reset previous examination room availability results. 
        //the user should search again, since there is a new exam type selected.
        //new modality type may be different compared to previously selected exam type modality type.
        ArrayList<ExamroomsBean> examRoomsResults=new ArrayList<ExamroomsBean>(0);
        session.setAttribute("examRoomsResults", null);
    }
    else
    {
        siteUserBacking.errorMessage=langBacking.getLiteral("invalid examTypeId selected");
    }
}
else
{
    siteUserBacking.errorMessage=langBacking.getLiteral("invalid examTypeId selected");
}

response.sendRedirect(returnToPage);

%>