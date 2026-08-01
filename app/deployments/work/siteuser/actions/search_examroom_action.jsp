<%@page import="beans.ExamTypeBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="java.util.Date"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");
String examTypeID="";
if(request.getParameter("apExamType")!=null && request.getParameter("apExamType").trim().length()>0)
{
    examTypeID=request.getParameter("apExamType").trim();
}
String appDuration="";
if(request.getParameter("appDuration")!=null && request.getParameter("appDuration").trim().length()>0)
{
    appDuration=request.getParameter("appDuration").trim();
}

//replace special chars
//not necessary for this action

//validate fields
if(examTypeID.length()>0 && appDuration.length()>0)
{
    //retrieve AB
    accountBean AB=(accountBean)session.getAttribute("AB");
    //retrieve DB
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");
    
    //get ExamType bean
    ExamTypeBean examTypeBean=DBH.getExamTypeByID(examTypeID);
    appointmentsBean newAppBean = (appointmentsBean)session.getAttribute("newAppBean");
    newAppBean.ETB=examTypeBean;
    newAppBean.duration=appDuration;
    session.setAttribute("newAppBean", newAppBean);

    //search for available examrooms where their modalities are valid for the selected examtype 
    ArrayList<ExamroomsBean> examRoomsResults=siteUserBacking.searchForExamroomsByModalityType(AB.SB.id,examTypeBean.getModalityType());
    if(examRoomsResults!=null && examRoomsResults.size()==0)
    {
        siteUserBacking.infoMessage=langBacking.getLiteral("message_for_unavailable_examination_rooms");
        examRoomsResults = DBH.getAllExamroomsBySiteId(AB.SB.id);
    }
    
    ArrayList<ExamroomsBean> tempList = new ArrayList<ExamroomsBean>(0);
    for(ExamroomsBean curEx : examRoomsResults)
    {
        tempList.add(curEx);
    }
    examRoomsResults.clear();
    examRoomsResults = new ArrayList<ExamroomsBean>(0);
    for(ExamroomsBean curEx : tempList)
    {
        if(curEx.deleted.equalsIgnoreCase("false"))
        {
            examRoomsResults.add(curEx);
        }
    }
    
    //retrieve appointments assigned to these examrooms
    for(ExamroomsBean curExRoom : examRoomsResults)
    {
        curExRoom.appointmentsList = DBH.getAppointmentsByExamRoomID(curExRoom.id);
    }
    
    //store examRoomsResults temporary
    session.setAttribute("examRoomsResults", examRoomsResults);

//    Date today=new Date();
//    String onDate=(today.getMonth()+1)+"/"+today.getDate()+"/"+(today.getYear()+1900);
//    response.sendRedirect("../patients.jsp?action=newAppoint&patid="+newAppBean.PB.id+"&onDate="+onDate);
    
    
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
    String onDate=sdf.format(new Date());
    response.sendRedirect("../patients.jsp?action=newAppoint&patid="+newAppBean.PB.id+"&onDate="+onDate);
}
else
{
    response.sendRedirect("../patients.jsp?results=invalidParams");
}
%>