
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="java.util.Date"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="beans.StisBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.ModalityBean"%>

<%
    //initializations
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");

//check login
if(consultantBacking!=null && consultantBacking.getAB()!=null && consultantBacking.getAB().RB!=null)
{
    if(consultantBacking.getAB().RB.roleName.equals("consultant")==false)
    {
        //empty session
        session.invalidate();

        //go to login again
        response.sendRedirect("../logout.jsp");
    }
}
else
{
    //empty session
    session.invalidate();
    
    //go to login again
    response.sendRedirect("../logout.jsp");
}
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title><%= GH.htmlTitle %></title>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../style.css" rel="stylesheet" type="text/css" media="screen"/>
        
        <!--  Table Grid LIBs  -->
        <!--jQuery References-->
        <script src="../wijmotools/external/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../wijmotools/external/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/cobalt/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
        <!--Sample Dependencies-->
        <script src="../wijmotools/explore/js/amplify.core.min.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/amplify.store.min.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/jquery.cookie.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/jquery.tmpl.min.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/swfobject.js" type="text/javascript"></script>
        <!--Wijmo Widgets JavaScript-->
        <script src="../wijmotools/Wijmo-Complete/js/jquery.wijmo-open.all.2.0.5.min.js" type="text/javascript"></script>
        <script src="../wijmotools/Wijmo-Complete/js/jquery.wijmo-complete.all.2.0.5.min.js" type="text/javascript"></script>
        <script src="../wijmotools/Wijmo-Complete/development-bundle/external/cultures/globalize.cultures.js" type="text/javascript"></script>
        
    </head>

<script language="javascript">
function refreshReqDate()
{
    window.location='myTeleAppointments.jsp?reqDateStr='+document.getElementById("previewDatePicker").value;
}
</script>
    
    <body >
        
    <div id="wrapper" >
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "videoCalls"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page" >
            <div id="page-bgtop" >
		<div id="content" style="width:850px; ">
                    
                    <%
                    if(consultantBacking!=null && consultantBacking.getErrorMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getErrorMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(consultantBacking!=null && consultantBacking.getOkMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getOkMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(consultantBacking!=null && consultantBacking.getInfoMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getInfoMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    consultantBacking.resetMessages();
                    
                    
                    String confCallee = consultantBacking.getAB().getSipConference();
                    String medicalCallee = consultantBacking.getAB().getSipMedical();
                    
                    %> 
                    <a href="https://vcon.tma.com.gr:5001/webclient" target="_blank"><input type="button" value="<%= langBacking.getLiteral("enter_video_conference_platform") %>"/></a>
                    
                    <br/>
                    <br/>
                    
                    <%= langBacking.getLiteral("video_conference_info") %>
                    
					<br/><br/>
               
                </div>               

            </div>
            <!-- end #content -->
            <div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    
    <script type="text/javascript">
       //$("#medicTabs").wijtabs();
       //$("#confTabs").wijtabs();
    
 		$(":input[type='button']").button();
    </script>
    
    </body>
    
</html>