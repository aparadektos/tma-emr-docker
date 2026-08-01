<%@page import="beans.FlagBean"%>
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
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
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

function confirmSiteDelete(siteID)
{
    var r=confirm("<%= langBacking.getLiteral("delete_site_confirm") %>");
    if (r==true)
    {
        window.location="actions/delete_site_action.jsp?sid="+siteID;
    }
    else
    {
        //alert("You pressed Cancel!");
    }
}
</script>

<!-- javascript pou prepei na paiksei molis fortwthei h selida -->
<script id="scriptInit" type="text/javascript">
$(document).ready(function () {
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();
});
</script>
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "sites"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    <!-- div me ola ta sites -->
                    <div class="post">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("sites_full_title") %></a></h2>
                        <div class="entry">
                            
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

                            <%
                            //retrieve all sites
                            ArrayList<siteBean> SBList=hqAdminBacking.getAllSites();
                            if(SBList!=null && SBList.size()>0)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#sitesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 20,
                                    allowColSizing: true,
                                    ensureColumnsPxWidth:true,
                                    data: [
                            <%
                                for(int i=0; i<SBList.size(); i++)
                                {
                                    siteBean curSite=SBList.get(i);
                                    if(i<SBList.size()-1)
                                    {
                                        out.println("['"+curSite.name+"','"+curSite.address+"<br/><br/>"+curSite.contact+"', '"+curSite.getFlagBean().getNameByLang(langBacking.lang)+"', '"+curSite.getSitePrintTitleInRow()+"', '<a href=\"editSite.jsp?id="+curSite.id+"\"><img src=\"../images/update.gif\"/></a>&nbsp;&nbsp;<a href=\"javascript:confirmSiteDelete("+curSite.id+");\"><img src=\"../images/delete.gif\"/></a>'],");
                                    }
                                    else
                                    {
                                        out.println("['"+curSite.name+"','"+curSite.address+"<br/><br/>"+curSite.contact+"', '"+curSite.getFlagBean().getNameByLang(langBacking.lang)+"', '"+curSite.getSitePrintTitleInRow()+"', '<a href=\"editSite.jsp?id="+curSite.id+"\"><img src=\"../images/update.gif\"/></a>&nbsp;&nbsp;<a href=\"javascript:confirmSiteDelete("+curSite.id+");\"><img src=\"../images/delete.gif\"/></a>']");
                                    }
                                }
                            %>
                            ],
                            columns: [
                                { headerText: "<%= langBacking.getLiteral("name") %>", width:"180px" }, 
                                { headerText: "<%= langBacking.getLiteral("address") %> / <%= langBacking.getLiteral("contact") %>" , width:"180px"}, 
                                { headerText: "<%= langBacking.getLiteral("flag") %>" , width:"180px"}, 
                                { headerText: "<%= langBacking.getLiteral("site_print_title") %>", width:"180px" }, 
                                { headerText: " ", width:"80px"}
                            ]
                            });
                        });
                        </script>
                            <%
                                out.println("<table id='sitesTable'>");
                                out.println("</table>");
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_sites_found"));
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
                                <li><a href="sites.jsp"><%= langBacking.getLiteral("all_sites") %></a></li>
                                <li><a href="addNewSite.jsp"><%= langBacking.getLiteral("add_site") %></a></li>
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
    
<script type="text/javascript">
$("#flagId").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});
</script>
    
    
</html>