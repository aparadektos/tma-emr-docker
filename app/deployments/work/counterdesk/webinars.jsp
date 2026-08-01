
<%@page import="java.util.ArrayList"%>
<%@page import="beans.WebinarBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%
    //initializations
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");

//check login
if(counterdeskBacking!=null && counterdeskBacking.getAB()!=null && counterdeskBacking.getAB().RB!=null)
{
    if(counterdeskBacking.getAB().RB.roleName.equals("counterdesk")==false)
    {
        //empty session
        session.invalidate();

        //go to login again
        response.sendRedirect("../logout.jsp");
    }
}
else
{
    //empty session
    session.invalidate();
    
    //go to login again
    response.sendRedirect("../logout.jsp");
}
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

function showWebinarDetails(webinarHash)
{
    $("#popup").wijdialog({ 
        title: "Προβολή στοιχείων Webinar",
        width: 500, 
        height: 300, 
        modal: true,
        contentUrl: 'popupShowWebinarDetails.jsp?webinarHash='+webinarHash, 
        captionButtons: {
            pin: { visible: false },
            refresh: { visible: true },
            toggle: { visible: false },
            minimize: { visible: true },
            maximize: { visible: true }
        },
        autoOpen: true
    });
}

function confirmWebinarDelete(webHash)
{
    if(confirm("<%= langBacking.getLiteral("delete_webinar_confirm") %>"))
    {
        document.getElementById("webinarHash").value=webHash;
        document.getElementById("deleteWebinarForm").submit();
    }
}
</script>
    
    <body>
        
        <div id="popup"></div>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "webinars"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" style="width:100%">
                    
                    <%
                    if(counterdeskBacking!=null && counterdeskBacking.getErrorMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(counterdeskBacking.getErrorMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(counterdeskBacking!=null && counterdeskBacking.getOkMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(counterdeskBacking.getOkMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(counterdeskBacking!=null && counterdeskBacking.getInfoMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(counterdeskBacking.getInfoMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    counterdeskBacking.resetMessages();
                        
                    %>    
                    <div class="post">
                        <table border="0" style="width:980px;">
                            <tr>
                                <td align="left">
                                    <h2 class="title"><a href="#"><%= langBacking.getLiteral("webinars") %></a></h2>
                                </td>
                                <td align="right">
                                    <a href="newWebinar.jsp">
                                        <input type="button" value="<%= langBacking.getLiteral("new_webinar") %>" />
                                    </a>
                                </td>
                            </tr>
                        </table>
                        
                        <div class="entry">
                            
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#webinarsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 35,
                                    allowColSizing: true,
                                    ensureColumnsPxWidth:true,
                                    data: [
                                <%
                                ArrayList<WebinarBean> webinarsList=counterdeskBacking.getAllWebinars();
                                String rows="";
                                for(WebinarBean curWebinar : webinarsList)
                                {
                                    rows+="['"+curWebinar.getStartDateStr(langBacking.getDateFormat())+"<br/>"+curWebinar.getStartEndTimeStr()+"', "
                                        + "'"+curWebinar.getType()+" <br/><br/><b>"+langBacking.getLiteral("organizer")+"</b><br/>"+curWebinar.getOrganizer()+" ', "    
                                        //+ "'"+curWebinar.getSubject()+" <br/><br/><b>"+langBacking.getLiteral("organizer")+"</b><br/>"+curWebinar.getOrganizer()+" ', "
                                        + "'<b>"+langBacking.getLiteral("subject")+"</b>: "+curWebinar.getSubject()+"<br/><br/><p align=\"justify\">"+curWebinar.getDescription()+"</p>', "
                                        + "'"+curWebinar.getParticipants()+"',"
                                        + "'<a href=\"editWebinar.jsp?webinarId="+curWebinar.getId()+"\"><img src=\"../images/edit2.png\" width=\"24px\"/></a> &nbsp; <a href=\"javascript:confirmWebinarDelete("+curWebinar.hashCode()+");\"><img src=\"../images/delete.gif\" width=\"25px\"/></a>'],";
                                }
                                if(rows.endsWith(","))
                                {
                                    rows=rows.substring(0, rows.length()-1);
                                }
                                out.println(rows);
                            %>
                                    ],
                                    columns: [
                                             { headerText: "<%= langBacking.getLiteral("date_time") %> ", width:"100px" },
                                             { headerText: "<%= langBacking.getLiteral("type") %> - <%= langBacking.getLiteral("organizer") %>" },
                                             { headerText: "<%= langBacking.getLiteral("subject") %> - <%= langBacking.getLiteral("description") %> " },
                                             { headerText: "<%= langBacking.getLiteral("participants") %> ", width:"200px" },
                                             { headerText: "<%= langBacking.getLiteral("actions") %> " }
                                    ],
                                    cellStyleFormatter: function (args) {
                                        args.$cell.css("textAlign", "center");
                                        // args.row.type,   args.$cell[0].cellIndex,    
                                    }
                                });
                            });
                            </script>
                            
                            <table id='webinarsTable' style="width:980px;"></table>
                        </div>
                    </div>               
                    
                    <form name="deleteWebinarForm" id="deleteWebinarForm" method="post" action="actions/delete_webinar_action.jsp">
                        <input type="hidden" name="webinarHash" id="webinarHash"/>
                    </form>
                    
                </div>
		<!-- end #content -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    
    <script type="text/javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $("#select").wijdropdown();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
    </script>
    
    </body>
    
</html>