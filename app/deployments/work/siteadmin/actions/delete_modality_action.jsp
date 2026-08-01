<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="tools.DBHelper"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");

   DBHelper DBH= new DBHelper();
   String deleted=DBH.deleteModality(Integer.parseInt(request.getParameter("id")));
   if (deleted.equals("ModalityDeleted"))
   {
       siteAdminBacking.okMessage=langBacking.getLiteral("delete_modality_ok");
     response.sendRedirect("../modalities.jsp?result='ModalityDeleted'");        
   }
   else
   {
       siteAdminBacking.errorMessage=langBacking.getLiteral("delete_modality_failed");
     response.sendRedirect("../modalities.jsp?result='ModalityDeleteError'");          
   }
%>
   
