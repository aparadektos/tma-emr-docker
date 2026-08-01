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
function checkNewSiteForm()
{
    //alert("test");
    document.getElementById("addSiteForm").submit();
}

function checkEditSiteForm()
{
    //alert("test");
    document.getElementById("editSiteForm").submit();
}

function showNewSiteForm()
{
    document.getElementById("newSiteFormDiv").style.display = "inline";
    document.getElementById("editSiteFormDiv").style.display = "none";
}

function confirmStisDelete(stisHash)
{
    var r=confirm("<%= langBacking.getLiteral("delete_stis_confirm") %>");
    if (r==true)
    {
        window.location="actions/delete_stis_action.jsp?stisHash="+stisHash;
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
            <% request.setAttribute("target", "stis"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" style="width:100%">
                    
                    <div class="post"  >
                        <table border="0" style="width:1000px;">
                            <tr>
                                <td>
                                    <h2 class="title">
                                        <a href="#"><%= langBacking.getLiteral("stis_title") %></a>
                                    </h2>
                                </td>
                                <td align="right" width="400px;">
                                    <a href="newStis.jsp">
                                        <input type="button" value="<%= langBacking.getLiteral("add_stis") %>" />
                                    </a>
                                </td>
                            </tr>
                        </table>
                        
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
                            //retrieve all stis
                            ArrayList<StisBean> SBList=hqAdminBacking.getAllStis();
                            if(SBList!=null && SBList.size()>0)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#stisTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    ensureColumnsPxWidth:true,
                                    data: [
                            <%
                                for(int i=0; i<SBList.size(); i++)
                                {
                                    StisBean curStisBean=SBList.get(i);
                                    String actions="<a href=\"editStis.jsp?stisId="+curStisBean.getId()+"\"><img src=\"../images/edit2.png\" width=\"26px\" /></a>";
                                    actions+="&nbsp;&nbsp;";
                                    actions+="<a href=\"javascript:confirmStisDelete("+curStisBean.hashCode()+");\"><img src=\"../images/delete.gif\" width=\"25px\" /></a>";
                                    if(i<SBList.size()-1)
                                    {
                                        out.println("['"+curStisBean.getTitle()+"','"+curStisBean.getNosokomeio()+"<br/>"+curStisBean.getNosokomeioFullTitle()+"', '"+curStisBean.getNosokomeioPhones()+"<br/>"+curStisBean.getNosokomeioEmails()+"<br/>"+curStisBean.getNosokomeioAddress()+"', '"+curStisBean.getComments()+"', '"+actions+"'],");
                                    }
                                    else
                                    {
                                        out.println("['"+curStisBean.getTitle()+"','"+curStisBean.getNosokomeio()+"<br/>"+curStisBean.getNosokomeioFullTitle()+"', '"+curStisBean.getNosokomeioPhones()+"<br/>"+curStisBean.getNosokomeioEmails()+"<br/>"+curStisBean.getNosokomeioAddress()+"', '"+curStisBean.getComments()+"', '"+actions+"']");
                                    }
                                }
                            %>
                            ],
                            columns: [
                                { headerText: "<%= langBacking.getLiteral("title") %>" }, 
                                { headerText: "<%= langBacking.getLiteral("hospital") %>" , width:"300px" }, 
                                { headerText: "<%= langBacking.getLiteral("contact") %>" , width:"250px"}, 
                                { headerText: "<%= langBacking.getLiteral("comment") %>" , width:"280px"}, 
                                { headerText: " " , width:"100px"}
                            ]
                            });
                        });
                        </script>
                            <%
                                out.println("<table id='stisTable' style='width:1000px;'>");
                                out.println("</table>");
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_stis_found"));
                            }
                            %>
                            
                        </div>
                    </div>
                    
                </div>
		<!-- end #content -->
                
                <!--
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%//= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="stis.jsp"><%//= langBacking.getLiteral("all_stis") %></a></li>
                                <li><a href="newStis.jsp"><%//= langBacking.getLiteral("add_stis") %></a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                -->
		<!-- end #sidebar -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    </body>
</html>