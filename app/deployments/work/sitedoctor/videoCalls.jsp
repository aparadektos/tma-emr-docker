
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="beans.TeleAppointmentBean"%>
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
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

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
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
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
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "videoCalls"); %>
            <!--jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" style="width:1000px; ">
                    
                    <%
                    if(siteDoctorBacking!=null && siteDoctorBacking.getErrorMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.getErrorMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteDoctorBacking!=null && siteDoctorBacking.getOkMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.getOkMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteDoctorBacking!=null && siteDoctorBacking.getInfoMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.getInfoMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteDoctorBacking.resetMessages();
                    
                    String confCaller = request.getParameter("confCaller");
                    String medicalCaller = request.getParameter("medicalCaller");
                    String confCallee = request.getParameter("confCallee");
                    String medicalCallee = request.getParameter("medicalCallee");
                    String jabberFlag = siteDoctorBacking.getAllSettings().getParameter("jabber");
                    %>  
                    
                    <table border="0" style="width:1100px;">
                        <tr>
                            <td width="50%" valign="top">
                                <div id="medicTabs">
                                    <ul>
                                        <li><a href="#medicTab1">Medical Video</a></li>
                                    </ul>
                                    <div id="medicTab1">
                                        <center>
                                            <iframe width="550" height="500" src="../JSSIPClient/consultantOneWayMinfied.html?<%= medicalCallee+"&"+medicalCaller %>&" allow='microphone; camera'></iframe>
                                        </center>
                                    </div>
                                </div>
                            </td>
                            <td width="50%" valign="top">
                                <div id="confTabs">
                                    <ul>
                                        <li><a href="#confTab1">Video Conference</a></li>
                                    </ul>
                                    <div id="confTab1">
                                        <center>
                                            <iframe width="550" height="500" src="../JSSIPClient/consultantMinfied.html?<%= confCallee+"&"+confCaller %>&" allow='microphone; camera'></iframe>
                                        </center>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                    
                    
                    <!--<iframe src="<//%= iframeUrl %>" width="1200px" height="450px" frameborder="0"></iframe>-->
                            
                       
                    
                </div>
		<!-- end #content -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    
    <script type="text/javascript">
       $("#medicTabs").wijtabs();
       $("#confTabs").wijtabs();
    </script>
    
    </body>
    
</html>