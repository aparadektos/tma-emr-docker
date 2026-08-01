<%@page import="backings.LanguageBacking"%>
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>

<div id="header">
    <div id="menu">
        <ul>
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("stis"))
            {
                out.println("<li class='current_page_item'><a href='stis.jsp' class='first'>"+langBacking.getLiteral("stis")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='stis.jsp'>"+langBacking.getLiteral("stis")+"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("sites"))
            {
                out.println("<li class='current_page_item'><a href='sites.jsp' class='first'>"+langBacking.getLiteral("sites")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='sites.jsp'>"+langBacking.getLiteral("sites")+"</a></li>");
            }
                        
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("accounts"))
            {
                out.println("<li class='current_page_item'><a href='accounts.jsp' class='first'>"+langBacking.getLiteral("accounts")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='accounts.jsp'>"+langBacking.getLiteral("accounts")+"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("settings"))
            {
                out.println("<li class='current_page_item'><a href='settings.jsp' class='first'>"+langBacking.getLiteral("settings")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='settings.jsp'>"+langBacking.getLiteral("settings")+"</a></li>");
            }
            %>
            
            <li><a href="../logout.jsp"><%= langBacking.getLiteral("logout") %></a></li>
            
        </ul>
    </div>
</div>
