
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title>tConsult Online Scheduling v.0000001</title>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="style.css" rel="stylesheet" type="text/css" media="screen"/>
        
<!--  CALENDAR LIBs  -->
        <script src="wijmotools/external/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="wijmotools/external/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
        <script src="wijmotools/external/globalize.min.js" type="text/javascript"></script>
        <script src="wijmotools/external/cultures/globalize.cultures.js" type="text/javascript"></script>
        <script src="wijmotools/external/jquery.mousewheel.min.js" type="text/javascript"></script>
        <script src="wijmotools/external/jquery.wijmo-open.all.2.0.5.min.js" type="text/javascript"></script>
        <link href="wijmotools/themes/wijmo/jquery.wijmo-open.2.0.5.css" rel="stylesheet" type="text/css" />
        <script src="wijmotools/wijmo/jquery.plugin.wijtextselection.js" type="text/javascript"></script>
        <script src="wijmotools/wijmo/jquery.wijmo.wijinputcore.js" type="text/javascript"></script>
        <script src="wijmotools/wijmo/jquery.wijmo.wijinputdate.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/amplify.core.min.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/amplify.request.min.js" type="text/javascript"></script>
        <script src="wijmotools/explore/js/amplify.store.min.js" type="text/javascript"></script>
        <link href="wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" />
        <link href="wijmotools/themes/wijmo/jquery.wijmo.wijinput.css" rel="stylesheet" type="text/css" />
        <script src="wijmotools/wijmo/jquery.wijmo.wijdatepager.js" type="text/javascript"></script>
        <script src="wijmotools/wijmo/jquery.wijmo.wijevcal.js" type="text/javascript"></script>
        <link href="wijmotools/themes/wijmo/jquery.wijmo.wijevcal.css" rel="stylesheet" type="text/css" />
        <link href="wijmotools/themes/wijmo/jquery.wijmo.wijdatepager.css" rel="stylesheet" type="text/css" />
    </head>
    
<!--    API: http://wijmo.com/wiki/index.php/Events_Calendar-->
    <script type="text/javascript">
    $(document).ready(function () {
    $("#eventscalendar").wijevcal();
    
    $("#eventscalendar").wijevcal({ viewType: "month" });
    
    //$("#eventscalendar").wijevcal({ selectedDate: new Date(2012, 6, 21) });
    
    //$("#eventscalendar").wijevcal({ rightPaneVisible: false });
    
    //$("#eventscalendar").wijevcal({ navigationBarVisible: false });
    
    //$("#eventscalendar").wijevcal({ headerBarVisible: false });
    
    $("#eventscalendar").wijevcal({ firstDayOfWeek: 1 });
    
    //$("#eventscalendar").wijevcal("option",  "disabled", true);

    
             $("#eventscalendar").wijevcal("addEvent", {
           //year,month,day,hour,min
             id:"0",
             start: new Date(2012,6,21,7,0),
             end: new Date(2012,6,21,10,0),
             subject: "Scheduled",
             color: "red"
          });   
          $("#eventscalendar").wijevcal("goToEvent", "0");

          $("#eventscalendar").wijevcal("addEvent", {
           //year,month,day,hour,min
             id:"1",
             start: new Date(2012,6,19,7,0),
             end: new Date(2012,6,19,8,30),
             subject: "Scheduled",
             color: "red"
          });   

          $("#eventscalendar").wijevcal("goToEvent", "1");
    });
    </script>
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "calendar"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">                  
                    
                    <div style="width:750px;" id="eventscalendar"></div>

                </div>
		<!-- end #content -->
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2>submenu</h2>
                            <ul>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                                <li><a href="#">Some link here</a></li>
                            </ul>
                        </li>
                        <li>
                            <h2>useful</h2>
                            <p>Thank you for downloading this template. This or any other template  is  free for personal use, but you must leave our link on this page. </p>
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
</html>