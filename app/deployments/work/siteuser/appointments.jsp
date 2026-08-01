<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="org.jboss.weld.bootstrap.events.AbstractProcessProducerBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ModalityBean "%>

<!-- Initializations -->
<%
//retrieve DBH from session
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
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
<!--        <link href="../wijmotools/wijmo/jquery.wijmo.wijcombobox.css" rel="stylesheet" type="text/css" />-->
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
        <script src="../wijmotools/wijmo/jquery.wijmo.wijcombobox.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijinputdate.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijtextselection.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijinputcore.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijevcal.js" type="text/javascript"></script>
        
        <script src="../wijmotools/external/cultures/globalize.culture.el-GR.js" type="text/javascript"></script>
    </head>

<!-- Javascript functions  -->
<script language="javascript">

function loadListByCartId()
{
    var cartId=document.getElementById("cartFilter").value;
    alert("Load cart List with id"+cartId);
    window.location = "appointments.jsp?cartId="+cartId;
}

function loadListByPatId()
{
    var patId=document.getElementById("patFilter").value;
    alert("Load patient List with id"+patId);
    window.location = "appointments.jsp?patId="+patId;
}


function showAppDetailsForm(appId){
    //alert("VB"+appId);
   // document.getElementById("showAppDetailsDiv").style.display = "inline";
   // document.getElementById("docPatCartFilters").style.display = "none";
   window.location="appointments.jsp?view=appDetails&id="+appId;
}

    
</script>

<!-- javascript pou prepei na paiksei molis fortwthei h selida -->
<script id="scriptInit" type="text/javascript">
$(document).ready(function () {

$("#appStartDatePicker").wijinputdate({
    <%
    if(langBacking.lang.equalsIgnoreCase("greek"))
    {
        out.println("culture: 'el-GR',");
    }
    %>
<%
if(siteUserBacking.appointmentSearchDateStr!=null && siteUserBacking.appointmentSearchDateStr.length()>0)
{
    out.println("date: '"+siteUserBacking.appointmentSearchDateStr+"',");
}
%>
//date: '12/8/2012',
dateFormat: '<%= langBacking.getDateFormat() %>',
showTrigger: true

});




});


</script>
    
    <body>

    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "appointments"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    
                    <%
                    if(siteUserBacking!=null && siteUserBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteUserBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteUserBacking!=null && siteUserBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteUserBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteUserBacking!=null && siteUserBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteUserBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteUserBacking.resetMessages();
                    %>
                    
                <%
                 if(request.getParameter("view")!=null && request.getParameter("id")!=null && request.getParameter("id").length()>0 && request.getParameter("view").equals("appDetails"))
                 {
                    appointmentsBean APPB=DBH.getAppointmentById(request.getParameter("id"));
                    String isExternal,isNewpatient;
                    if (APPB.isexternal.equals("1")){
                        isExternal="Yes";
                    }
                    else{
                        isExternal="No";
                    }
                 %>
                        <!-- div that contains appointment details -->
                        <div class="post" id="showAppDetailsDiv">
                        <h2>Appointment with id: <b><%= APPB.id%></b></h2>
                              <table border="0">
                                    <tr>
                                        <td>Site ID:</td>
                                        <td>
                                            <input disabled value="<%= APPB.siteid%>" name="appSiteid" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Account ID:</td>
                                        <td>
                                            <input disabled value="<%= APPB.accountid%>" name="appAccountid" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Patient ID:</td>
                                        <td>
                                            <input disabled value="<%= APPB.patid%>" name="appPatid" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Modality ID:</td>
                                        <td>
                                            <input disabled value="<%=APPB.modalityid%>" name="appCartid" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Date:</td>
                                        <td>
                                            <input disabled value="<%= (APPB.startdatetime).toString() %>" name="appDatetime" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Duration:</td>
                                        <td>
                                            <input disabled value="<%= APPB.duration %>" name="appDuration" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>    
                                    <tr>
                                        <td>External:</td>
                                        <td>
                                            <input disabled value="<%= isExternal%>" name="appExternal" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Status ID:</td>
                                        <td>
                                            <input disabled value="<%= APPB.status%>" name="appStatusid" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>    
                                    <tr>
                                        <td>Comments:</td>
                                        <td>
                                            <textarea disabled name="appComments" id="area" rows="3" cols="50"><%= APPB.comments%></textarea>
                                        </td>
                                    </tr>     
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input   type="button" value="OK" onClick="window.location='appointments.jsp'"/>
                                    </td>
                                    </tr>
                                </table>
                     </div>
                  <%}
                 
                 else{ %>
                    <!-- div that contains all appointments and filters -->
                    <div id="docPatCartFilters" class="post">
                     <%     
                            ArrayList<ExamroomsBean> exRoomsList=DBH.getExamRoomsBySiteID(AB.SB.id);
                      %>      
                      
                      <h2 class="title">
                        <a href="#"><%= langBacking.getLiteral("appointments") %></a>
                    </h2>
                      <div class="entry">
                          <form name="searchAppointmentsForm" action="actions/search_appointments_action.jsp" method="post">
                             <table border="0">
                                <tr>
                                    <td>
                                        <%= langBacking.getLiteral("examination_room") %>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <%= langBacking.getLiteral("date") %>
                                    </td>
                                </tr>
                                <tr>        
                                    <td>
                                        <select id="roomFilter" style="width: 200px;" name="roomFilter">
                                        <%
                                        if(siteUserBacking.appointmentSearchExamRoomId==null)
                                        {
                                            out.println("<option selected value='All rooms'>"+langBacking.getLiteral("all_rooms")+"</option>");
                                        }
                                        else
                                        {
                                            out.println("<option value='All rooms'>"+langBacking.getLiteral("all_rooms")+"</option>");
                                        }
                                        
                                        for(ExamroomsBean exRoom : exRoomsList)
                                        {
                                            if(exRoom.id.equalsIgnoreCase(siteUserBacking.appointmentSearchExamRoomId))
                                            {
                                                out.println("<option selected value='"+exRoom.id+"'>"+exRoom.name+"</option>");
                                            }
                                            else
                                            {
                                                out.println("<option value='"+exRoom.id+"'>"+exRoom.name+"</option>");
                                            }
                                        }
                                        %>
                                        </select>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                        <td valign="top">
                                        <input type="text" id="appStartDatePicker" name="appStartDatePicker" />
                                    </td> 
                                </tr>
                                <tr>
                                    <td>
                                      <input type="submit" value="<%= langBacking.getLiteral("search") %>"/>
                                   </td>            
                                </tr>        
                            </table>
                        </form>
                      </div>
                        </div>
                    <% } %>
                    
                    <%
                    ArrayList<appointmentsBean> APPList=siteUserBacking.appointmentsSearchResults;
                    if(APPList!=null && APPList.size()>0)
                    {
                    %>
                    <div class="post" style="width: 800px;" >
<!--                        <h2 class="title"><a href="#">Appointments Table</a></h2>-->
                        <div class="entry">
                            <%
                            
                            if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("patientSentError"))
                            {
                                out.println("<font color='red'>Appointment failed to be sent to PACS.</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("patientSentOK"))
                            {
                                out.println("<font color='green'>Appointment sent to PACS!</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("invalidAppID"))
                            {
                                out.println("<font color='red'>Invalid appointment</font><br/><br/>");
                            }
                            %>
                                <script id="scriptInit" type="text/javascript">
                                $(document).ready(function () {
                                    $("#patientAppointmentsTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 10,
                                        allowColSizing: true,
                                        data: [
                                <%
                                    for(int i=0; i<APPList.size(); i++)
                                    {
                                        appointmentsBean APPB=APPList.get(i);

                                        String appointmentDetails="";
                                        appointmentDetails+=langBacking.getLiteral("examination_type")+": "+APPB.ETB.getDescriptionEl()+"<br/>";
                                        
                                        if(APPB.ExamRoomBean.deleted.equalsIgnoreCase("true"))
                                        {
                                            appointmentDetails+=langBacking.getLiteral("examination_room")+": <del>"+APPB.ExamRoomBean.name+"</del><br/>";
                                        }
                                        else
                                        {
                                            appointmentDetails+=langBacking.getLiteral("examination_room")+": "+APPB.ExamRoomBean.name+"<br/>";
                                        }
                                        
                                        if(APPB.MB!=null && APPB.MB.id!=null && APPB.MB.id.length()>0 && APPB.MB.name.length()>0)
                                        {
                                            if(APPB.MB.deleted.equalsIgnoreCase("true"))
                                            {
                                                appointmentDetails+=langBacking.getLiteral("modality")+": <del>"+APPB.MB.name+"/"+APPB.MB.type+"</del><br/>";
                                            }
                                            else
                                            {
                                                appointmentDetails+=langBacking.getLiteral("modality")+": "+APPB.MB.name+"/"+APPB.MB.type+"<br/>";
                                            }
                                        }
                                        appointmentDetails+=langBacking.getLiteral("duration")+": "+APPB.duration+" minutes<br/>";
                                        appointmentDetails+=langBacking.getLiteral("comment")+": "+APPB.comments+"<br/>";
                                        appointmentDetails+=langBacking.getLiteral("status")+": "+langBacking.getLiteral(APPB.status)+"<br/>";
                                        appointmentDetails+=langBacking.getLiteral("doctor")+": "+APPB.statusDocBean.name+" "+APPB.statusDocBean.surname+"<br/>";

//                                        String historyDetails="";
//                                        historyDetails+=langBacking.getLiteral("chief_complaint")+": "+APPB.complaint+"<br/>";
//                                        historyDetails+=langBacking.getLiteral("present_illness")+": "+APPB.presentIllness+"<br/>";
//                                        historyDetails+=langBacking.getLiteral("medication")+": "+APPB.medication+"<br/>";
//                                        historyDetails+=langBacking.getLiteral("alergies")+": "+APPB.alergies+"<br/>";
//                                        historyDetails+=langBacking.getLiteral("past_health_history")+": "+APPB.pastHistory+"<br/>";
//                                        historyDetails+=langBacking.getLiteral("family_history")+": "+APPB.familyHistory+"<br/>";

                                        if(i<APPList.size()-1)
                                        {
                                            out.println("['"+APPB.getAppointmentDateTimeStr(langBacking.getDateFormat())+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+APPB.PB.id+"\">"+APPB.PB.name+"<br/>"+APPB.PB.surname+"','"+appointmentDetails+"'],");
                                        }
                                        else
                                        {
                                            out.println("['"+APPB.getAppointmentDateTimeStr(langBacking.getDateFormat())+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+APPB.PB.id+"\">"+APPB.PB.name+"<br/>"+APPB.PB.surname+"','"+appointmentDetails+"']");
                                        }
                                    }
                                %>
                                ],
                                columns: [
                                    { headerText: "<%= langBacking.getLiteral("date_time") %> - <%= langBacking.getLiteral("patient") %>" }, { headerText: "<%= langBacking.getLiteral("appointment_details") %>" }
                                ]
                                });
                            });
                            </script>
                            <table id='patientAppointmentsTable'></table>
                        </div>
                    </div>
                <%
                }
                %>
                </div>
		<!-- end #content -->
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="patients.jsp"><%= langBacking.getLiteral("add_new_appointment") %></a></li>
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
    
    </body>
    
    <script language="javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $("#select1").wijdropdown();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button'],:input[type='submit']").button(); 
        $("#roomFilter").wijdropdown();
        //$(":input[type='radio']").wijradio();
        $("#filter").wijdropdown();
    </script>
    
</html>