
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="backings.ConsultantBacking"%>
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
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");

//check login
if(consultantBacking!=null && consultantBacking.getAB()!=null && consultantBacking.getAB().RB!=null)
{
    if(consultantBacking.getAB().RB.roleName.equals("consultant")==false)
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
    window.location='myTeleAppointments.jsp?reqDateStr='+document.getElementById("previewDatePicker").value;
}
</script>
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "teleAppointments"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" style="width:100%">
                    
                    <%
                    if(consultantBacking!=null && consultantBacking.getErrorMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getErrorMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(consultantBacking!=null && consultantBacking.getOkMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getOkMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(consultantBacking!=null && consultantBacking.getInfoMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getInfoMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    consultantBacking.resetMessages();
                        
                    %>    
                    <div class="post">
                        <table border="0" style="width:980px;">
                            <tr>
                                <td align="left">
                                    <h2 class="title"><a href="#"><%= langBacking.getLiteral("my_tele_appointments") %></a></h2>
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
                                $("#myTeleAppointmentsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 50,
                                    allowColSizing: true,
                                    data: [
                                <%
                                ArrayList<StisBean> stisList=consultantBacking.getAB().consultantBean.getStisList();
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
                                
                                consultantBacking.getTeleAppointmentsByDateAndConsultantId(reqDate,consultantBacking.getAB().consultantBean.getId());
                                
                                Calendar reqDateCal = Calendar.getInstance();
                                reqDateCal.setTime(reqDate);
                                reqDateCal.set(Calendar.HOUR_OF_DAY, 0);
                                reqDateCal.set(Calendar.MINUTE, 0);
                                reqDateCal.set(Calendar.SECOND, 0);
                                reqDateCal.set(Calendar.MILLISECOND, 0);
                                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                                int curDay = reqDateCal.get(Calendar.DAY_OF_MONTH);
                                while(true)
                                {
                                    String row="['"+sdf.format(reqDateCal.getTime())+"',";
                                    for(StisBean curStis : stisList)
                                    {
                                        TeleAppointmentBean retrievedTeleAppoint = consultantBacking.findTeleAppointmentByStisAndDateTime(curStis.getId(),reqDateCal.getTime());
                                        
                                        if(retrievedTeleAppoint!=null)
                                        {
                                            String farosImg="";
                                            if(retrievedTeleAppoint.getEmergency().equalsIgnoreCase("true"))
                                            {
                                                farosImg="<img src=\"../images/beacon.gif\"/><br/>";
                                            }
                                            String userNearPatient="";
                                            if(retrievedTeleAppoint.getSiteDoctorBean()!=null && retrievedTeleAppoint.getSiteDoctorBean().id!=null &&
                                               retrievedTeleAppoint.getSiteDoctorBean().id.trim().length()>0)
                                            {
                                                userNearPatient=langBacking.getLiteral("sitedoctor")+": "+retrievedTeleAppoint.getSiteDoctorBean().getFullName()+" ("+retrievedTeleAppoint.getSiteDoctorBean().specialtyBean.getNameByLang(langBacking.lang)+")";
                                            }
                                            else if(retrievedTeleAppoint.getParamedicBean()!=null && retrievedTeleAppoint.getParamedicBean().getId()!=null &&
                                               retrievedTeleAppoint.getParamedicBean().getId().trim().length()>0)
                                            {
                                                userNearPatient=langBacking.getLiteral("paramedic")+": "+retrievedTeleAppoint.getParamedicBean().getFullName()+" ("+retrievedTeleAppoint.getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")";
                                            }
                                            String patientLocation=langBacking.getLiteral("stia")+": "+retrievedTeleAppoint.getSB().name;
                                            
                                            row+="'"+farosImg+"<a href=\"viewPatientHistory.jsp?patId="+retrievedTeleAppoint.getPatientBean().id+"\">"+langBacking.getLiteral("patient")+": "+retrievedTeleAppoint.getPatientBean().name+" "+retrievedTeleAppoint.getPatientBean().surname+"<br/>"+userNearPatient+"<br/>"+patientLocation+"<br/>"+retrievedTeleAppoint.getStartEndDateTimeStr(langBacking.getDateFormat())+" </a>',";
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
                                    
                                    if(curDay==reqDateCal.get(Calendar.DAY_OF_MONTH))
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
                            
                            <table id='myTeleAppointmentsTable' style="width:980px;"></table>
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