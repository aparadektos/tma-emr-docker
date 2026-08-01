<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>

<%
request.setCharacterEncoding("UTF-8");

String id=request.getParameter("examid");
String name=request.getParameter("examName");
String examModalityID=request.getParameter("exammodalityid");

String examRoomDepartId=request.getParameter("examRoomDepartId");

if(examModalityID!=null && examModalityID.equalsIgnoreCase("none"))
{
    examModalityID="";
}
String examDescription=request.getParameter("examDescription");
String examSiteid=siteAdminBacking.AB.SB.id;
String examAvailable=request.getParameter("examAvailable");

String existingExamRoomIdWithSameName=siteAdminBacking.examRoomNameExists(name);

if(existingExamRoomIdWithSameName!=null && existingExamRoomIdWithSameName.equals(id)==false)
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("add_exam_room_same_name");
    response.sendRedirect("../examinationRooms.jsp?result=ExamRoomSaveError");
}
else
{
    ExamroomsBean ERB=new ExamroomsBean(id,examSiteid,name,examModalityID,examDescription,examAvailable);

    if(examRoomDepartId.equalsIgnoreCase("none"))
    {
        ERB.getDepartmentBean().setId("");
    }
    else
    {
        ERB.getDepartmentBean().setId(examRoomDepartId);
    }

    boolean updated=DBH.updateExamRoom(ERB);

    if (updated==true)
    {
        siteAdminBacking.okMessage=langBacking.getLiteral("edit_exam_room_ok");
       response.sendRedirect("../examinationRooms.jsp?result=ExamRoomEdited");   
    }else
    {
        siteAdminBacking.errorMessage=langBacking.getLiteral("edit_exam_room_failed");
       response.sendRedirect("../examinationRooms.jsp?result=ExamRoomEditError");        
    } 
}
%>