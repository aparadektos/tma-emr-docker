<%@page import="beans.DoctorBean"%>
<%@page import="beans.patBean"%>
<%@page import="beans.cartBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.docAvBean"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.DoctorBean"%>
<%@page import="beans.ModalityBean"%>

<!-- Initializations -->
<%
//retrieve objects from session (if necessary)
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
        <script src="../wijmotools/external/jquery.mousewheel.min.js" type="text/javascript"></script>
        <script src="../wijmotools/external/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
        <link href="../wijmotools/wijmo/jquery.wijmo.wijcombobox.css" rel="stylesheet" type="text/css" />
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

    </head>

<!-- Javascript functions  -->
<script type="text/javascript">
function loadDocsAvCalendar()
{
    alert("filter by doctor");
//    var docID=document.getElementById("docFilter").value;
//    if (id!="allDocs")
//    {
//        window.location="apCalendar.jsp?docID="+docID;
//    }
}

function resetCalendar()
{
//    $("#docAvCalendar").wijevcal("deleteEvent", 1);
}
</script>

<!-- javascript pou prepei na paiksei molis fortwthei h selida -->
<script id="scriptInit" type="text/javascript">
$(document).ready(function ()
{
$("#apCalendar").wijevcal();
$("#apCalendar").wijevcal({ viewType: "day" });
$("#apCalendar").wijevcal({ firstDayOfWeek: 1 });

//empty it
//for (i=0;i<31;i++)
//{
//    $("#docAvCalendar").wijevcal("deleteEvent", 1);
//}

<%
if(request.getParameter("view")!=null && request.getParameter("view").length()>0 && request.getParameter("view").equals("avCalendar") && request.getParameter("docID")!=null && request.getParameter("docID").length()>0)
{
    String docID=request.getParameter("docID");
    docAvBean DAB=DBH.getDoctorAvailabilityBean(docID);

    //........
}
%>





//$("#eventscalendar").wijevcal({ selectedDate: new Date(2015, 11, 21) });
//$("#eventscalendar").wijevcal({ rightPaneVisible: false });
//$("#eventscalendar").wijevcal({ navigationBarVisible: false });
//$("#eventscalendar").wijevcal({ headerBarVisible: false });
//$("#eventscalendar").wijevcal("option",  "disabled", true);

//            $("#eventscalendar").wijevcal("updateCalendar", {
//            name: "My calendar",
//            location: "Home",
//            description: "Some description",
//            color: "lime" });

//    $("#eventscalendar").wijevcal("addEvent", {
//    //year,month,day,hour,min
//    id:1234,
//    start: new Date(2012, 4, 1, 13, 32),
//    end: new Date(2012, 4, 1, 13, 50),
//    subject: "Subject123" });

//    $("#eventscalendar").wijevcal("deleteEvent", 1234);
//$("#eventscalendar").wijevcal("goToEvent", "1234");


$("#docFilter").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#cartFilter").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#patFilter").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});


$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$("#startTimePicker").wijdropdown();
$("#endTimePicker").wijdropdown();
//$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();

$("#startDatePicker").wijinputdate({
//sto edit h hmeromhnia pairnaei apo to bean kai to script auto tha prepei na paei katw apo to select
//date: '12/8/2012',
//dateFormat: 'dddd',
showTrigger: true
});

$("#endDatePicker").wijinputdate({
showTrigger: true
});

});
</script>

<body onload="">

    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "apCalendar"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->

	<div id="page">
            <div id="page-bgtop">
		<div id="content">

                    <%
                    //theloume appointList vash twn filters

                    ArrayList<DoctorBean> docList=DBH.getAllDoctors();
                    ArrayList<ModalityBean> modalityList=DBH.getAllModalitiesBySite(AB.SB.id);
                    ArrayList<patBean> patList=DBH.getAllPatientsBySite(AB.SB.id);
                    %>
                    <div class="post">
                        <h2 class="title">
                            <a href="#">Appointments Calendar</a></h2>
                            <div class="entry">

                            <table border="0">
                                <tr>
                                    <td>
                                        Doctor
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        Modality
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        Patient
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select id="docFilter" onchange="javascript:loadDocsAvCalendar();">
                                        <option selected value="allDocs">All doctors</option>
                                        <%
                                        for(int i=0; i<docList.size(); i++)
                                        {
                                            DoctorBean docBean=docList.get(i);
                                            out.println("<option value='"+docBean.id+"'>"+docBean.name+" "+docBean.surname+"</option>");
                                        }
                                        %>
                                        </select>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <select id="cartFilter" onchange="alert('filter by modality');">
                                        <option selected value="allModalities">All modalities</option>
                                        <%
                                        for(int i=0; i<modalityList.size(); i++)
                                        {
                                            ModalityBean MB=modalityList.get(i);
                                            out.println("<option value='"+MB.id+"'>"+MB.name+" ("+MB.manufacturer+")</option>");
                                        }
                                        %>
                                        </select>
                                    </td>
                                        <td>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <select id="patFilter" onchange="alert('filter by patient');">
                                        <option selected value="allPatients">All patients</option>
                                        <%
                                        for(int i=0; i<patList.size(); i++)
                                        {
                                            patBean PB=patList.get(i);
                                            out.println("<option value='"+PB.id+"'>"+PB.name+" "+PB.surname+"</option>");
                                        }
                                        %>
                                        </select>
                                    </td>
                                </tr>
                            </table>

                            <br/>

                            <div style="width:750px;" id="apCalendar"></div>

<br/><i>Tip: by default calendar will display all appointments. however the user will be able to apply filters.</i>

                        </div>
                    </div>
                </div>
		<!-- end #content -->
<!--		<div id="sidebar">
                    <ul>
                        <li>
                            <h2>Options/Actions</h2>
                            <ul>
                                <li><a href="#">abc</a></li>
                                <li><a href="#">def</a></li>
                                <li><a href="#">ghi</a></li>
                            </ul>
                        </li>
                        <li>
                            <h2>useful</h2>
                            <p>Thank you for downloading this template. This or any other template  is  free for personal use, but you must leave our link on this page. </p>
                        </li>
                    </ul>
                </div>-->
		<!-- end #sidebar -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>

    </body>
</html>