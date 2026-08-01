<%@page import="beans.DepartmentBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="beans.ExamroomsBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
//retrieve DBH and AB from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>


<%
request.setCharacterEncoding("UTF-8");

String siteName=DBH.getSiteByID(AB.SB.id).name;
String examSiteID=AB.SB.id;
String examName=request.getParameter("examName");
String examCartID=request.getParameter("newExamCartId");
String examDescription=request.getParameter("examDescription");
String newExamRoomDepartId=request.getParameter("newExamRoomDepartId");
String examAvailable="";
if(request.getParameter("examAvailable")!=null && request.getParameter("examAvailable").length()>0)
{
    examAvailable=request.getParameter("examAvailable");
}

// store the new examination room to the database

if (examCartID.equalsIgnoreCase("none")){
    examCartID="-1";
}

DepartmentBean selectedDepartment = new DepartmentBean();
if (newExamRoomDepartId.equalsIgnoreCase("none")==false)
{
    selectedDepartment.setId(newExamRoomDepartId);
}

String existingExamRoomIdWithSameName=siteAdminBacking.examRoomNameExists(examName);
if(existingExamRoomIdWithSameName!=null)
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("add_exam_room_same_name");
    response.sendRedirect("../examinationRooms.jsp?result=ExamRoomSaveError");
}
else
{
    ExamroomsBean ERB=new ExamroomsBean("",examSiteID,examName,examCartID,examDescription,examAvailable);
    ERB.setDepartmentBean(selectedDepartment);

    boolean stored=DBH.insertNewExamRoom(ERB);

    if (stored==true)
    {
        siteAdminBacking.okMessage=langBacking.getLiteral("add_exam_room_ok");
       response.sendRedirect("../examinationRooms.jsp?result=newExamRoomAdded");   
    }else
    {
        siteAdminBacking.errorMessage=langBacking.getLiteral("add_exam_room_failed");
       response.sendRedirect("../examinationRooms.jsp?result=ExamRoomSaveError");   
    }
}
%>