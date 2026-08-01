<%-- 
    Document   : deleteRecord
    Created on : May 17, 2012, 1:36:33 PM
    Author     : Vlasis
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>wijdialog - Modal Message</title>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="description" content="Model Message" />
    <meta name="keywords" content="" />
    <meta name="author" content="ComponentOne" />
    
    <!--jQuery References-->
    <script src="http://ajax.aspnetcdn.com/ajax/jquery/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.18/jquery-ui.min.js" type="text/javascript"></script>
    <!--Theme -->
    <link href="http://cdn.wijmo.com/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
    <!--Wijmo Widgets CSS-->
    <link href="http://cdn.wijmo.com/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
    <!--Sample Dependencies-->
    <script src="http://cdn.wijmo.com/external/amplify.core.min.js" type="text/javascript"></script>
    <script src="http://cdn.wijmo.com/external/amplify.store.min.js" type="text/javascript"></script>
    <script src="http://cdn.wijmo.com/external/jquery.cookie.js" type="text/javascript"></script>
    <script src="http://cdn.wijmo.com/external/jquery.tmpl.min.js" type="text/javascript"></script>
    <script src="http://cdn.wijmo.com/external/swfobject.js" type="text/javascript"></script>
    <!--Wijmo Widgets JavaScript-->
    <script src="http://cdn.wijmo.com/jquery.wijmo-open.all.2.0.5.min.js" type="text/javascript"></script>
    <script src="http://cdn.wijmo.com/jquery.wijmo-complete.all.2.0.5.min.js" type="text/javascript"></script>
    <script src="http://cdn.wijmo.com/external/cultures/globalize.cultures.js" type="text/javascript"></script>

       <script type="text/javascript">
        $(document).ready(function () {
            //$(":wijmo-wijdialog").wijdialog("destroy").remove();
            $("#confirmDelete").wijdialog({
                autoOpen: true,
                resizable: false,
                height: 210,
                width: 450,
                modal: true,
                buttons: {
                    "confirm": function () {
                        $(this).wijdialog("close");
                        window.location = "deleteCart.jsp?id="+document.getElementbyId("cartID").value;
                    },
                    Cancel: function () {
                        $(this).wijdialog("close");
                    }
                }

            });
        });
    </script>
</head>
    <body>
         <div id="confirmDelete" title="Delete Cart">
                        <p>
                        <span class="ui-icon ui-icon-alert"></span>
                        Please confirm the Deletion of the Cart with id:<% request.getParameter("id");%>
                        </p>
                    </div>
    </body>
    
    <input type="hidden" id="cartID" value=<% request.getParameter("id");%>></input>
    
</html>

