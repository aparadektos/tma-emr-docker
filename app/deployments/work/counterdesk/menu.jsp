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
                out.println("<li class='current_page_item'><a href='efimeries.jsp'>"+ langBacking.getLiteral("efimeries") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='efimeries.jsp'>"+ langBacking.getLiteral("efimeries") +"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("webinars"))
            {
                out.println("<li class='current_page_item'><a href='webinars.jsp'>"+ langBacking.getLiteral("webinars") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='webinars.jsp'>"+ langBacking.getLiteral("webinars") +"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("contact"))
            {
                out.println("<li class='current_page_item'><a href='contact.jsp'>"+ langBacking.getLiteral("contact") +"</a></li>");
            }
            else
            {
                out.println("<li><a href='contact.jsp'>"+ langBacking.getLiteral("contact") +"</a></li>");
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
