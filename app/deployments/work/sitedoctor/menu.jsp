<%@page import="backings.LanguageBacking"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>


<script language="javascript">
function popupCounterDeskContact()
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("emergency_contact") %>",
        width: 500, 
        height: 600, 
        modal: true,
        contentUrl: 'popupCounterDeskContact.jsp', 
        captionButtons: {
            pin: { visible: false },
            refresh: { visible: true },
            toggle: { visible: false },
            minimize: { visible: true },
            maximize: { visible: true }
        },
        autoOpen: true
    });
}
</script>

<div id="popup"></div>

<div id="header" >
    <div id="menu" style="width:1000px;">
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
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("teleAppointments"))
            {
                out.println("<li class='current_page_item'><a href='teleAppointments.jsp' class='first'>"+langBacking.getLiteral("tele-appointments")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='teleAppointments.jsp'>"+langBacking.getLiteral("tele-appointments")+"</a></li>");
            }
            %>
            
            <%
            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("appointments"))
            {
                out.println("<li class='current_page_item'><a href='appointments.jsp' class='first'>"+langBacking.getLiteral("local_appointments")+"</a></li>");
            }
            else
            {
                out.println("<li><a href='appointments.jsp'>"+langBacking.getLiteral("local_appointments")+"</a></li>");
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
            
            <%
//            if(request.getAttribute("target")!=null && request.getAttribute("target").equals("videoCalls"))
//            {
//                out.println("<li class='current_page_item'><a href='videoCalls.jsp'>"+ langBacking.getLiteral("video_calls") +"</a></li>");
//            }
//            else
//            {
//                out.println("<li><a target='_new' href='videoCalls.jsp'>"+ langBacking.getLiteral("video_calls") +"</a></li>");
//            }
            %>
            
<!--            <li><a href='https://www.e-prescription.gr/e-pre/faces/Login' target='_new'><%= langBacking.getLiteral("e_prescription") %></a></li>-->
            
            <li><a href="javascript:popupCounterDeskContact();"><%= langBacking.getLiteral("support") %></a></li>
            
            
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
