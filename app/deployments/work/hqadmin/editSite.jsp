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
function checkEditSiteForm()
{
    //alert("test");
    document.getElementById("editSiteForm").submit();
}
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
                    <%
                    siteBean editSB=null;
                    if(request.getParameter("id")!=null && request.getParameter("id").length()>0)
                    {
                        editSB=hqAdminBacking.getSiteById(request.getParameter("id"));
                    }
                    if(editSB!=null && editSB.getId()!=null && editSB.getId().length()>0)
                    {
                    %>
                    <div class="post" id="editSiteFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("edit_site") %></a></h2>
                        <div class="entry">
                            
                            <form id="editSiteForm" method="post" action="actions/edit_site_action.jsp">
                                <input type="hidden" name="siteid" value="<%=editSB.id%>"/>
                                <table border="0">
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                        <td>
                                            <input value='<%=editSB.name%>' name="siteName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("flag") %>:</td>
                                        <td>
                                            <select id="flagId" name="flagId">
                                            <%
                                            ArrayList<FlagBean> allFlags = hqAdminBacking.getAllFlags(langBacking.lang);
                                            for(FlagBean curFlag : allFlags)
                                            {
                                                if(curFlag.getId().equals(editSB.getFlagBean().getId()))
                                                {
                                                    out.println("<option selected='true' value='"+curFlag.getId()+"'>"+curFlag.getNameByLang(langBacking.lang)+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='"+curFlag.getId()+"'>"+curFlag.getNameByLang(langBacking.lang)+"</option>");
                                                }
                                            }
                                            %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("address") %>:</td>
                                        <td>
                                            <textarea name="siteAddress" id="area" rows="2" cols="50"><%=editSB.address%></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("contact") %>:</td>
                                        <td>
                                            <textarea name="siteContact" id="area" rows="2" cols="50"><%=editSB.contact%></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("site_print_title") %>:</td>
                                        <td>
                                            <textarea name="sitePrintTitle" id="area" rows="4" cols="50"><%=editSB.getSitePrintTitle() %></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkEditSiteForm();"/>
                                    </td>
                                    </tr>
                                </table>
                            </form>
                            
                        </div>
                    </div>
                    <%
                    }
                    else
                    {
                        out.println(langBacking.getLiteral("invalid_selection"));
                    }
                    %>
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
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();
    
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