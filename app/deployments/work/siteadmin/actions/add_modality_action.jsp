<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.ModalityBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
//retrieve DBH and AB from session
//DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
%>

<%
//get new site fields
request.setCharacterEncoding("UTF-8");

String name=request.getParameter("modalityName");
String manufacturer=request.getParameter("modalityManufacturer");
String serialNumber=request.getParameter("serialNumber");
String ipAddress=request.getParameter("ipAddress");
String aeTitle=request.getParameter("aeTitle");
String comments=request.getParameter("modalityComments");
String pacsConnection=request.getParameter("modalityPACS");
String type="";
if(request.getParameter("modalityType")!=null && request.getParameter("modalityType").length()>0)
{
    type=request.getParameter("modalityType");
}

String siteid=AB.SB.id;
String statusid;
String portable;

if (request.getParameter("modalityPortable").equalsIgnoreCase("modalityPortableYES")){
     portable = "1";
}else {
     portable = "0";
}

if (request.getParameter("modalityStatus").equalsIgnoreCase("modalityStatusYES")){
     statusid = "1";
}else {
     statusid = "0";
}

ModalityBean MB=new ModalityBean("",name, manufacturer, siteid, portable, statusid,comments,ipAddress,aeTitle,type);
MB.pacsConnection=pacsConnection;
MB.setSerialNumber(serialNumber);

if(MB!=null && MB.name!=null && MB.name.trim().length()>0)
{
    boolean stored=siteAdminBacking.insertNewModality(MB);

    if (stored==true)
    {
        siteAdminBacking.okMessage=langBacking.getLiteral("add_modality_ok");
       response.sendRedirect("../modalities.jsp");   
    }else
    {
        siteAdminBacking.errorMessage=langBacking.getLiteral("add_modality_failed");
       response.sendRedirect("../addNewModality.jsp?result=ModalitySaveError");   
    } 
}
else
{
    siteAdminBacking.infoMessage=langBacking.getLiteral("new_modality_required_fields");
    response.sendRedirect("../addNewModality.jsp");   
}
%>