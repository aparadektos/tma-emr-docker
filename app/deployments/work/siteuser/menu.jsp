<%@page import="backings.LanguageBacking"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>

<div id="header">
    <div id="menu">
        <ul>
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("patients")){
            %>
                <li class="current_page_item"><a href="patients.jsp" class="first"><%= langBacking.getLiteral("patients") %></a></li>
            <%
            }
            else{
            %>
                <li><a href="patients.jsp"><%= langBacking.getLiteral("patients") %></a></li>
            <%
            }
            %>
            
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("appointments")){
            %>
                <li class="current_page_item"><a href="appointments.jsp" class="first"><%= langBacking.getLiteral("appointments") %></a></li>
            <%
            }
            else{
            %>
                <li><a href="appointments.jsp"><%= langBacking.getLiteral("appointments") %></a></li>
            <%
            }
            %>
            
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("emergencies")){
            %>
                <li class="current_page_item"><a href="emergencies.jsp" class="first"><%= langBacking.getLiteral("emergencies") %></a></li>
            <%
            }
            else{
            %>
                <li><a href="emergencies.jsp"><%= langBacking.getLiteral("emergencies") %></a></li>
            <%
            }
            %>
            
            <li><a href="../logout.jsp"><%= langBacking.getLiteral("logout") %></a></li>
            
            
            
            <%
            //if(request.getAttribute("target")!=null && request.getAttribute("target").equals("apCalendar")){
            %>
                <!--<li class="current_page_item"><a href="apCalendar.jsp" class="first">Calendar</a></li>-->
            <%
//            }
//            else{
            %>
                <!--<li><a href="apCalendar.jsp">Calendar</a></li>-->
            <%
//            }
            %>
            
            
            
        </ul>
    </div>
</div>
