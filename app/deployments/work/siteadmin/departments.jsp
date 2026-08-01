<%@page import="beans.DepartmentBean"%>
<%@page import="beans.ModalityTypeBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.modalityAvBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.ModalityBean"%>

<!-- Initializations -->
<%
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
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

<!-- Javascript functions  -->
<script language="javascript">
function checkNewDepartmentForm()
{
    document.getElementById("addModalityForm").submit();
}

function checkEditDepartmentForm()
{
    document.getElementById("editModalityForm").submit();
}

function confirmDepartmentDelete(departmentHash)
{
    if (confirm("<%= langBacking.getLiteral("delete_department_confirm") %>")) 
    {
        document.getElementById("departmentToDeleteHash").value=departmentHash;
        document.getElementById("deleteDepartmentForm").submit();
    }
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
		<div id="content" style="width:100%">
                    
                    <%
                    if(siteAdminBacking!=null && siteAdminBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteAdminBacking.resetMessages();
                    %>
                    
                    <div class="post" style="width:100%">
                        <table border="0" style="width:1000px;">
                            <tr>
                                <td>
                                    <h2 class="title">
                                        <a href="#"><%= langBacking.getLiteral("all_departments") %></a>
                                    </h2>
                                </td>
                                <td align="right" width="400px;">
                                    <a href="addNewDepartment.jsp">
                                        <input type="button" value="<%= langBacking.getLiteral("add_department") %>" onClick="javascript:checkEditModalityForm();"/>
                                    </a>
                                </td>
                            </tr>
                        </table>
                        <div class="entry">
                            <%
                            //show results
                            if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("AvailabilityError"))
                            {
                                out.println("<font color='red'>Availability cannot be stored!</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("AvailabilityAdded"))
                            {
                                out.println("<font color='green'>Availability stored successfully!</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("error"))
                            {
                                out.println("<font color='red'>Unexpected error!</font><br/><br/>");
                            }
                            %>
                            
                            <%
                            //retrieve all departments for this site 
                            ArrayList<DepartmentBean> allDepartmentsList = siteAdminBacking.getAllDepartmentsBySiteId();
                            if(allDepartmentsList!=null && allDepartmentsList.size()>0)
                            {
                            %>
                                <table id='departmentsTable' style='width:1000px;'></table>
                                <script type="text/javascript">
                                    $("#departmentsTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 10,
                                        allowColSizing: true,
                                        ensureColumnsPxWidth:true,
                                        data: [
                                    <%
                                    for(int i=0; i<allDepartmentsList.size(); i++)
                                    {
                                        DepartmentBean curDepart=allDepartmentsList.get(i);
                                        String activeStr=langBacking.getLiteral("no");
                                        if(curDepart.getActive().equalsIgnoreCase("true"))
                                        {
                                            activeStr=langBacking.getLiteral("yes");
                                        }
                                        
                                        String hrefs="<a href=\"editDepartment.jsp?id="+curDepart.getId()+"\"><img  src=\"../images/update.gif\" style=\"border:0px;\"></a>&nbsp;"
                                                    + "&nbsp;<a href=\"javascript:confirmDepartmentDelete("+curDepart.hashCode()+");\"><img src=\"../images/delete.gif\" style=\"border:0px;\"></a>&nbsp;";
                                        
                                        if(i<allDepartmentsList.size()-1)
                                        {
                                            out.println("['<b>"+curDepart.getName()+"</b>','"+curDepart.getComments()+"','"+curDepart.getDateTimeAddedStr()+"', '"+activeStr+"', '"+hrefs+"' ],");
                                        }
                                        else
                                        {
                                            out.println("['<b>"+curDepart.getName()+"</b>','"+curDepart.getComments()+"','"+curDepart.getDateTimeAddedStr()+"', '"+activeStr+"', '"+hrefs+"' ]");
                                        }
                                    }
                                    %>
                                        ],
                                        columns: [
                                                 { headerText: "<%= langBacking.getLiteral("name") %>" , width: "320px"}, 
                                                 { headerText: "<%= langBacking.getLiteral("comment") %>" , width: "320px"},
                                                 { headerText: "<%= langBacking.getLiteral("date_time") %>", width: "170px"},
                                                 { headerText: "<%= langBacking.getLiteral("active_department") %>", width: "90px"},
                                                 { headerText: "<%= langBacking.getLiteral("actions") %>", width: "100px"}
                                        ]
                                    });
                                </script>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_departments_found"));
                            }
                            %>
                            <br/>
                            <form id="deleteDepartmentForm" method="post" action="actions/delete_department_action.jsp">
                                <input type="hidden" id="departmentToDeleteHash" name="departmentToDeleteHash" value=""/>
                            </form>
                        </div>
                    </div>
                </div>
		<!-- end #content -->
<!--		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%//= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="#"><%//= langBacking.getLiteral("add_") %></a></li>
                            </ul>
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
    
    <script language="javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();

    </script>
        
    
    
</html>