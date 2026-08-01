<%@page import="backings.LanguageBacking"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>

<div id="header">
    <div id="menu">
        <ul>
                
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("efimeries"))
            {
                out.println("<li class='current_page_item'><a href='myEfimeries.jsp'>"+ langBacking.getLiteral("efimeries") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='myEfimeries.jsp'>"+ langBacking.getLiteral("efimeries") +"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("teleAppointments"))
            {
                out.println("<li class='current_page_item'><a href='myTeleAppointments.jsp'>"+ langBacking.getLiteral("tele-appointments") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='myTeleAppointments.jsp'>"+ langBacking.getLiteral("tele-appointments") +"</a></li>");
            }
            
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("videoCalls"))
            {
                out.println("<li class='current_page_item'><a href='videoCalls.jsp'>"+ langBacking.getLiteral("video_calls") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='videoCalls.jsp'>"+ langBacking.getLiteral("video_calls") +"</a></li>");
            }
            
            /*
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("emergencies"))
            {
                out.println("<li class='current_page_item'><a href='emergencies.jsp'>"+ langBacking.getLiteral("emergencies") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='emergencies.jsp'>"+ langBacking.getLiteral("emergencies") +"</a></li>");
            }
            */
            out.println("<li><a href='../logout.jsp'>"+langBacking.getLiteral("logout")+"</a></li>");
            
            %>
            
        </ul>
    </div>
</div>
