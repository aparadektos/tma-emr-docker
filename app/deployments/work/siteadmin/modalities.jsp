<%@page import="beans.ModalityTypeBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.modalityAvBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.ModalityBean"%>

<!-- Initializations -->
<%
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
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

<!-- Javascript functions  -->
<script language="javascript">
function checkNewModalityForm()
{
    document.getElementById("addModalityForm").submit();
}

function checkEditModalityForm()
{
    document.getElementById("editModalityForm").submit();
}

function confirmModalityDelete(modalityID)
{
    if (confirm("Delete Modality?")) { 
       window.location = "actions/delete_modality_action.jsp?id="+modalityID;
    }
}

function checkNewAvailForm()
{
    document.getElementById("newAvailForm").submit();
}

function loadCalendar(){
    var id=document.getElementById("filter").value;
    if (id=="All carts"){
        window.location="modalities.jsp?view=avCalendar";
    }
    else{
        window.location="modalities.jsp?view=avCalendar&calendarCartId="+id;
    }
}

function resetCalendar(){ 
    var allids=document.getElementById("allCartIds").value;
    for (i=0;i<allids;i++){
       $("#avcalendar").wijevcal("deleteEvent", i);
    }
}

</script>

<!-- javascript pou prepei na paiksei molis fortwthei h selida -->
<script id="scriptInit" type="text/javascript">
$(document).ready(function () {
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();

$("#avcalendar").wijevcal();
$("#avcalendar").wijevcal({ viewType: "month" });
$("#avcalendar").wijevcal({ firstDayOfWeek: 1 });
//$("#avcalendar").wijevcal("option",  "disabled", true);



<% 
if(request.getParameter("view")!=null && request.getParameter("view").length()>0 && request.getParameter("view").equals("avCalendar"))
{
   String cartid=request.getParameter("calendarCartId");
   if (cartid!=null && cartid!="-1"){%>
         
  <%  cartAvBean CAB=DBH.getCartAvailabilityBean(request.getParameter("calendarCartId"));
  %>
      document.getElementById("allCartIds").value="<%=CAB.avPeriodList.size()%>";
   <% int[] startDateTime=new int[5];
      int[] stopDateTime=new int[5];
      for(int i=0; i<CAB.avPeriodList.size(); i++)
      {
          avPeriod AP=CAB.avPeriodList.get(i);
          startDateTime = AP.getStartDate();
          stopDateTime=AP.getEndDate();
   %>         
          $("#avcalendar").wijevcal("addEvent", {
           //year,month,day,hour,min
             id:"<%=Integer.toString(i)%>",
             start: new Date(<%=startDateTime[0]%>,<%=startDateTime[1]%>,<%=startDateTime[2]%>,<%=startDateTime[3]%>,<%=startDateTime[4]%>),
             end: new Date(<%=stopDateTime[0]%>,<%=stopDateTime[1]%>,<%=stopDateTime[2]%>,<%=stopDateTime[3]%>,<%=stopDateTime[4]%>),
             subject: "<%= CAB.cBean.name %>",
             color: "red"
          }); 
          $("#avcalendar").wijevcal("goToEvent","<%=Integer.toString(i)%>");
    <%}%> 
    cartid=null;    
<%}
       else{
       ArrayList<cartBean> cartList = DBH.getAllCartsBySite(AB.SB.id);
       int allSchedules=0;
       int temp=0;
       
       for (int i=0;i<cartList.size();i++){
           cartBean cart=cartList.get(i);
       //    System.out.print("for loop: "+i);
           cartAvBean CAB=DBH.getCartAvailabilityBean(cart.id);
           int[] startDateTime=new int[5];
           int[] stopDateTime=new int[5];
        //   System.out.println("CAB.avPeriodList.size(): "+CAB.avPeriodList.size());
        //   System.out.print("k1: "+temp);
           int test=CAB.avPeriodList.size()+temp;
     //      System.out.print("k2: "+test);
              for (int k=0;k<CAB.avPeriodList.size();k++){
                 allSchedules=allSchedules+1;
                 avPeriod AP=CAB.avPeriodList.get(k);
                 startDateTime = AP.getStartDate();
                 stopDateTime=AP.getEndDate();
              %>
$("#avcalendar").wijevcal({ appointments: [{id: "appt1", start: new Date(2012, 6, 6, 17, 30), end: new Date(2012, 6, 6, 17, 35) }] });
                      
                 $("#avcalendar").wijevcal("addEvent", {
                 //year,month,day,hour,min
                 id:"<%=Integer.toString(allSchedules)%>",
                 start: new Date(<%=startDateTime[0]%>,<%=startDateTime[1]%>,<%=startDateTime[2]%>,<%=startDateTime[3]%>,<%=startDateTime[4]%>),
                 end: new Date(<%=stopDateTime[0]%>,<%=stopDateTime[1]%>,<%=stopDateTime[2]%>,<%=stopDateTime[3]%>,<%=stopDateTime[4]%>),
                 subject: "<%=cart.name%>",
                 color: "red"
                 });
                 $("#avcalendar").wijevcal("goToEvent","<%=Integer.toString(allSchedules)%>");  
              <%}
              //   temp=temp + CAB.avPeriodList.size(); 
            
        }
   //     System.out.print("allSchedules: "+allSchedules);      
 %> 
       document.getElementById("allCartIds").value="<%=Integer.toString(allSchedules)%>";
   <% }%>
      
<%}    
 %>
         

$("#startTime").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#endTime").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#startTimePicker").wijdropdown();
$("#endTimePicker").wijdropdown();
//$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();

$("#filter").wijdropdown();

$("#startDatePicker").wijinputdate({
//sto edit h hmeromhnia pairnaei apo to bean kai to script auto tha prepei na paei katw apo to select
//date: '12/8/2012',
//dateFormat: 'dddd',
showTrigger: true

});

$("#endDatePicker").wijinputdate({
showTrigger: true
});

});
</script>
    
<body onload="resetCalendar()">

        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "modalities"); %>
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
                    
                    
                    <!-- div for cart (i.e. Modality) editing -->
                    <%
                    if(request.getParameter("view")!=null && request.getParameter("view").length()>0 && request.getParameter("view").equals("avCalendar")){
                        ArrayList<cartBean> cartList=DBH.getAllCartsBySite(AB.SB.id);
                        
                    %>    
                    <div class="post">
                        <h2 class="title">
                            <a href="#">Availability Calendar</a></h2>
                            <div class="entry">
                            
                            <table border="0">
                                <tr>
                                    <td>
                                        Select a Modality
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select style="width: 200px;" id="filter" name="filter" onchange="javascript:loadCalendar()">
                                        <option value="selection">selection</option>
                                        <option value="All carts">All Modalities</option>
                                        <%
                                        for(int i=0; i<cartList.size(); i++)
                                        {
                                            cartBean cBean=cartList.get(i);
                                            out.println("<option value='"+cBean.id+"'>"+cBean.name);
                                        }
                                        %>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <%
                               if (request.getParameter("calendarCartId")!=null){
                                   cartBean cart=DBH.getCartByID(request.getParameter("calendarCartId"));
                                  out.println("<h3>Modality info (id: "+cart.id+"): Name: <i>"+cart.name+"</i>, Site id: <i>"+cart.siteid+"</i></h3>");
                               }
                            %>
                            <div style="width:750px;" id="avcalendar">
                                <input type="hidden" id="allCartIds" name="allCartIds" ></input>
                            </div>
                         </div>               
                    </div>               
                    <%}
                    else if(request.getParameter("view")!=null && request.getParameter("id")!=null && request.getParameter("id").length()>0 && request.getParameter("view").equals("avCart"))
                    {
                        modalityAvBean MAB=DBH.getModalityAvailabilityBean(request.getParameter("id"));
                        out.println("<h2 class='title'>Cart: "+MAB.mBean.name+" ("+MAB.mBean.manufacturer+")</h2><br/><br/>");
                        
                        if(request.getParameter("action")!=null && request.getParameter("action").length()>0 && request.getParameter("action").equals("avEdit"))
                        {%>
                            <div class="post" id="editAvailFormDiv">
                               <h2 class="title"><a href="#">Edit availability period</a></h2>
                               <div class="entry">
                                  edit form
                               </div>
                            </div>
                        <%    
                        }
                        else if(request.getParameter("action")!=null && request.getParameter("action").length()>0 && request.getParameter("action").equals("avNew"))
                        {%>
                            <div class="post" id="newAvailFormDiv">
                               <h2 class="title"><a href="#">New availability period</a></h2>
                               <div class="entry">
                                  <form id="newAvailForm" method="post" action="actions/add_avail_action.jsp">
                                     <input type="hidden" value="<%= MAB.mBean.id %>" name="cartid"/>
                                     <table border="0">
                                        <tr>
                                            <td>Start date & time</td>
                                            <td>&nbsp;&nbsp;</td>
                                            <td>End date & time</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="text" id="startDatePicker" name="startDatePicker" />
                                            </td>
                                            <td>&nbsp;&nbsp;</td>
                                            <td>
                                                <input type="text" id="endDatePicker" name="endDatePicker" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select  id="startTimePicker" name="startTimePicker">
                                                    <%
                                                    for(int i=7; i<=24; i++)
                                                    {
                                                        out.println("<option value='"+i+":00'>"+i+":00</option>");
                                                        out.println("<option value='"+i+":30'>"+i+":30</option>");
                                                    }
                                                    for(int i=1; i<7; i++)
                                                    {
                                                        out.println("<option value='"+i+":00'>"+i+":00</option>");
                                                        out.println("<option value='"+i+":30'>"+i+":30</option>");
                                                    }
                                                    %>
                                                </select>
                                            </td>
                                            <td>&nbsp;&nbsp;</td>
                                            <td>
                                                <select id="endTimePicker" name="endTimePicker">
                                                    <%
                                                    for(int i=7; i<=24; i++)
                                                    {
                                                        out.println("<option value='"+i+":00'>"+i+":00</option>");
                                                        out.println("<option value='"+i+":30'>"+i+":30</option>");
                                                    }
                                                    for(int i=1; i<7; i++)
                                                    {
                                                        out.println("<option value='"+i+":00'>"+i+":00</option>");
                                                        out.println("<option value='"+i+":30'>"+i+":30</option>");
                                                    }
                                                    %>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3" align="center">
                                                <input type="button" value="Save" onClick="javascript: checkNewAvailForm();"/>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                                <br/>
                            </div>
                        </div>
                            
                        <%}%>
                        
                        <div class="post">
                            <table border="0" width="100%">
                                <tr>
                                    <td>
                                        <h2 class="title"><a href="#">Availability table</a></h2>
                                    </td>
                                    <td align="right">
                                        <input type="button" value="New" onClick="javascript:window.location='modalities.jsp?view=avCart&action=avNew&id=<%= MAB.mBean.id %>';"/>
                                    </td>
                                </tr>
                            </table>
                            
                            <div class="entry">
                        <%
                        if(MAB.avPeriodList!=null && MAB.avPeriodList.size()>0)
                        {
                        %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#cartAvTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    data: [
                                <%
                                    for(int i=0; i<MAB.avPeriodList.size(); i++)
                                    {
                                        avPeriod AP=MAB.avPeriodList.get(i);
                                        if(i<MAB.avPeriodList.size()-1)
                                        {
                                            out.println("['"+AP.showStart()+"','"+AP.showEnd()+"','"+AP.getDuration()+"','<a href=\"modalities.jsp?view=avCart&action=avEdit&docid="+MAB.mBean.id+"\"><img src=\"../images/availability1.gif\"/></a>'],");
                                        }
                                        else
                                        {
                                            out.println("['"+AP.showStart()+"','"+AP.showEnd()+"','"+AP.getDuration()+"','<a href=\"modalities.jsp?view=avDoctor&action=avEdit&docid="+MAB.mBean.id+"\"><img src=\"../images/availability1.gif\"/></a>']");
                                        }
                                    }
                                %>
                                ],
                                columns: [
                                    { headerText: "Start date&time"}, { headerText: "End date&time" }, { headerText: "Duration (hours)" }, { headerText: " ", width:"20px"}
                                ]
                                });
                            });
                            </script>
                        <%
                        
                            out.println("<table id='cartAvTable'>");
                            out.println("</table>");
                        }
                        else
                        {
                            out.println("There is no availability yet for this Modality!");
                        }
                        %>                     
                        
                        </div>
                        </div>
            <%}
            else
            {
                    if(request.getParameter("view")!=null && request.getParameter("id")!=null && request.getParameter("id").length()>0 && request.getParameter("view").equals("edit"))
                    {
                        ModalityBean editMB=DBH.getModalityByID(request.getParameter("id"));
            %>
                    <div class="post" id="editModalityFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("edit_modality") %></a></h2>
                        <div class="entry">
                            
                            <form id="editModalityForm" method="post" action="actions/edit_modality_action.jsp">
                                <input type="hidden" name="modalityid" value="<%=editMB.id%>"/>
                                <table border="0">
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                        <td>
                                            <input value="<%=editMB.name%>" name="modalityName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("manufacturer") %>:</td>
                                        <td>
                                            <textarea name="modalityManufacturer" id="area" rows="2" cols="50"><%=editMB.manufacturer%></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("type") %>:</td>
                                        <td>
                                            <select id="modalityTypeSelect" style="width: 400px;" name="modalityType">
                                                <%
                                                ArrayList<ModalityTypeBean> modalityTypes = siteAdminBacking.getAllModalityTypes();
                                                for(ModalityTypeBean modType : modalityTypes)
                                                {
                                                    if(editMB.type!=null && modType!=null && editMB.type.equalsIgnoreCase(modType.getName()))
                                                    {
                                                        out.println("<option selected value='"+modType.getName()+"'>"+modType.getName()+" | "+modType.getDescription(langBacking.lang)+"</option>");
                                                    }
                                                    else
                                                    {
                                                        out.println("<option value='"+modType.getName()+"'>"+modType.getName()+" | "+modType.getDescription(langBacking.lang)+"</option>");
                                                    }
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("portable") %>:</td>
                                        <td>
                                            <!-- check the right box -->
                                            
                                            <input type="radio" name="modalityPortable" id="modalitySite" value="modalityPortableYES" <%if(editMB.portable.equals("1")){out.println("checked");}%> >Yes</input>
                                            <input type="radio" name="modalityPortable" id="modalitySite" value="modalityPortableNO" <%if(editMB.portable.equals("0")){out.println("checked");}%>>No</input>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("status") %>:</td>
                                        <td>
                                            <!-- check the right box -->
                                            <input type="radio" name="modalityStatus" id="modalityStatus" value="modalityStatusYES" <%if(editMB.statusid.equals("1")){out.println("checked");}%>>Available</input>
                                            <input type="radio" name="modalityStatus" id="modalityStatus" value="modalityStatusNO" <%if(editMB.statusid.equals("0")){out.println("checked");}%>>Not available</input>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("pacs_communication") %>:</td>
                                        <td>
                                            <%
                                            if(editMB.pacsConnection.equalsIgnoreCase("yes"))
                                            {
                                                out.println("<input type='radio' name='modalityPACS' value='yes' checked='true'>"+langBacking.getLiteral("yes")+"</input>");
                                            }
                                            else
                                            {
                                                out.println("<input type='radio' name='modalityPACS' value='yes'>"+langBacking.getLiteral("yes")+"</input>");
                                            }
                                            if(editMB.pacsConnection.equalsIgnoreCase("no"))
                                            {
                                                out.println("<input type='radio' name='modalityPACS' value='no' checked='true'>"+langBacking.getLiteral("no")+"</input>");
                                            }
                                            else
                                            {
                                                out.println("<input type='radio' name='modalityPACS' value='no'>"+langBacking.getLiteral("no")+"</input>");
                                            }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("serial_number") %>:</td>
                                        <td>
                                            <input name="serialNumber" id="textbox" value="<%= editMB.getSerialNumber() %>" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("ip_address") %>:</td>
                                        <td>
                                            <input name="ipAddress" id="textbox" type="text" size="53" value="<%= editMB.ipAddress%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("ae_title") %>:</td>
                                        <td>
                                            <input name="aeTitle" id="textbox" type="text" size="53" value="<%= editMB.aeTitle%>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("comment") %>:</td>
                                        <td>
                                            <textarea name="modalityComments" id="area" rows="3" cols="50"><%= editMB.comments%></textarea>
                                        </td>
                                    </tr>    
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input type="button" value="Save" onClick="javascript:checkEditModalityForm();"/>
                                    </td>
                                    </tr>
                                </table>
                            </form>
                            
                        </div>
                    </div>
                    <%
                    }%>
                    <!-- div that contains all Carts (i.e. modalities)-->
                    <div class="post" style="width:100%">
                        <table border="0" style="width:1000px;">
                            <tr>
                                <td>
                                    <h2 class="title">
                                        <a href="#"><%= langBacking.getLiteral("all_modalities") %></a>
                                    </h2>
                                </td>
                                <td align="right" width="400px;">
                                    <a href="addNewModality.jsp">
                                        <input type="button" value="<%= langBacking.getLiteral("add_modality") %>" onClick="javascript:checkEditModalityForm();"/>
                                    </a>
                                </td>
                            </tr>
                        </table>
                        <div class="entry">
                            <%
                            //show results
                            if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("AvailabilityError"))
                            {
                                out.println("<font color='red'>Availability cannot be stored!</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("AvailabilityAdded"))
                            {
                                out.println("<font color='green'>Availability stored successfully!</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("error"))
                            {
                                out.println("<font color='red'>Unexpected error!</font><br/><br/>");
                            }
                            %>
                            
                            <%
                            //retrieve all Modalities 
                            ArrayList<ModalityBean> MBList=DBH.getAllModalitiesBySite(AB.SB.id);
                            if(MBList!=null && MBList.size()>0)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#cartsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    data: [
                            <%
                                String isPortable,isAvailable,pacsCon;
                                for(int i=0; i<MBList.size(); i++)
                                {
                                    ModalityBean MB=MBList.get(i);
                                  //  System.err.println(MB.agnesIP);
                                    String hrefs="<a onmouseover=\"ShowContentEdit(); return true;\" onmouseout=\"HideContentEdit();return true;\" href=\"modalities.jsp?view=edit&id="+MB.id+"\"><img alt=\"Edit\" src=\"../images/edit2.png\" width=\"35px\" style=\"border:0px;\"></a>&nbsp;"
                                                    + "&nbsp;<a onmouseover=\"ShowContentDelete(); return true;\" onmouseout=\"HideContentDelete();return true;\" href=\"javascript:confirmModalityDelete("+MB.id+");\"><img alt=\"Delete\" src=\"../images/delete.gif\" width=\"35px\" style=\"border:0px;\"></a>&nbsp;";
                                                    //+ "&nbsp;<a onmouseover=\"ShowContentAvail(); return true;\" onmouseout=\"HideContentAvail();return true;\" href=\"modalities.jsp?view=avCart&id="+MB.id+"\"><img alt=\"View availability\" src=\"../images/availability1.gif\" style=\"border:0px;\"></a>";
                                  
                                   
                                    if (MB.portable.equals("1")){
                                        isPortable="Yes";
                                    }
                                    else{
                                        isPortable="No";
                                    }
                                    if (MB.statusid.equals("1")){
                                        isAvailable="Yes";
                                    }
                                    else{
                                        isAvailable="<font color=\"red\"><b>No</b></font>";
                                    }
                                    
                                    pacsCon=langBacking.getLiteral(MB.pacsConnection);
                                    
                                    if(i<MBList.size()-1)
                                    {
                                        out.println("['<b>"+MB.name+"</b><br/>("+MB.manufacturer+")','<h4>"+MB.type+"</h4>','"+langBacking.getLiteral("portable")+":"+isPortable+"<br/>"+langBacking.getLiteral("available")+":"+isAvailable+"<br/>PACS:"+pacsCon+"', '"+MB.getSerialNumber()+"', '"+MB.comments+"','<h4>"+MB.ipAddress+"</h4>','<h4>"+MB.aeTitle+"</h4>','"+hrefs+"'],");
                                    }
                                    else
                                    {
                                        out.println("['<b>"+MB.name+"</b><br/>("+MB.manufacturer+")','<h4>"+MB.type+"</h4>','"+langBacking.getLiteral("portable")+":"+isPortable+"<br/>"+langBacking.getLiteral("available")+":"+isAvailable+"<br/>PACS:"+pacsCon+"', '"+MB.getSerialNumber()+"', '"+MB.comments+"','<h4>"+MB.ipAddress+"</h4>','<h4>"+MB.aeTitle+"</h4>','"+hrefs+"']");                                     
                                    }
                                }
                            %>
                            ],
                            columns: [
                                     { headerText: "<%= langBacking.getLiteral("name") %> <br/> (<%= langBacking.getLiteral("manufacturer") %>)" }, 
                                     { headerText: "<%= langBacking.getLiteral("type") %>"},
                                     { headerText: "<%= langBacking.getLiteral("other_information") %>"},
                                     { headerText: "<%= langBacking.getLiteral("serial_number") %>"}, 
                                     { headerText: "<%= langBacking.getLiteral("comment") %>"}, 
                                     { headerText: "<%= langBacking.getLiteral("ip_address") %>"},
                                     { headerText: "<%= langBacking.getLiteral("ae_title") %>"}, 
                                     { headerText: "<%= langBacking.getLiteral("actions") %>"}
                            ]
                        });
                    });
                    </script>
                            <%
                                out.println("<table id='cartsTable' style='width:1000px;'>");
                                out.println("</table>");
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_modalities_found"));
                            }
                            %>
                            <br/>
                        </div>
                    </div>
                    <%
                    }%>
                </div>
		<!-- end #content -->
<!--		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%//= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="addNewModality.jsp"><%//= langBacking.getLiteral("add_modality") %></a></li>
                            </ul>
                        </li>
                    </ul>
                </div>-->
		<!-- end #sidebar -->
		<div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>

    </body>
    
    <script language="javascript">
        $("#modalityTypeSelect").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });


    </script>
        
    
    
</html>