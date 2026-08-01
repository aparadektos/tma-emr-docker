<%@page import="beans.StisBean"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
//retrieve objects from session (if necessary)
HqAdminBacking hqAdminBacking = (HqAdminBacking)session.getAttribute("hqAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
//GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title><%= hqAdminBacking.getAllSettings().getParameter("htmlTitle") %></title>
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

<!-- Javascript functions  -->
<script language="javascript">

</script>
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "settings"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" style="width:100%">
                    
                    <%
                    if(hqAdminBacking!=null && hqAdminBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(hqAdminBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(hqAdminBacking!=null && hqAdminBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(hqAdminBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(hqAdminBacking!=null && hqAdminBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(hqAdminBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    hqAdminBacking.resetMessages();
                    %>
                    
                    <div class="post"  >
                        <!--
                        <form method="post" action="actions/save_settings_action.jsp"> 
                            <table border="0" style="width:1000px">
                                <tr>
                                    <td>
                                        <h2 class="title">
                                            <a href="#"><%= langBacking.getLiteral("settings") %></a>
                                        </h2>
                                    </td>
                                    <td align="right" width="400px;">
                                        <input type="submit" value="<%= langBacking.getLiteral("save") %>" />
                                    </td>
                                </tr>
                            </table>

                            <div class="entry">
                                <div id="accordion" style="width:1000px">
                                    <div>
                                        <h3><a href="#"><%= langBacking.getLiteral("Header titles") %></a></h3>
                                        <div>
                                            123
                                        </div>
                                    </div>
                                    <div>
                                        <h3><a href="#"><%= langBacking.getLiteral("Sites and Stis") %></a></h3>
                                        <div>
                                            123
                                        </div>
                                    </div>
                                    <div>
                                        <h3><a href="#"><%= langBacking.getLiteral("Logging and alerts") %></a></h3>
                                        <div>
                                            123
                                        </div>
                                    </div>
                                    <div>
                                        <h3><a href="#"><%= langBacking.getLiteral("jabber") %></a></h3>
                                        <div>
                                            456
                                        </div>
                                    </div>
                                    <div>
                                        <h3><a href="#"><%= langBacking.getLiteral("ldap") %></a></h3>
                                        <div>
                                            456
                                        </div>
                                    </div>
                                    <div>
                                        <h3><a href="#"><%= langBacking.getLiteral("Intervals") %></a></h3>
                                        <div>
                                            456
                                        </div>
                                    </div>
                                </div>
                            </div>
                                        
                            <br/>
                            <center>
                                <input type="submit" value="<%= langBacking.getLiteral("save") %>" />
                            </center>
                        </form>
                        -->
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
        $(document).ready(function () {
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $("#select1").wijdropdown();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
        $(":input[type='submit']").button();
        });
        
        $("#accordion").wijaccordion({
        header: "h3",
        requireOpenedPane: false,
        collapsible: true,
        selectedIndex: 5
        });
    </script>
    
    </body>
</html>