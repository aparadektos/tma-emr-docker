

<%@page import="beans.TeleAppointmentBean"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="beans.ConsultantBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../popupStyle.css" rel="stylesheet" type="text/css" media="screen"/>
        
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

<!-- Javascript functions  -->
<script language="javascript">
    
</script>
    
    <body >

    <div id="wrapper">
	
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
                    
                    <div class="post">
                        <div class="entry">
                            <%
                            String teleAppHash=request.getParameter("teleAppHash");
                            consultantBacking.setSelectedTeleAppointment(null);
                            if(teleAppHash!=null && teleAppHash.length()>0)
                            {
                                consultantBacking.setSelectedTeleAppointment(consultantBacking.getSelectedPatientToViewHistory().getTeleAppointmentByHash(teleAppHash));
                            }
                            
                            if(consultantBacking.getSelectedTeleAppointment()!=null && consultantBacking.getSelectedTeleAppointment().getId()!=null && consultantBacking.getSelectedTeleAppointment().getId().length()>0)
                            {
                            %>
                            <form method="post" action="actions/add_advice_action.jsp">
                                <input type="hidden" name="teleAppId" value="<%= consultantBacking.getSelectedTeleAppointment().getId() %>"/>
                                <center>
                                    <textarea name="adviceText" cols="60" rows="15"><%= consultantBacking.getSelectedTeleAppointment().getTeleAdvice() %></textarea>
                                    <br/>
                                    <br/>
                                    <input type="submit" value="<%= langBacking.getLiteral("save") %>"/>
                                </center>
                            </form>
                            <%
                            }
                            else
                            {
                            %>
                            <center>
                                <a href="viewPatientHistory.jsp?patId=<%= consultantBacking.getSelectedPatientToViewHistory().id %>" target="_parent"><input type="button" value="<%= langBacking.getLiteral("return") %>" /></a>
                            </center>
                            <%
                            }
                            %>
                            
                            
                        </div>
                    </div>

                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
            </div>
        </div>
            
    </div>
                            
    <script language="javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button'],:input[type='submit']").button();
    </script>
    
    </body>

</html>