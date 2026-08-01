
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title>404</title>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="style.css" rel="stylesheet" type="text/css" media="screen"/>
        
    </head>
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "home"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    
                    <div class="post">
                        <h2 class="title">
                            <a href="#">Η σελίδα δεν υπάρχει</a>
                            
                            <!--
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <a href="index.jsp?lang=english"><img src="images/en.png"/></a>
                            &nbsp;
                            <a href="index.jsp?lang=greek"><img src="images/el.gif" width="21px"/></a>
                            -->
                        </h2>
                        <div class="entry">
                            <br/><br/><br/><br/>
                        </div>
                    </div>
                </div>
		<!-- end #content -->
<!--		<div id="sidebar">
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