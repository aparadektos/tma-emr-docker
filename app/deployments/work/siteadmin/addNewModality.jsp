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
function checkNewModalityForm()
{
    document.getElementById("addModalityForm").submit();
}
</script>
    
<body>

    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "modalities"); %>
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
                    %>
                    
                    <div class="post" id="newModalityFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("add_modality") %></a>
                        </h2>
                        <div class="entry">
                            <form id="addModalityForm" method="post" action="actions/add_modality_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <font color="red"><%= langBacking.getLiteral("name") %>:</font>
                                        </td>
                                        <td>
                                            <input name="modalityName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("manufacturer") %>:</td>
                                        <td>
                                            <textarea name="modalityManufacturer" id="area" rows="2" cols="50"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" >
                                            <font color="red"><%= langBacking.getLiteral("type") %>:</font>
                                        </td>
                                        <td>
                                            <select id="modalityTypeSelect" style="width: 450px;" name="modalityType">
                                                <%
                                                ArrayList<ModalityTypeBean> modalityTypes = siteAdminBacking.getAllModalityTypes();
                                                for(ModalityTypeBean modType : modalityTypes)
                                                {
                                                    out.println("<option value='"+modType.getName()+"'>"+modType.getName()+" | "+modType.getDescription(langBacking.lang)+"</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("portable") %>:</td>
                                        <td>
                                            <input type="radio" name="modalityPortable" id="modalityPortable" value="modalityPortableYES" checked="true"><%= langBacking.getLiteral("yes") %></input>
                                            <input type="radio" name="modalityPortable" id="modalityPortable" value="modalityPortableNO"><%= langBacking.getLiteral("no") %></input>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("status") %>:</td>
                                        <td>
                                            <input type="radio" name="modalityStatus" id="modalityStatus" value="modalityStatusYES" checked="true"><%= langBacking.getLiteral("available") %></input>
                                            <input type="radio" name="modalityStatus" id="modalityStatus" value="modalityStatusNO"><%= langBacking.getLiteral("not_available") %></input>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("pacs_communication") %>:</td>
                                        <td>
                                            <input type="radio" name="modalityPACS" value="yes" checked="true"><%= langBacking.getLiteral("yes") %></input>
                                            <input type="radio" name="modalityPACS" value="no"><%= langBacking.getLiteral("no") %></input>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("serial_number") %>:</td>
                                        <td>
                                            <input name="serialNumber" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("ip_address") %>:</td>
                                        <td>
                                            <input name="ipAddress" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("ae_title") %>:</td>
                                        <td>
                                            <input name="aeTitle" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("comment") %>:</td>
                                        <td>
                                            <textarea name="modalityComments" id="area" rows="3" cols="50"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkNewModalityForm();"/>
                                    </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                    </div>
                </div>
		<!-- end #content -->
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="javascript:showNewModalityForm();"><%= langBacking.getLiteral("add_modality") %></a></li>
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
        $("#select1").wijdropdown();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
    
        $("#modalityTypeSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });


    </script>
        
    
    
</html>