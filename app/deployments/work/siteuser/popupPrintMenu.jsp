
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
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
                            String appHash = request.getParameter("appHash");
                            appointmentsBean APPOINTMENT = null;
                            if(appHash!=null && appHash.length()>0)
                            {
                                APPOINTMENT = siteUserBacking.getAppointmentByHash(Integer.parseInt(appHash));
                            }
                            if(APPOINTMENT!=null)
                            {
                            %>
                            <table border="0" width="100%">
                                <tr>
                                    <td align="center" width="50%">
                                        <a href="printProselefsi.jsp?appointmentId=<%= APPOINTMENT.id %>" target="_blank">
                                            <input type="button" value="Προσέλευση Ραντεβού"/>
                                        </a>
                                    </td>
                                    <td align="center">
                                        <a href="printDeltio.jsp?appointmentId=<%= APPOINTMENT.id %>" target="_blank">
                                            <input type="button" value="Δελτίο Παροχής Υπηρεσιών"/>
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" height="20px">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <a href="printCancel.jsp?appointmentId=<%= APPOINTMENT.id %>" target="_blank">
                                            <input type="button" value="Ακύρωση Είσπραξης"/>
                                        </a>
                                    </td>
                                    <td align="center">
<!--                                        <a href="printProselefsi.jsp?appointmentId=" target="_blank">
                                            <input type="button" value="Ακύρωση (για Ασθενή)"/>
                                        </a>-->
                                    </td>
                                </tr>
                            </table>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_appointment"));
                            }
                            %>
                        </div>
                    </div>
                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
<!--                <center>
                    <a href="viewPatientHistory.jsp?patId=<%//= siteUserBacking.selectedPatientToViewHistory.id %>" target="_parent"><input type="button" value="Επιστροφή"/></a>
                </center>-->
            </div>
        </div>
            
    </div>
    
    </body>

    <!-- Javascript functions  -->
    <script language="javascript">
        $(":input[type='button']").button();
    </script>

</html>