
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
    function cancelAppointment()
    {
        if(confirm("<%= langBacking.getLiteral("cancel_appointment_confirm") %>"))
        {
            document.getElementById("cancelAppointmentForm").submit();
        }
    }
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
                            String appHash = request.getParameter("appHash");
                            if(appHash!=null)
                            {
                                TeleAppointmentBean selectedTeleAppointment = counterdeskBacking.getTeleAppointmentFromResults(appHash);
                                if(selectedTeleAppointment!=null)
                                {
                                out.println("<form method='post' id='cancelAppointmentForm' action='actions/cancel_teleappointment_action.jsp'>");
                                    out.println("<input type='hidden' name='appHash' value='"+selectedTeleAppointment.hashCode()+"'/>");
                                    out.println("<table border='0' width='100%'>");
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("patient")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedTeleAppointment.getPatientBean().name+" "+selectedTeleAppointment.getPatientBean().surname);
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        if(selectedTeleAppointment.getSiteDoctorBean()!=null && 
                                           selectedTeleAppointment.getSiteDoctorBean().id!=null && 
                                           selectedTeleAppointment.getSiteDoctorBean().id.length()>0)
                                        {
                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println(langBacking.getLiteral("sitedoctor")+": ");
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println(selectedTeleAppointment.getSiteDoctorBean().name+" "+selectedTeleAppointment.getSiteDoctorBean().surname+" ("+selectedTeleAppointment.getSiteDoctorBean().specialtyBean.getNameByLang(langBacking.lang)+")");
                                                out.println("</td>");
                                            out.println("</tr>");

                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println(langBacking.getLiteral("stia")+": ");
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println(selectedTeleAppointment.getSiteDoctorBean().SB.name);
                                                out.println("</td>");
                                            out.println("</tr>");
                                        }
                                        else if(selectedTeleAppointment.getParamedicBean()!=null && 
                                                selectedTeleAppointment.getParamedicBean().getId()!=null &&
                                                selectedTeleAppointment.getParamedicBean().getId().length()>0)
                                        {
                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println(langBacking.getLiteral("paramedic")+": ");
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println(selectedTeleAppointment.getParamedicBean().getFullName()+" ("+selectedTeleAppointment.getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")");
                                                out.println("</td>");
                                            out.println("</tr>");

                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println(langBacking.getLiteral("stia")+": ");
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println(selectedTeleAppointment.getParamedicBean().getSB().name);
                                                out.println("</td>");
                                            out.println("</tr>");
                                        }
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("date_time")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedTeleAppointment.getStartEndDateTimeStr(langBacking.getDateFormat()));
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right' height='10px'>");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("stis")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedTeleAppointment.getStisBean1().getTitle()+" ("+selectedTeleAppointment.getStisBean1().getNosokomeio()+")");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right'>");
                                                out.println(langBacking.getLiteral("consultant")+": ");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                                out.println(selectedTeleAppointment.getConsultantBean1().getName()+" "+selectedTeleAppointment.getConsultantBean1().getSurname()+" ("+selectedTeleAppointment.getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        out.println("<tr>");
                                            out.println("<td align='right' height='10px'>");
                                            out.println("</td>");
                                            out.println("<td align='left'>");
                                            out.println("</td>");
                                        out.println("</tr>");
                                        
                                        if(selectedTeleAppointment.getConsultantBean2()!=null &&
                                           selectedTeleAppointment.getStisBean2()!=null)
                                        {
                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println(langBacking.getLiteral("stis")+": ");
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println(selectedTeleAppointment.getStisBean2().getTitle()+" ("+selectedTeleAppointment.getStisBean2().getNosokomeio()+")");
                                                out.println("</td>");
                                            out.println("</tr>");

                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println(langBacking.getLiteral("consultant")+": ");
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println(selectedTeleAppointment.getConsultantBean2().getName()+" "+selectedTeleAppointment.getConsultantBean2().getSurname()+" ("+selectedTeleAppointment.getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")");
                                                out.println("</td>");
                                            out.println("</tr>");
                                        }
                                        
                                        if(selectedTeleAppointment.getStatus()!=null && 
                                           selectedTeleAppointment.getStatus().equalsIgnoreCase("completed")==false )
                                        {
                                            out.println("<tr>");
                                                out.println("<td align='center' colspan='4'>");
                                                    out.println("<br/><input onclick='javascript:cancelAppointment();' type='button' value='"+langBacking.getLiteral("cancel_appointment")+"'/>");
    //                                                out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    //                                                out.println("<a href='popupMoveTeleAppointment.jsp'><input type='button' value='"+langBacking.getLiteral("move_appointment")+"'/></a>");
                                                out.println("</td>");
                                            out.println("</tr>");
                                        }
                                        
                                    out.println("</table>");
                                out.println("</form>");
                                }
                                else
                                {
                                    out.println(langBacking.getLiteral("invalid_tele_appointment"));
                                }
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_tele_appointment"));
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
    </script>

</html>