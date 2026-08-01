
<%@page import="beans.MessageBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.util.Date"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="beans.StisBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.ModalityBean"%>

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
<!--        <meta http-equiv="refresh" content="5" />-->
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

function showChatWindow(accId)
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("emergency_contact") %>",
        width: 500, 
        height: 600, 
        modal: true,
        contentUrl: 'popupShowChatWindow.jsp?accId='+accId, 
        captionButtons: {
            pin: { visible: false },
            refresh: { visible: false },
            toggle: { visible: false },
            minimize: { visible: false },
            maximize: { visible: false }
        },
        autoOpen: true
    });
}
</script>
    
    <body>
        
        <div id="popup"></div>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "contact"); %>
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
                                    <h2 class="title"><a href="#"><%= langBacking.getLiteral("emergency_contact") %></a></h2>
                                </td>
                                <td align="right">
<!--                                    <input type="text" id="previewDatePicker" name="previewDatePicker" />-->
                                </td>
                                <td align="right" width="30px">
<!--                                    <a href="javascript:refreshReqDate();"><img src="../images/refresh1.png" width="25px" /></a>-->
                                </td>
                            </tr>
                        </table>
                        
                        <div class="entry">
                            
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#messagesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 50,
                                    allowColSizing: true,
                                    data: [
                                <%
                                ArrayList<String> senderList=new ArrayList<String>(0);
                                ArrayList<MessageBean> latestReceivedMessages = counterdeskBacking.getLatestReceivedMessages();
                                String row="";
                                for(MessageBean curMesg : latestReceivedMessages)
                                {
                                    if(senderList.contains(curMesg.getFromAccountBean().id)==false)
                                    {
                                        String sender="";
                                        if(curMesg.getFromAccountBean()!=null && curMesg.getFromAccountBean().docBean!=null &&
                                           curMesg.getFromAccountBean().SB!=null)
                                        {
                                            sender+=curMesg.getFromAccountBean().docBean.name+" "+curMesg.getFromAccountBean().docBean.surname+" ("+curMesg.getFromAccountBean().docBean.specialtyBean.getNameByLang(langBacking.lang) +")<br/>";
                                            sender+=langBacking.getLiteral("stia")+": "+curMesg.getFromAccountBean().SB.name;
                                        }
                                        else if(curMesg.getFromAccountBean()!=null && curMesg.getFromAccountBean().getParamedicBean()!=null &&
                                           curMesg.getFromAccountBean().SB!=null)
                                        {
                                            sender+=curMesg.getFromAccountBean().getParamedicBean().getFullName()+" ("+curMesg.getFromAccountBean().getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")<br/>";
                                            sender+=langBacking.getLiteral("stia")+": "+curMesg.getFromAccountBean().SB.name;
                                        }
//                                        String url="<a href=\"javascript:showChatWindow("+curMesg.getFromAccountBean().id+");\">"+curMesg.getMessage()+"</a>";
                                        String url="<a href=\"javascript:showChatWindow("+curMesg.getFromAccountBean().id+");\"><img src=\"../images/contact_bubble.png\" /></a>";
                                        row+="['"+curMesg.getDateAndTimeStr(langBacking.getDateFormat())+"','"+sender+"','"+url+"'],";
                                        senderList.add(curMesg.getFromAccountBean().id);
                                    }
                                }
                                if(row.endsWith(","))
                                {
                                    row=row.substring(0, row.length()-1);
                                }
                                out.println(row);
                                %>
                                    ],
                                    columns: [
                                             { headerText: "<%= langBacking.getLiteral("date_time") %> " },
                                             { headerText: "<%= langBacking.getLiteral("sender") %> " },
                                             { headerText: "<%= langBacking.getLiteral("actions") %> " }
                                    ],
                                    cellStyleFormatter: function (args) {
                                        args.$cell.css("textAlign", "center");
                                        // args.row.type,   args.$cell[0].cellIndex,    
                                    }
                                });
                            });
                            </script>
                            
                            <table id='messagesTable' style="width:980px;"></table>
                        </div>               
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
        
    </script>
    
    </body>
    
</html>