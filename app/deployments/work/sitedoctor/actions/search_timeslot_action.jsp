<%@page import="beans.timeslotBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
//get new site fields
request.setCharacterEncoding("UTF-8");
String apDoctor="";
if(request.getParameter("apDoctor")!=null && request.getParameter("apDoctor").trim().length()>0)
{
    apDoctor=request.getParameter("apDoctor").trim();
}
String apSpec="";
if(request.getParameter("apSpec")!=null && request.getParameter("apSpec").trim().length()>0)
{
    apSpec=request.getParameter("apSpec").trim();
}
String apDate="";
if(request.getParameter("apDate")!=null && request.getParameter("apDate").trim().length()>0)
{
    apDate=request.getParameter("apDate").trim();
}

//replace special chars
//not necessary for this action

//validate fields
if(apDoctor.length()>0 || apSpec.length()>0 || apDate.length()>0)
{
    //retrieve DB
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");

    //search for available doctors and carts
    ArrayList<timeslotBean> timeslotList=DBH.searchForTimeslots(apDoctor,apSpec,apDate);

    //store patList temporary
    session.setAttribute("timeslotList", timeslotList);

    patBean PB = (patBean)session.getAttribute("pat4Appoint");
    response.sendRedirect("../patients.jsp?action=newAppoint&patid="+PB.id);
}
else
{
    response.sendRedirect("../patients.jsp?results=invalidParams");
}
%>