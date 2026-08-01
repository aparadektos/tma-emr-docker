<%@page import="beans.WebinarBean"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="beans.DepartmentBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.ModalityBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">


<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.cartBean"%>

<%
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
        <script src="../wijmotools/external/jquery.mousewheel.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
        <!--<link href="../wijmotools/wijmo/jquery.wijmo.wijcombobox.css" rel="stylesheet" type="text/css" />-->
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
            window.location='myEfimeries.jsp?reqDateStr='+document.getElementById("refreshDatePicker").value;
        }
        function cancelMyEfimeria(efimeriaHash)
        {
            if(confirm("<%= langBacking.getLiteral("cancel_efimeria_confirm") %>"))
            {
                document.getElementById("efimeriaHash").value=efimeriaHash;
                document.getElementById("cancelEfimeriaForm").submit();
            }
        }
    </script>
        
    
    <body>
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "efimeries"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    
                    <%
                    if(consultantBacking!=null && consultantBacking.getErrorMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getErrorMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(consultantBacking!=null && consultantBacking.getOkMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getOkMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(consultantBacking!=null && consultantBacking.getInfoMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(consultantBacking.getInfoMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    consultantBacking.resetMessages();
                    %>
                    
                    <div class="post" style="width: 800px;" >
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("availability") %></a></h2>
                        <div class="entry">
                            <form method="post" action="actions/add_efimeria_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("start_date_time") %>:</td>
                                        <td><input type="text" id="previewDatePicker" name="efimeriaStartDate" size="11"/> </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <select name="efimeriaStartTime" id="startTimeSelect">
                                                <%
                                                Calendar reqDateCal = Calendar.getInstance();
                                                reqDateCal.set(Calendar.HOUR_OF_DAY, 0);
                                                reqDateCal.set(Calendar.MINUTE, 0);
                                                reqDateCal.set(Calendar.SECOND, 0);
                                                reqDateCal.set(Calendar.MILLISECOND, 0);
                                                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                                                int curStartDay = reqDateCal.get(Calendar.DAY_OF_MONTH);
                                                while(true)
                                                {
                                                    String curTime = sdf.format(reqDateCal.getTime());
                                                    if(curStartDay==reqDateCal.get(Calendar.DAY_OF_MONTH))
                                                    {
                                                        out.println("<option value='"+curTime+"'>"+curTime+"</option>");
                                                        reqDateCal.add(Calendar.MINUTE, 30);
                                                    }
                                                    else
                                                    {
                                                        break;
                                                    }
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("end_date_time") %>:</td>
                                        <td><input type="text" id="previewDateEndPicker" name="efimeriaEndDate" size="11"/> </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <select name="efimeriaEndTime" id="endTimeSelect">
                                            <%
                                            reqDateCal = Calendar.getInstance();
                                            reqDateCal.set(Calendar.HOUR_OF_DAY, 0);
                                            reqDateCal.set(Calendar.MINUTE, 0);
                                            reqDateCal.set(Calendar.SECOND, 0);
                                            reqDateCal.set(Calendar.MILLISECOND, 0);
                                            sdf = new SimpleDateFormat("HH:mm");
                                            int curEndDay = reqDateCal.get(Calendar.DAY_OF_MONTH);
                                            while(true)
                                            {
                                                String curTime = sdf.format(reqDateCal.getTime());
                                                if(curEndDay==reqDateCal.get(Calendar.DAY_OF_MONTH))
                                                {
                                                    out.println("<option value='"+curTime+"'>"+curTime+"</option>");
                                                    reqDateCal.add(Calendar.MINUTE, 30);
                                                }
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                            %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("stis") %>:</td>
                                        <td colspan="4">
                                            <select id="stisSelect" name="stisId">
                                                <%
                                                for(StisBean curStis : consultantBacking.getAB().consultantBean.getStisList())
                                                {
                                                    out.println("<option value='"+curStis.getId()+"'>"+curStis.getTitle()+" ("+curStis.getNosokomeio()+")</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" align="center">
                                            <input type="submit" value="<%= langBacking.getLiteral("save") %>"/>
                                        </td>
                                    </tr>
                                </table>
                                
                            </form>
                        </div>
                    </div>
                    
                    <div class="post" style="width: 800px;" >
<!--                        <h2 class="title"><a href="#"><%//= langBacking.getLiteral("availability") %></a></h2>-->
                        <div class="entry">
                            <%
                            consultantBacking.setMyEfimeriesResults(consultantBacking.getMyEfimeries());
                            ArrayList<EfimeriaBean> myEfimeriesList = consultantBacking.getMyEfimeriesResults();
                            if(myEfimeriesList!=null)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#efimeriesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 20,
                                    allowColSizing: true,
                                    data: [
                            <%
                                for(int i=0; i<myEfimeriesList.size(); i++)
                                {
                                    EfimeriaBean curEfimeria=myEfimeriesList.get(i);
                                    String hrefs="";
                                    
                                    Calendar halfCal = Calendar.getInstance();
                                    halfCal.setTime(new Date(curEfimeria.getAddedDateTime().getTime()));
                                    halfCal.add(Calendar.MINUTE, 30);
                                    if(halfCal.getTime().after(new Date()) || halfCal.getTime().equals(new Date()))
                                    {
//                                        hrefs+="<a href=\"editMyEfimeria.jsp?id="+curEfimeria.getId()+"\"><img title=\""+langBacking.getLiteral("edit_efimeria")+"\" src=\"../images/editEfimeria.png\" width=\"25px\"/></a>";
//                                        hrefs+="&nbsp;&nbsp;&nbsp;";
                                        hrefs+="<a href=\"javascript:cancelMyEfimeria("+curEfimeria.hashCode()+");\"><img title=\""+langBacking.getLiteral("cancel_efimeria")+"\" src=\"../images/cancelEfimeria.png\" width=\"30px\"/></a>";
                                    }
                                    
                                    String startDateTime = curEfimeria.getStartDateStr(langBacking.getDateFormat())+"<br/>"+curEfimeria.getStartTimeStr();
                                    String endDateTime = curEfimeria.getEndDateStr(langBacking.getDateFormat())+"<br/>"+curEfimeria.getEndTimeStr();
                                    out.println("['"+startDateTime+"','"+endDateTime+"','"+curEfimeria.getStisBean().getTitle()+" ("+curEfimeria.getStisBean().getNosokomeio()+")', '"+curEfimeria.getAddedDateTimeStr(langBacking.getDateFormat())+"', '"+hrefs+" '],");
                                }
                            %>
                                    ],
                                    columns: [
                                             { headerText: "<%= langBacking.getLiteral("start_date_time") %> " },
                                             { headerText: "<%= langBacking.getLiteral("end_date_time") %>"},
                                             { headerText: "<%= langBacking.getLiteral("stis") %>"},
                                             { headerText: "<%= langBacking.getLiteral("date_time_added") %>(*)"},
                                             { headerText: "<%= langBacking.getLiteral("actions") %>"}
                                    ],
                                    cellStyleFormatter: function (args) {
                                        args.$cell.css("textAlign", "center");
                                        // args.row.type,   args.$cell[0].cellIndex,    
                                    }
                                });
                            });
                            </script>
                            <%
                                out.println("<table id='efimeriesTable'></table>");
                                out.println("<i>(*) "+langBacking.getLiteral("edit_efimeria_30_min")+"</i>");
                            }
                            %>
                            <br/>
                            
                            <form id="cancelEfimeriaForm" method="post" action="actions/cancel_efimeria_action.jsp">
                                <input type="hidden" name="efimeriaHash" id="efimeriaHash"/>
                            </form>
                            
                        </div>
                    </div>
                            
                    <div class="post">
                        <table border="0" width="100%">
                            <tr>
                                <td align="left">
                                    <h2 class="title"><a href="#"><%= langBacking.getLiteral("efimeries") %></a></h2>
                                </td>
                                <td align="right">
                                    <input type="text" id="refreshDatePicker" name="refreshDatePicker" />
                                </td>
                                <td align="right" width="30px">
                                    <a href="javascript:refreshReqDate();"><img src="../images/refresh1.png" width="25px" /></a>
                                </td>
                            </tr>
                        </table>
                        
                        <div class="entry">
                            
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#allEfimeriesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 50,
                                    allowColSizing: true,
                                    data: [
                                <%
                                ArrayList<StisBean> stisList=consultantBacking.getAB().consultantBean.getStisList();
                                SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
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
                                
                                consultantBacking.getAllEfimeriesByDate(reqDate);
                                consultantBacking.getAllWebinarsByDate(reqDate);
                                
                                reqDateCal = Calendar.getInstance();
                                reqDateCal.setTime(reqDate);
                                reqDateCal.set(Calendar.HOUR_OF_DAY, 0);
                                reqDateCal.set(Calendar.MINUTE, 0);
                                reqDateCal.set(Calendar.SECOND, 0);
                                reqDateCal.set(Calendar.MILLISECOND, 0);
                                sdf = new SimpleDateFormat("HH:mm");
                                int curDay = reqDateCal.get(Calendar.DAY_OF_MONTH);
                                while(true)
                                {
                                    String row="['"+sdf.format(reqDateCal.getTime())+"',";
                                    for(StisBean curStis : stisList)
                                    {
                                        EfimeriaBean retrievedEfimeria = consultantBacking.findEfimeriaByStisAndDate(curStis.getId(),reqDateCal.getTime());
                                        WebinarBean retrievedWebinar=consultantBacking.findWebinarByStisAndDate(curStis.getId(),reqDateCal.getTime());
                                        if(retrievedEfimeria!=null && retrievedWebinar==null)
                                        {
                                            row+="'"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")"+"',";
                                        }
                                        else if(retrievedEfimeria!=null && retrievedWebinar!=null)
                                        {
                                            row+="'<b>CONFLICT</b><br/>"+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+" ("+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+")<br/><br/>"+retrievedWebinar.getSubject()+"',";
                                        }
                                        else if(retrievedEfimeria==null && retrievedWebinar!=null)
                                        {
                                            row+="'"+retrievedWebinar.getSubject()+"',";
                                        }
                                        else
                                        {
                                            row+="'',";
                                        }
                                    }
                                    
                                    if(row.length()>0 && row.endsWith(","))
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
                                        if(row.length()>0 && row.endsWith(","))
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
                                            if(columns.length()>0 && columns.endsWith(","))
                                            {
                                                columns=columns.substring(0, columns.length()-1);
                                            }
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
                            
                            <table id='allEfimeriesTable' ></table>
                        </div>               
                    </div>
                </div>
		<!-- end #content -->
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="myEfimeries.jsp"><%= langBacking.getLiteral("efimeries") %></a></li>
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
  
    <script language="javascript">
        
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
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
        //date: '<%//=onDate%>',
        //date: '12/8/2012',
        //dateFormat: 'dddd',
        showTrigger: true
        });
        
        $("#previewDateEndPicker").wijinputdate({
        <%
        if(langBacking.lang.equalsIgnoreCase("greek"))
        {
            out.println("culture: 'el-GR',");
        }
        %>
        dateFormat: '<%= langBacking.getDateFormat() %>',
        //date: '<%//=onDate%>',
        //date: '12/8/2012',
        //dateFormat: 'dddd',
        showTrigger: true
        });
        
        $("#stisSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
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
        
        $("#refreshDatePicker").wijinputdate({
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