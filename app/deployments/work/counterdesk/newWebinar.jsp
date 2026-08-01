
<%@page import="java.util.Calendar"%>
<%@page import="beans.siteBean"%>
<%@page import="beans.StisBean"%>
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
    function selectAll(type)
    {
        var inputs = document.getElementsByTagName("input");
        //alert(inputs.length)
        for(var i = 0; i < inputs.length; i++) 
        {
            if(inputs[i].type === "checkbox" && (inputs[i].name).indexOf(type)===0)
            {
                inputs[i].checked = true;
            }  
        }
        
        location.reload(false); //reloads page from browser's cache. true->reloads page from server.....
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
                                    <h2 class="title"><a href="#"><%= langBacking.getLiteral("new_webinar") %></a></h2>
                                </td>
                                <td align="right">
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <div class="entry">
                            
                            <form method="post" action="actions/add_webinar_action.jsp">
                                <table border="0" width="100%">
                                    <tr>
                                        <td align="right">
                                            <b><i><%= langBacking.getLiteral("type") %>(*):</i></b> 
                                        </td>
                                        <td colspan="10" align="left">
                                            <select name="webinarType" id="webinarTypeSelect">
                                                <option selected value='Τηλε-διάσκεψη'>Τηλε-διάσκεψη</option>
                                                <option value='Τηλε-εκπαίδευση'>Τηλε-εκπαίδευση</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr><td colspan="10">&nbsp;</td></tr>
                                    <tr>
                                        <td colspan="10">
                                            <b><i><%= langBacking.getLiteral("date_time") %>(*)</i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("date") %>:
                                        </td>
                                        <td>
                                            <input type="text" id="previewDatePicker" name="previewDatePicker" />
                                        </td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("start_time") %>:
                                        </td>
                                        <td>
                                            <select name="webinarStartTime" id="startTimeSelect">
                                            <%
                                            Calendar reqDateCal = Calendar.getInstance();
                                            reqDateCal.set(Calendar.HOUR_OF_DAY, 7);
                                            reqDateCal.set(Calendar.MINUTE, 0);
                                            reqDateCal.set(Calendar.SECOND, 0);
                                            reqDateCal.set(Calendar.MILLISECOND, 0);
                                            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                                            while(true)
                                            {
                                                String curTime = sdf.format(reqDateCal.getTime());
                                                if(reqDateCal.get(Calendar.HOUR_OF_DAY)>6 && reqDateCal.get(Calendar.HOUR_OF_DAY)<=23)
                                                {
                                                    out.println("<option value='"+curTime+"'>"+curTime+"</option>");
                                                    reqDateCal.add(Calendar.MINUTE, 15);
                                                }
                                                else
                                                {
                                                    out.println(curTime);
                                                    break;
                                                }
                                            }
                                            %>
                                            </select>
                                        </td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("end_time") %>:
                                        </td>
                                        <td>
                                            <select name="webinarEndTime" id="endTimeSelect">
                                            <%
                                            reqDateCal = Calendar.getInstance();
                                            reqDateCal.set(Calendar.HOUR_OF_DAY, 7);
                                            reqDateCal.set(Calendar.MINUTE, 0);
                                            reqDateCal.set(Calendar.SECOND, 0);
                                            reqDateCal.set(Calendar.MILLISECOND, 0);
                                            sdf = new SimpleDateFormat("HH:mm");
                                            while(true)
                                            {
                                                String curTime = sdf.format(reqDateCal.getTime());
                                                if(reqDateCal.get(Calendar.HOUR_OF_DAY)>6 && reqDateCal.get(Calendar.HOUR_OF_DAY)<=23)
                                                {
                                                    out.println("<option value='"+curTime+"'>"+curTime+"</option>");
                                                    reqDateCal.add(Calendar.MINUTE, 15);
                                                }
                                                else
                                                {
                                                    out.println(curTime);
                                                    break;
                                                }
                                            }
                                            %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr><td colspan="10">&nbsp;</td></tr>
                                    <tr>
                                        <td align="right">
                                            <b><i><%= langBacking.getLiteral("subject") %>(*):</i></b>
                                        </td>
                                        <td colspan="10" align="left">
                                            <input type="text" name="webinarSubject" value="<%= counterdeskBacking.getNewWebinarBean().getSubject() %>" style="width: 700px;"/>
                                        </td>
                                    </tr>
                                    <tr><td colspan="10">&nbsp;</td></tr>
                                    <tr>
                                        <td align="right">
                                            <b><i><%= langBacking.getLiteral("organizer") %>:</i></b>
                                        </td>
                                        <td colspan="10" align="left">
                                            <input type="text" name="webinarOrganizer" value="<%= counterdeskBacking.getNewWebinarBean().getSubject() %>" style="width: 700px;"/>
                                        </td>
                                    </tr>
                                    <tr><td colspan="10">&nbsp;</td></tr>
                                    <tr>
                                        <td colspan="10">
                                            <b><i><%= langBacking.getLiteral("description") %>:</i></b>
                                            <br/>
                                            <textarea style="width: 100%;" rows="6" name="webinarDescription"><%= counterdeskBacking.getNewWebinarBean().getDescription() %></textarea>
                                        </td>
                                    </tr>
                                    <tr><td colspan="10">&nbsp;</td></tr>
                                    <tr>
                                        <td colspan="10">
                                            <b><i><%= langBacking.getLiteral("participants")+" "+langBacking.getLiteral("stis") %>(*):</i></b>
                                            <br/>
                                            <a href="javascript:selectAll('stis');"><%= langBacking.getLiteral("select_all") %></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="10">
                                            <%
                                            ArrayList<StisBean> stisList=counterdeskBacking.getAllStis();
                                            %>
                                            <table border="0" width="100%">
                                                <tr>
                                                <%
                                                for(int i=0; i<stisList.size(); i++)
                                                {
                                                    StisBean curStis = stisList.get(i);
                                                    out.println("<td>");
                                                        out.println("<input type='checkbox' id='stis#"+curStis.getId()+"' name='stis#"+curStis.getId()+"' /> ");//checked='true'");
                                                        out.println(curStis.getTitle()+" ("+curStis.getNosokomeio()+")");
                                                    out.println("</td>");
                                                    if((i>0 && i%4==0) || i==stisList.size()-1)
                                                    {
                                                        out.println("</tr>");
                                                        if(i<stisList.size()-1)
                                                        {
                                                            out.println("<tr>");
                                                        }
                                                    }
                                                }
                                                %>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr><td colspan="10">&nbsp;</td></tr>
                                    <tr>
                                        <td colspan="10">
                                            <b><i><%= langBacking.getLiteral("participants")+" "+langBacking.getLiteral("stia") %>:</i></b>
                                            <br/>
                                            <a href="javascript:selectAll('site');"><%= langBacking.getLiteral("select_all") %></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="10">
                                            <%
                                            ArrayList<siteBean> sitesList=counterdeskBacking.getAllSites();
                                            %>
                                            <table border="0" width="100%">
                                                <tr>
                                                <%
                                                for(int i=0; i<sitesList.size(); i++)
                                                {
                                                    siteBean curSite = sitesList.get(i);
                                                    out.println("<td>");
                                                        out.println("<input type='checkbox' name='site#"+curSite.id+"' /> ");//checked='true'");
                                                        out.println(curSite.name);
                                                    out.println("</td>");
                                                    if((i>0 && i%4==0) || i==sitesList.size()-1)
                                                    {
                                                        out.println("</tr>");
                                                        if(i<sitesList.size()-1)
                                                        {
                                                            out.println("<tr>");
                                                        }
                                                    }
                                                }
                                                %>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="10" align="center">
                                            <input type="submit" value="<%= langBacking.getLiteral("save") %>"/>
                                        </td>
                                    </tr>
                                </table>
                                <i>(*) <%= langBacking.getLiteral("required_fields") %> </i>
                            </form>
                            
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
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $("#select").wijdropdown();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button'],:input[type='submit']").button();
        
        $("#previewDatePicker").wijinputdate({
        <%
        if(langBacking.lang.equalsIgnoreCase("greek"))
        {
            out.println("culture: 'el-GR',");
        }
        %>
        dateFormat: '<%= langBacking.getDateFormat() %>',
        date: '<%= counterdeskBacking.getNewWebinarBean().getStartDateStr(langBacking.getDateFormat()) %>',
        //date: '12/8/2012',
        //dateFormat: 'dddd',
        showTrigger: true
        });
        
        $("#startTimeSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
        
        $("#endTimeSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
        
        $("#webinarTypeSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
    </script>
    
    </body>
    
</html>