<%@page import="backings.LanguageBacking"%>
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>
<div id="header">
    <div id="menu" style="width:100%">
        <ul>
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("modalities"))
            {
                out.println("<li class='current_page_item'><a href='modalities.jsp' class='first'>"+langBacking.getLiteral("modality")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='modalities.jsp'>"+langBacking.getLiteral("modality")+"</a></li>");
            }

            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("examination_rooms"))
            {
                out.println("<li class='current_page_item'><a href='examinationRooms.jsp' class='first'>"+langBacking.getLiteral("examination_rooms")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='examinationRooms.jsp'>"+langBacking.getLiteral("examination_rooms")+"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("departments"))
            {
                out.println("<li class='current_page_item'><a href='departments.jsp' class='first'>"+langBacking.getLiteral("departments")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='departments.jsp'>"+langBacking.getLiteral("departments")+"</a></li>");
            }
            
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("localAccounts"))
            {
                out.println("<li class='current_page_item'><a href='localAccounts.jsp' class='first'>"+langBacking.getLiteral("accounts")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='localAccounts.jsp'>"+langBacking.getLiteral("accounts")+"</a></li>");
            }

            %>
            
            <li><a href="../logout.jsp"><%= langBacking.getLiteral("logout") %></a></li>
            
        </ul>
    </div>
</div>
