<%@page import="backings.LanguageBacking"%>
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>
<div id="header">
    <div id="menu" style="width:100%">
        <ul>
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("reporting"))
            {
                out.println("<li class='current_page_item'><a href='reporting.jsp' class='first'>"+langBacking.getLiteral("reporting")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='reporting.jsp'>"+langBacking.getLiteral("reporting")+"</a></li>");
            }
            %>
            
            <li><a href="../logout.jsp"><%= langBacking.getLiteral("logout") %></a></li>
            
        </ul>
    </div>
</div>
