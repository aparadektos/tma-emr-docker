
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
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
function checkEditDepartmentForm()
{
    document.getElementById("editDepartmentForm").submit();
}
</script>
    
<body>

    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "departments"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    
                    <%
                    if(siteAdminBacking!=null && siteAdminBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteAdminBacking.resetMessages();
                    
                    String selectedDepartmentId=request.getParameter("id");
                    siteAdminBacking.setSelectedDepartmentToEdit(siteAdminBacking.getDepartmentFromResultsById(selectedDepartmentId));
                    %>
                    
                    <div class="post" id="editDepartmentFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("edit_department") %></a>
                        </h2>
                        <div class="entry">
                            <%
                            if(siteAdminBacking.getSelectedDepartmentToEdit()!=null)
                            {
                            %>
                            <form id="editDepartmentForm" method="post" action="actions/edit_department_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <font color="red"><%= langBacking.getLiteral("name") %>:</font>
                                        </td>
                                        <td>
                                            <input name="departName" type="text" size="53" value="<%= siteAdminBacking.getSelectedDepartmentToEdit().getName() %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("comment") %>:</td>
                                        <td>
                                            <textarea name="departComment"  rows="2" cols="50"><%= siteAdminBacking.getSelectedDepartmentToEdit().getComments() %></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("active_department") %>:</td>
                                        <td>
                                            <%
                                            if(siteAdminBacking.getSelectedDepartmentToEdit().getActive().equalsIgnoreCase("false"))
                                            {
                                                out.println("<input type='radio' name='departActive' value='true'>"+langBacking.getLiteral("yes")+"</input>");
                                                out.println("<input type='radio' name='departActive' value='false' checked='true'>"+langBacking.getLiteral("no")+"</input>");
                                            }
                                            else
                                            {
                                                out.println("<input type='radio' name='departActive' value='true' checked='true'>"+langBacking.getLiteral("yes")+"</input>");
                                                out.println("<input type='radio' name='departActive' value='false'>"+langBacking.getLiteral("no")+"</input>");
                                            }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkEditDepartmentForm();"/>
                                    </td>
                                    </tr>
                                </table>
                            </form>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_department"));
                            }
                            %>
                        </div>
                    </div>
                </div>
		<!-- end #content -->
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="departments.jsp"><%= langBacking.getLiteral("all_departments") %></a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
		<!-- end #sidebar -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>

    </body>
    
    <script language="javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
    </script>
        
    
    
</html>