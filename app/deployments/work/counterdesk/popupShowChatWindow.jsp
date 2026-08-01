
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../popupStyle.css" rel="stylesheet" type="text/css" media="screen"/>
        
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

<!-- Javascript functions  -->
<script language="javascript">
    
</script>
    
    <body >

    <div id="wrapper">
	
	<div id="page">
            <div id="page-bgtop">
                <div id="content">
                    <div class="post">
                        <div class="entry">
                            <%
                            String accId=request.getParameter("accId");
                            %>
                            <iframe src="siteDoctorReceivedMessages.jsp?accId=<%= accId %>" width="100%" height="390px" style="border:none;"></iframe>  <!-- border:none; -->
                        </div>
                    </div>

                </div>
                <form id="newMessageForm" method="post" action="actions/send_message_action.jsp">
                    <table border="0">
                        <tr>
                            <td>
                                <textarea name="newMessage" cols="45" rows="4"></textarea>
                            </td>
                            <td>
                                &nbsp;&nbsp;&nbsp;
                                <a href="#"><img src="../images/send.png" onclick="document.getElementById('newMessageForm').submit();" /></a>
                            </td>
                        </tr>
                    </table>
                    <input type="hidden" name="toAccountId" value="<%= accId %>"/>
                </form>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
            </div>
        </div>
            
    </div>
    
    </body>

    <!-- Javascript functions  -->
    <script language="javascript">
        $(":input[type='button'],:input[type='submit']").button(); 
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
    </script>

</html>