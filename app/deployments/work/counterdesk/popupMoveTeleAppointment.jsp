
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../popupStyle.css" rel="stylesheet" type="text/css" media="screen"/>
        
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
    function markEfimeriaAndTime(divObj)
    {
        for(id=0; id<50; id++)
        {
            var curDivObj=document.getElementById("div#"+id);
            if(curDivObj!==null)
            {
                curDivObj.style.backgroundColor="transparent";
            }
        }
        divObj.style.backgroundColor="orange";
    }

    function submitConsultantAssignment()
    {
        if(confirm("<%= langBacking.getLiteral("move_teleappointment_confirm") %>"))
        {
            for(id=0; id<50; id++)
            {
                var curDivObj = document.getElementById("div#"+id);
                if(curDivObj!==null && curDivObj.style.backgroundColor==="orange")
                {
                    var temp=document.getElementById("div#"+id).title.split("##");
                    var efimeriaId=temp[0];
                    var time=temp[1];

                    document.getElementById("selectedEfimeriaId").value=efimeriaId;
                    document.getElementById("selectedTime").value=time;

                    document.getElementById("selectedEfimeriaFormId").submit();
                }
            }
        }
    }
</script>
    
    <body >

    <div id="wrapper">
	
	<div id="page">
            <div id="page-bgtop">
                <div id="content">
                    <%
                    if(counterdeskBacking!=null && counterdeskBacking.getErrorMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(counterdeskBacking.getErrorMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(counterdeskBacking!=null && counterdeskBacking.getOkMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(counterdeskBacking.getOkMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(counterdeskBacking!=null && counterdeskBacking.getInfoMessage().length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(counterdeskBacking.getInfoMessage());
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    counterdeskBacking.resetMessages();  
                    %>
                    <div class="post">
                        
                        <div class="entry">

                        <%
                        if(counterdeskBacking.getSelectedTeleAppointment()!=null)
                        {
                            counterdeskBacking.getKavatzaEfimeriesByDateAndSpecialties(counterdeskBacking.getSelectedTeleAppointment(), new Date());
                            if(counterdeskBacking.getKavatzaEfimeriesResults().size()>0)
                            {
                                out.println("<h3>"+langBacking.getLiteral("available_efimeries")+"</h3><br/>");
                        %>
                                <table id='cavatzaEfimeriesTable'></table>
                                <script type="text/javascript">
                                    $("#cavatzaEfimeriesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    data: [
                        <%
                                ArrayList<StisBean> stisList=new ArrayList<StisBean>(0);
                                ArrayList<String> stisStrList=new ArrayList<String>(0);
                                for(EfimeriaBean curEfimeria : counterdeskBacking.getKavatzaEfimeriesResults())
                                {
                                    if(stisStrList.contains(curEfimeria.getStisBean().getId())==false)
                                    {
                                        stisList.add(curEfimeria.getStisBean());
                                        stisStrList.add(curEfimeria.getStisBean().getId());
                                    }
                                }
                                stisStrList.clear();
                                stisStrList=null;

                                //not necessary since efimeries.jsp loads that arraylist
    //                            counterdeskBacking.getAllTeleAppointmentsByDate(new Date());

                                Calendar reqDateCal = Calendar.getInstance();
                                reqDateCal.set(Calendar.HOUR_OF_DAY, 13);
                                reqDateCal.set(Calendar.MINUTE, 0);
                                reqDateCal.set(Calendar.SECOND, 0);
                                reqDateCal.set(Calendar.MILLISECOND, 0);
                                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                                int divId=0;
                                int totalSlots=1;
                                while(true)
                                {
                                    String curTime = sdf.format(reqDateCal.getTime());
                                    String row="['"+curTime+"',";
                                    for(StisBean curStis : stisList)
                                    {
                                        TeleAppointmentBean retrievedTeleAppoint = counterdeskBacking.findTeleAppointmentByStisAndDateTimeFromAllTeleAppointmentsResults(curStis.getId(),reqDateCal.getTime());
                                        EfimeriaBean retrievedEfimeria = counterdeskBacking.findEfimeriaByStisAndDateFromKavatzaResults(curStis.getId(),reqDateCal.getTime());
                                        if(retrievedEfimeria!=null)
                                        {
                                            if(retrievedTeleAppoint!=null)
                                            {
                                                String divColor="#000000";
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
                                                row+="'<div style=\"background-color:"+divColor+";\"><i>"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")</i></div>',";
                                            }
                                            else
                                            {
                                                //prepei na bgoun ta sxolia giati kanoun elegxo an exei perasei h wra.
                                                //exei sxoliastei proswrina giati kanw doyleia meta tis 13.00-14.00
    //                                            if(reqDateCal.getTime().after(new Date()))
    //                                            {
                                                    row+="'<div id=\"div#"+divId+"\" title=\""+retrievedEfimeria.getId()+"##"+curTime+"\" onclick=\"javascript:markEfimeriaAndTime(this);\">"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")</div>"+"',";
                                                    divId++;
    //                                            }
    //                                            else
    //                                            {
    //                                                row+="'<i>"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")"+"</i>',";
    //                                            }
                                            }
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

                                    if(reqDateCal.get(Calendar.HOUR_OF_DAY)<14 && totalSlots<2)
                                    {
                                        out.println(row);
                                        reqDateCal.add(Calendar.MINUTE, 30);
                                        totalSlots++;
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
                                        if(columns.length()>0)
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
                                </script>
                                <br/>
                                <center>
                                    <input type="button" value="<%= langBacking.getLiteral("save") %>" onclick="javascript:submitConsultantAssignment();"/>
                                </center>
                                <table border="0">
                                    <tr>
                                        <td bgcolor="orange">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td>&nbsp;<%= langBacking.getLiteral("current_new_tele_appointment_selection") %></td>
                                    </tr>
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
                                </table>

                                <form id="selectedEfimeriaFormId" method="post" action="actions/move_teleAppointment_action.jsp">
                                    <input type="hidden" id="selectedEfimeriaId" name="selectedEfimeriaId" value=""/>
                                    <input type="hidden" id="selectedTime" name="selectedTime" value=""/>
                                </form>
                        <%    
                            }
                            else
                            {
                                out.println("<h3>"+langBacking.getLiteral("no_efimeries_found")+"</h3>");
                            }
                        }
                        else
                        {
                            out.println(langBacking.getLiteral("invalid_tele_appointment"));
                        }
                        %>
                            
                        </div>
                    </div>

                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
<!--                <center>
                    <a href="<%//= siteDoctorBacking.urlToReturn %>" target="_parent"><input type="button" value="Επιστροφή"/></a>
                </center>-->
            </div>
        </div>
            
    </div>
    
    </body>

    <!-- Javascript functions  -->
    <script language="javascript">
        $(":input[type='button'],:input[type='submit']").button(); 
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
    </script>

</html>