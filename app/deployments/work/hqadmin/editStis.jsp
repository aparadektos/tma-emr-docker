<%@page import="beans.StisBean"%>
<%@page import="beans.roleBean"%>
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
		<div id="content">
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
                    
                    String selectedStisId = request.getParameter("stisId");
                    if(selectedStisId!=null && selectedStisId.length()>0)
                    {
                        for(StisBean curStis : hqAdminBacking.getAllStisResults())
                        {
                            if(selectedStisId.equals(curStis.getId()))
                            {
                                hqAdminBacking.setSelectedStisBeanToEdit(curStis);
                                break;
                            }
                        }
                    }
                    
                    %>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("edit_stis") %></a></h2>
                        <div class="entry">
                            <%
                            if(hqAdminBacking.getSelectedStisBeanToEdit()!=null && hqAdminBacking.getSelectedStisBeanToEdit().getId().length()>0)
                            {
                            %>
                            <form id="editStisForm" method="post" action="actions/edit_stis_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                            <%= langBacking.getLiteral("title") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="stisTitle" value="<%= hqAdminBacking.getSelectedStisBeanToEdit().getTitle() %>" id="textbox" type="text" size="42" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("hospital") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="stisHospital" value="<%= hqAdminBacking.getSelectedStisBeanToEdit().getNosokomeio() %>" id="textbox" type="text" size="42" required/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("ip_address") %>:
                                        </td>
                                        <td>
                                            <input name="stisIpAddress" value="<%= hqAdminBacking.getSelectedStisBeanToEdit().getIpAddress() %>" id="textbox" type="text" size="42"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("comment") %>:</td>
                                        <td>
                                            <textarea name="stisComments" id="area" rows="3" cols="40"><%= hqAdminBacking.getSelectedStisBeanToEdit().getComments() %></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" colspan="3">
                                            <br/>
                                            <i><b><%= langBacking.getLiteral("hospital_information") %></b></i>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("full_title") %>:
                                        </td>
                                        <td>
                                            <input name="stisHospitalFullTitle" value="<%= hqAdminBacking.getSelectedStisBeanToEdit().getNosokomeioFullTitle() %>" id="textbox" type="text" size="42" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("phones") %>:
                                        </td>
                                        <td>
                                            <input name="stisHospitalPhones" value="<%= hqAdminBacking.getSelectedStisBeanToEdit().getNosokomeioPhones() %>" id="textbox" type="text" size="42" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("emails") %>:
                                        </td>
                                        <td>
                                            <input name="stisHospitalEmails" value="<%= hqAdminBacking.getSelectedStisBeanToEdit().getNosokomeioEmails() %>" id="textbox" type="text" size="42" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("address") %>:</td>
                                        <td>
                                            <textarea name="stisHospitalAddress" id="area" rows="3" cols="40"><%= hqAdminBacking.getSelectedStisBeanToEdit().getNosokomeioAddress() %></textarea>
                                        </td>
                                    </tr>    
                                    <tr>
                                        <td align="center" colspan="3">
                                            <input type="submit" value="<%= langBacking.getLiteral("save") %>" />
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_selection"));
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
                                <li><a href="stis.jsp"><%= langBacking.getLiteral("all_stis") %></a></li>
                                <li><a href="newStis.jsp"><%= langBacking.getLiteral("add_stis") %></a></li>
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

$(document).ready(function () {
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button'],:input[type='submit']").button();
});

</script>
    
</html>