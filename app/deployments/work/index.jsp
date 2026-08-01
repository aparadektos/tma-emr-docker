<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%
GlobalHelper GH=new GlobalHelper();

LanguageBacking langBacking = new LanguageBacking();

String lang = request.getParameter("lang");
if(lang!=null && lang.trim().length()>0)
{
    langBacking.loadLiteralsByLanguage(lang.trim());
}
else
{
    langBacking.loadLiteralsByLanguage("greek");
}

session.setAttribute("langBacking",langBacking);
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title><%= GH.headerTitle %></title>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="style.css" rel="stylesheet" type="text/css" media="screen"/>
        
        <!--  Table Grid LIBs  -->
        <!--jQuery References-->
        <script src="wijmotools/external/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="wijmotools/external/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
        <!--Sample Dependencies-->
        <script src="wijmotools/explore/js/amplify.core.min.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/amplify.store.min.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/jquery.cookie.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/jquery.tmpl.min.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/swfobject.js" type="text/javascript"></script>
        <!--Wijmo Widgets JavaScript-->
        <script src="wijmotools/Wijmo-Complete/js/jquery.wijmo-open.all.2.0.5.min.js" type="text/javascript"></script>
        <script src="wijmotools/Wijmo-Complete/js/jquery.wijmo-complete.all.2.0.5.min.js" type="text/javascript"></script>
        <script src="wijmotools/Wijmo-Complete/development-bundle/external/cultures/globalize.cultures.js" type="text/javascript"></script>
    </head>

    <!--    Javascript functions  -->
<script language="javascript">
function checkLoginForm()
{
    //check fields
    
    document.getElementById("loginForm").submit();
}
</script>
    
    
    <body>
        
        <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "home"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    
                    <div class="post">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("login_page") %></a>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <a href="index.jsp?lang=english"><img src="images/en.png"/></a>
                            &nbsp;
                            <a href="index.jsp?lang=greek"><img src="images/el.gif" width="21px"/></a>
                        </h2>
                        <div class="entry">
<%
if(request.getParameter("login")!=null && request.getParameter("login").equals("failed"))
{
%>
<font color="red"><%= langBacking.getLiteral("login_failed") %></font>
<br/><br/>
<%
}
%>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                            $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
                            $("#wijmo-button").button();
                            });
                            </script>
                            <form id="loginForm" method="post" action="actions/login_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("username") %>
                                        </td>
                                        <td><input id="textbox" type="text" name="username" value=""/></td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("password") %>
                                        </td>
                                        <td><input id="textbox" type="password" name="password" value=""/></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center">
                                            <input id="wijmo-button" type="button" value="<%= langBacking.getLiteral("login") %>" onClick="javascript:checkLoginForm();"/>
                                        </td>
                                    </tr>
                                    
                                </table>
                            </form>
                        </div>
                    </div>
                    <font color="white">Deployment date: <%= GH.deployDate %></font>
                </div>
		<!-- end #content -->
<!--		<div id="sidebar">
                    <ul>
                        <li>
                            <h2>submenu</h2>
                            <ul>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                            </ul>
                        </li>
                        <li>
                            <h2>useful</h2>
                            <p>Thank you for downloading this template. This or any other template  is  free for personal use, but you must leave our link on this page. </p>
                        </li>
                    </ul>
                </div>-->
		<!-- end #sidebar -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    
    </body>
    
    <script type="text/javascript">
        $("#langSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
    </script>
</html>