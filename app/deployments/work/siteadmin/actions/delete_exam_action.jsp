<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="tools.DBHelper"%>

<% 
    SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
    
   DBHelper DBH= new DBHelper();
   boolean done=DBH.deleteExamRoom(Integer.parseInt(request.getParameter("id")));
   if (done==true)
   {
       siteAdminBacking.okMessage=langBacking.getLiteral("delete_exam_room_ok");
     response.sendRedirect("../examinationRooms.jsp?result='ExamRoomDeleted'");        
   }
   else
   {
       siteAdminBacking.errorMessage=langBacking.getLiteral("delete_exam_room_failed");
     response.sendRedirect("../examinationRooms.jsp?result='ExamRoomDeleteError'");          
   }
%>
   
