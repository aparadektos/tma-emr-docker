
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.EfimeriaBean"%>
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

<!-- Javascript functions  -->
<script language="javascript">
    
</script>
    
    <body >

    <div id="wrapper">
	
	<div id="page">
            <div id="page-bgtop">
                <div id="content">
                    <%
                    boolean returnToSourcePage=false;
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
                        returnToSourcePage=true;
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
                            if(returnToSourcePage==false)
                            {
                            request.setCharacterEncoding("UTF-8");
                            String efimeriaHash = request.getParameter("efimeriaHash");
                            if(efimeriaHash!=null)
                            {
                                EfimeriaBean selectedEfimeria = counterdeskBacking.getEfimeriaFromResults(efimeriaHash);
                                if(selectedEfimeria!=null)
                                {
                                out.println("<form method='post' action='actions/edit_efimeria_action.jsp'>");
                                    out.println("<input type='hidden' name='efimeriaHash' value='"+efimeriaHash+"'/>");
                                    out.println("<table>");
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("consultant")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedEfimeria.getConsultantBean().getFullName()+" ("+selectedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+")");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("stis")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedEfimeria.getStisBean().getTitle()+" ("+selectedEfimeria.getStisBean().getNosokomeio()+")");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("date")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedEfimeria.getStartDateStr(langBacking.getDateFormat()));
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("from")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println("<select name='efimeriaStartTime' id='startTimeSelect'>");
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
                                                        if(selectedEfimeria.getStartTimeStr().equals(curTime))
                                                        {
                                                            out.println("<option selected value='"+curTime+"'>"+curTime+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+curTime+"'>"+curTime+"</option>");
                                                        }
                                                        reqDateCal.add(Calendar.MINUTE, 30);
                                                    }
                                                    else
                                                    {
                                                        break;
                                                    }
                                                }
                                                out.println("</select>");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("until")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println("<select name='efimeriaEndTime' id='endTimeSelect'>");
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
                                                        if(selectedEfimeria.getEndTimeStr().equals(curTime))
                                                        {
                                                            out.println("<option selected value='"+curTime+"'>"+curTime+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+curTime+"'>"+curTime+"</option>");
                                                        }
                                                        reqDateCal.add(Calendar.MINUTE, 30);
                                                    }
                                                    else
                                                    {
                                                        break;
                                                    }
                                                }
                                                out.println("</select>");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='center' colspan='4'>");
                                                out.println("<br/><input type='submit' value='"+langBacking.getLiteral("save")+"'/>");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                    out.println("</table>");
                                out.println("</form>");
                                }
                                else
                                {
                                    out.println(langBacking.getLiteral("invalid_efimeria_selection"));
                                }
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_efimeria_selection"));
                            }
                            }
                            else
                            {
                                out.println("<center><a href='efimeries.jsp' target='_parent'><input type='button' value='"+langBacking.getLiteral("return")+"'/></a></center>");
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
    </script>

</html>