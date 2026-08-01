<%@page import="java.util.Calendar"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="beans.ExamTypeBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="beans.timeslotBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.docAvBean"%>
<%@page import="java.util.Date"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>

<%
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
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

        
        
    <body>
        
        <div id="popup"></div>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "patients"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    <%
                    if(siteDoctorBacking!=null && siteDoctorBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteDoctorBacking!=null && siteDoctorBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteDoctorBacking!=null && siteDoctorBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteDoctorBacking.resetMessages();
                    %>
                    
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("new_tele_appointment_confirm") %></a></h2>
                        <div class="entry">
                            <%
                            TeleAppointmentBean savedTeleAppointment = null;
                            if(siteDoctorBacking.getTeleAppointmentIdToConfirm()!=null && siteDoctorBacking.getTeleAppointmentIdToConfirm().length()>0)
                            {
                                savedTeleAppointment=siteDoctorBacking.getTeleAppointmentById(siteDoctorBacking.getTeleAppointmentIdToConfirm());
                            %>
                            <table>
                                <tr>
                                    <td align="right">
                                        <b><%= langBacking.getLiteral("code") %></b>:
                                        <br/><br/>
                                    </td>
                                    <td align="left">
                                        <b><%= savedTeleAppointment.getReadableId() %></b>
                                        <br/><br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("stis") %>:
                                    </td>
                                    <td align="left">
                                        <%= savedTeleAppointment.getStisBean1().getTitle()+" ("+savedTeleAppointment.getStisBean1().getNosokomeio()+")" %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("specialty") %>:
                                    </td>
                                    <td align="left">
                                        <%= savedTeleAppointment.getConsultantBean1().getSpecialtyBean().getNameEl() %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("consultant") %>:
                                    </td>
                                    <td align="left">
                                        <%= savedTeleAppointment.getConsultantBean1().getName()+" "+savedTeleAppointment.getConsultantBean1().getSurname() %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("date_time") %>:
                                    </td>
                                    <td align="left">
                                        <%= savedTeleAppointment.getStartDateTimeStr(langBacking.getDateFormat()) %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("comment") %>:
                                    </td>
                                    <td align="left">
                                        <%= savedTeleAppointment.getComments() %>
                                    </td>
                                </tr>
                            </table>
                            <%
                            }
                            else
                            {
                                out.println("invalid_tele_appointment");
                            }
                            %>
                        </div>
                    </div>
                </div>
                    
		<!-- end #content -->
            <div id="sidebar">
                <ul>
                    <li>
                        <h2><%= langBacking.getLiteral("actions") %></h2>
                        <ul>
                            <li><a href="patients.jsp"><%= langBacking.getLiteral("search_patient") %></a></li>
                            <li><a href="addNewPatient.jsp"><%= langBacking.getLiteral("add_patient") %></a></li>
                            <li><a href="emergency.jsp?patient=unknown">Έκτακτο Περιστατικό <br/>Αγνώστου Ασθενούς</a></li>
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
    
<script type="text/javascript">
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();
$("input[type=submit]").button();

$("#specialtySelectId").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#previewDatePicker").wijinputdate({
<%
if(langBacking.lang.equalsIgnoreCase("greek"))
{
    out.println("culture: 'el-GR',");
}
%>
dateFormat: '<%= langBacking.getDateFormat() %>',
date: '<%= siteDoctorBacking.getNewTeleappointment().getStartDateStr(langBacking.getDateFormat()) %>',
//date: '12/8/2012',
//dateFormat: 'dddd',
showTrigger: true
});

</script>
    
    </body>
</html>