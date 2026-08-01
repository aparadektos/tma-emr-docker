
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.WebinarBean"%>
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
function refreshReqDate()
{
    window.location='efimeries.jsp?reqDateStr='+document.getElementById("previewDatePicker").value;
}

function showTeleAppointmentDetails(appHash)
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("show_tele_appointment_details") %>",
        width: 600, 
        height: 500, 
        modal: true,
        contentUrl: 'popupShowTeleAppointmentDetails.jsp?appHash='+appHash, 
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

function editEfimeria(efimeriaHash)
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("popup_edit_efimeria_title") %>",
        width: 450, 
        height: 500, 
        modal: true,
        contentUrl: 'popupEditTeleEfimeria.jsp?efimeriaHash='+efimeriaHash, 
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
            <% request.setAttribute("target", "efimeries"); %>
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
                                    <h2 class="title"><a href="#"><%= langBacking.getLiteral("efimeries") %></a></h2>
                                </td>
                                <td align="right">
                                    <input type="text" id="previewDatePicker" name="previewDatePicker" />
                                </td>
                                <td align="right" width="30px">
                                    <a href="javascript:refreshReqDate();"><img src="../images/refresh1.png" width="25px" /></a>
                                </td>
                            </tr>
                        </table>
                        
                        <div class="entry">
                            
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#efimeriesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 50,
                                    allowColSizing: true,
                                    data: [
                                <%
                                ArrayList<StisBean> stisList=counterdeskBacking.getAllStis();
                                SimpleDateFormat sdfDate = new SimpleDateFormat(langBacking.getDateFormat());
                                Date reqDate = null;
                                String reqDateStr=request.getParameter("reqDateStr");
                                if(reqDateStr!=null && reqDateStr.length()>0)
                                {
                                    reqDate = sdfDate.parse(reqDateStr);
                                }
                                else
                                {
                                    reqDate = new Date();
                                }
                                
                                counterdeskBacking.getAllEfimeriesByDate(reqDate);
                                counterdeskBacking.getAllTeleAppointmentsByDate(reqDate);
                                counterdeskBacking.getAllWebinarsByDate(reqDate);
                                
                                Calendar reqDateCal = Calendar.getInstance();
                                reqDateCal.setTime(reqDate);
                                reqDateCal.set(Calendar.HOUR_OF_DAY, 0);
                                reqDateCal.set(Calendar.MINUTE, 0);
                                reqDateCal.set(Calendar.SECOND, 0);
                                reqDateCal.set(Calendar.MILLISECOND, 0);
                                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                                while(true)
                                {
                                    String row="['"+sdf.format(reqDateCal.getTime())+"',";
                                    for(StisBean curStis : stisList)
                                    {
                                        TeleAppointmentBean retrievedTeleAppoint = counterdeskBacking.findTeleAppointmentByStisAndDateTime(curStis.getId(),reqDateCal.getTime());
                                        EfimeriaBean retrievedEfimeria = counterdeskBacking.findEfimeriaByStisAndDate(curStis.getId(),reqDateCal.getTime());
                                        WebinarBean retrievedWebinar=counterdeskBacking.findWebinarByStisAndDate(curStis.getId(),reqDateCal.getTime());
                                        if(retrievedEfimeria!=null && retrievedWebinar==null)
                                        {
                                            String start="";
                                            if(retrievedEfimeria.getStartDateTime().equals(new Timestamp(reqDateCal.getTime().getTime())))
                                            {
                                                start="<a href=\"javascript:editEfimeria("+retrievedEfimeria.hashCode()+");\"><img src=\"../images/edit2.png\" width=\"15px\"></a><br/>";
                                            }
                                            if(retrievedTeleAppoint!=null)
                                            {
                                                String divColor="#FFCCCC";
                                                if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Pending"))
                                                {
                                                    divColor="#FFCCCC";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Completed"))
                                                {
                                                    divColor="#99FF99";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("in_progress"))
                                                {
                                                    divColor="#CC0000";
                                                }
                                                String farosImg="";
                                                if(retrievedTeleAppoint.getEmergency().equalsIgnoreCase("true"))
                                                {
                                                    farosImg="<img src=\"../images/beacon.gif\"/>";
                                                }
                                                row+="'"+farosImg+"<div style=\"background-color:"+divColor+"\"><a href=\"javascript:showTeleAppointmentDetails("+retrievedTeleAppoint.hashCode()+");\">"+start+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")"+"</a></div>',";
                                            }
                                            else
                                            {
                                                row+="'"+start+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")"+"',";
                                            }
                                        }
                                        else if(retrievedEfimeria!=null && retrievedWebinar!=null)
                                        {
                                            String start="";
                                            if(retrievedEfimeria.getStartDateTime().equals(new Timestamp(reqDateCal.getTime().getTime())))
                                            {
                                                start="<a href=\"javascript:editEfimeria("+retrievedEfimeria.hashCode()+");\"><img src=\"../images/edit2.png\" width=\"15px\"></a><br/>";
                                            }
                                            if(retrievedTeleAppoint!=null)
                                            {
                                                String divColor="#FFCCCC";
                                                if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Pending"))
                                                {
                                                    divColor="#FFCCCC";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Completed"))
                                                {
                                                    divColor="#99FF99";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("in_progress"))
                                                {
                                                    divColor="#CC0000";
                                                }
                                                String farosImg="";
                                                if(retrievedTeleAppoint.getEmergency().equalsIgnoreCase("true"))
                                                {
                                                    farosImg="<img src=\"../images/beacon.gif\"/>";
                                                }
                                                row+="'"+farosImg+"<div style=\"background-color:"+divColor+"\"><a href=\"javascript:showTeleAppointmentDetails("+retrievedTeleAppoint.hashCode()+");\"><b>CONFLICT</b><br/>"+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+" ("+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+")<br/><br/>"+retrievedWebinar.getSubject()+"</a></div>',";
                                            }
                                            else
                                            {
                                                row+="'<b>CONFLICT</b><br/>"+start+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+" ("+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+")<br/><br/>"+retrievedWebinar.getSubject()+"',";
                                            }
                                        }
                                        else if(retrievedEfimeria==null && retrievedWebinar!=null)
                                        {
                                            if(retrievedTeleAppoint!=null)
                                            {
                                                String divColor="#FFCCCC";
                                                if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Pending"))
                                                {
                                                    divColor="#FFCCCC";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Completed"))
                                                {
                                                    divColor="#99FF99";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("in_progress"))
                                                {
                                                    divColor="#CC0000";
                                                }
                                                String farosImg="";
                                                if(retrievedTeleAppoint.getEmergency().equalsIgnoreCase("true"))
                                                {
                                                    farosImg="<img src=\"../images/beacon.gif\"/>";
                                                }
                                                row+="'"+farosImg+"<div style=\"background-color:"+divColor+"\"><a href=\"javascript:showTeleAppointmentDetails("+retrievedTeleAppoint.hashCode()+");\"><b>CONFLICT</b><br/>"+retrievedWebinar.getSubject()+"</a></div>',";
                                            }
                                            else
                                            {
                                                row+="'<div style=\"background-color:#99CCFF\">"+retrievedWebinar.getSubject()+"<br/>&nbsp;</div>',";
                                            }
                                        }
                                        else
                                        {
                                            row+="'',";
                                        }
                                    }
                                    
                                    if(row.endsWith(","))
                                    {
                                        row=row.substring(0, row.length()-1);
                                    }
                                    
                                    row+="],";
                                    
                                    if(reqDateCal.get(Calendar.HOUR_OF_DAY)<23 || 
                                      (reqDateCal.get(Calendar.HOUR_OF_DAY)==23 && reqDateCal.get(Calendar.MINUTE)==00) )
                                    {
                                        out.println(row);
                                        reqDateCal.add(Calendar.MINUTE, 30);
                                    }
                                    else
                                    {
                                        if(row.endsWith(","))
                                        {
                                            row=row.substring(0, row.length()-1);
                                        }
                                        out.println(row);
                                        break;
                                    }
                                }
                            %>
                                    ],
                                    columns: [
                                             { headerText: "<%= langBacking.getLiteral("time") %> " },
                                            <%
                                            String columns="";
                                            for(StisBean curStis : stisList)
                                            {
                                                columns+="{ headerText: '"+curStis.getTitle()+"<br/>("+curStis.getNosokomeio()+")' },";
                                            }
                                            columns=columns.substring(0, columns.length()-1);
                                            out.println(columns);
                                            %>
                                    ],
                                    cellStyleFormatter: function (args) {
                                        args.$cell.css("textAlign", "center");
                                        // args.row.type,   args.$cell[0].cellIndex,    
                                    }
                                });
                            });
                            </script>
                            
                            <%
                            String tableWidth="980px";
                            if(stisList.size()>=14)
                            {
                                tableWidth="2000px";
                            }
                            else if(stisList.size()>=10)
                            {
                                tableWidth="1600px";
                            }
                            %>
                            <table id='efimeriesTable' style="width:<%=tableWidth%>;"></table>
                            
                            <!-- color legend table-->
                            <table border="0">
                                <tr>
                                    <td bgcolor="#FFCCCC">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("pending_tele_appointment") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="#99FF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("completed_tele_appointment") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="#CC0000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("tele_appointment_in_progress") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="#99CCFF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("pending_webinar") %></td>
                                </tr>
                            </table>
                            <table border="0">
                                
                                
                            </table>
                            
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
        $("#previewDatePicker").wijinputdate({
        <%
        if(langBacking.lang.equalsIgnoreCase("greek"))
        {
            out.println("culture: 'el-GR',");
        }
        %>
        dateFormat: '<%= langBacking.getDateFormat() %>',
        date: '<%=reqDateStr%>',
        //date: '12/8/2012',
        //dateFormat: 'dddd',
        showTrigger: true
        });
    </script>
    
    </body>
    
</html>