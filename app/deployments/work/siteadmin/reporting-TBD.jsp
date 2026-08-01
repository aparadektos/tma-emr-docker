
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- Initializations -->
<%
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
SiteAdminBacking siteAdminBacking=(SiteAdminBacking)session.getAttribute("siteAdminBacking");
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

    
<body onload="resetCalendar()">

        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "reporting"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" style="width:100%">
                    
                    <%
                    if(siteAdminBacking!=null && siteAdminBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:1000px;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteAdminBacking.resetMessages();
                    %>
                    
                    <div class="post">
                        
                        <div class="entry">

                        <%
                        String ticket = "";
                        String USER_AGENT = "Mozilla/5.0";
                        try
                        {
                            String url = "http://efimeries.dexteraconsulting.com:8000/trusted";//
                            java.net.URL urlObj = new java.net.URL(url);
                            HttpURLConnection con = (HttpURLConnection) urlObj.openConnection();

                            con.setRequestMethod("POST");
                            con.setRequestProperty("User-Agent", USER_AGENT);
                            con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

                            String urlParameters = "username=sdontas";//gws_rd=ssl

                            con.setDoOutput(true);
                            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
                            wr.writeBytes(urlParameters);
                            wr.flush();
                            wr.close();

                            int responseCode = con.getResponseCode();
                            System.out.println("\nSending 'POST' request to URL : " + url);
                            System.out.println("Post parameters : " + urlParameters);
                            System.out.println("Response Code : " + responseCode);

                            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
                            String inputLine;
                            StringBuffer pageResponse = new StringBuffer();

                            while ((inputLine = in.readLine()) != null) 
                            {
                                pageResponse.append(inputLine);
//                                out.println(inputLine);
                            }
                            in.close();

                            ticket = pageResponse.toString();
                            
                            System.out.println("ticket = "+ticket);
                        }
                        catch(Exception e)
                        {
                            e.printStackTrace();
                        }
                        %>
                        
                            <script type='text/javascript' src='http://efimeries.dexteraconsulting.com:8000/javascripts/api/viz_v1.js'></script>

                            <div class='tableauPlaceholder' style='width: 1000px; height: 900px;'>
                                <object class='tableauViz' width='1000px' height='900px' style='display:none;'>
                                    <param name='name' value='_26/sheet0' />
                                    <param name='tabs' value='no' />
                                    <param name='toolbar' value='no' />
                                    <param name="ticket" value="<%= ticket %>" />
                                </object>
                            </div>
                        
                        </div>
                    </div>
                    
                </div>

		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>

    </body>
    
</html>