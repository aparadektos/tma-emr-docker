<%@page import="java.util.ArrayList"%>
<%@page import="beans.MessageBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="refresh" content="5" />
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../popupStyle.css" rel="stylesheet" type="text/css" media="screen"/>
        
    </head>

<!-- Javascript functions  -->
<script language="javascript">
    
</script>
    
    <body >

    <div id="wrapper">
	
	<div id="page">
            <div id="page-bgtop">
                <div id="content">
                    <table border="0" width="100%">
                    <%
                    ArrayList<MessageBean> recentMessages = paramedicBacking.getRecentMessagesByAccountId(paramedicBacking.AB.id);
                    for(int i=0; i<recentMessages.size(); i++)
                    {
                        MessageBean curMsg = recentMessages.get(i);
                        String curColor="navy";
                        if(curMsg.getFromAccountBean().id.equals(paramedicBacking.AB.id))
                        {
                            curColor="#EEEEEE";
                        }
                        else
                        {
                            curColor="#a7cdf0";
                        }
                        out.println("<tr>");
                            out.println("<td style='background-color: "+curColor+"'>");
                                out.println("<b>"+langBacking.getLiteral("on_date")+" "+curMsg.getDateAndTimeStr(langBacking.getDateFormat())+", "+langBacking.getLiteral("the_user")+" "+curMsg.getFromAccountBean().username+" "+langBacking.getLiteral("user_wrote")+":</b><br/>");
                                out.println(curMsg.getMessage()+"<br/><br/>");
                            out.println("</td>");
                        out.println("</tr>");
                    }
                    %>
                    </table>
                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
            </div>
        </div>
            
    </div>
    
    </body>


</html>