<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ExamTypeBean"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="beans.timeslotBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.docAvBean"%>
<%@page import="java.util.Date"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
//retrieve objects from session (if necessary)
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
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
function enlightDV(thisDV,examRoomID)
{
    for(i=0; i<5000; i++)
    {
        if(document.getElementById("DV"+i)!=null)
            document.getElementById("DV"+i).style.background="transparent";
    }
    thisDV.style.background="orange";
    
    document.getElementById("selectedAppDatetime").value=thisDV.title;
    document.getElementById("examRoomIDHidden").value=examRoomID;
}
    
function checkEmergencyForm()
{
    alert("Under development");
}
    
function checkNewPatientForm()
{
    //alert("test");
    document.getElementById("addPatientForm").submit();
}

function checkSearchTimeslotForm()
{
    //alert("test");
    document.getElementById("searchTimeslotForm").submit();
}

function checkSearchPatientForm()
{
    document.getElementById("searchPatientForm").submit();
}

function checkNewAppointForm()
{
    document.getElementById("addAppointmentForm").submit();
}

function popupViewPatient(patId)
{
    $("#popup").wijdialog({ 
        title: "Προβολή στοιχείων ασθενούς",
        width: 500, 
        height: 400, 
        modal: true,
        contentUrl: 'popupViewPatient.jsp?patId='+patId, 
        captionButtons: {
            pin: { visible: false },
            refresh: { visible: false },
            toggle: { visible: false },
            minimize: { visible: true },
            maximize: { visible: true }
        },
        autoOpen: true
    });
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

$("#durationSelector").wijdropdown();

$("#dayObPicker").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#monthObPicker").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#yearObPicker").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#apDoctor").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#apExamType").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#apSpec").wijcombobox({
showingAnimation: { effect: "blind" },
//isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#apDatePicker").wijinputdate({
showTrigger: true
});

<%
String onDate="";
if(request.getParameter("onDate")!=null && request.getParameter("onDate").length()>0)
{
    onDate=request.getParameter("onDate").trim();
    //onDate=11/27/2012
    
    //an to OnDate einai progenestero apo to today, tote onDate=today giati den epitrepetai na ftiaxtei rantevou.
//    Date today=new Date();
//    String curDate=(today.getMonth()+1)+"/"+today.getDate()+"/"+(today.getYear()+1900);
}
String patid="";
if(request.getParameter("patid")!=null && request.getParameter("patid").length()>0)
{
    patid=request.getParameter("patid");
}
%>
$("#previewDatePicker").wijinputdate({
date: '<%=onDate%>',
//date: '12/8/2012',
//dateFormat: 'dddd',
showTrigger: true
});





});
</script>
    
    <body>
        
        <div id="popup"></div>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "patients"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    
                    <%
                    if(request.getParameter("action")!=null && request.getParameter("patid")!=null && request.getParameter("patid").length()>0 &&  request.getParameter("action").length()>0 && request.getParameter("action").equalsIgnoreCase("newAppoint"))
                    {
                        appointmentsBean newAppBean=(appointmentsBean)session.getAttribute("newAppBean");
                        if(newAppBean==null)
                        {
                            patBean PB=siteUserBacking.getPatientById(request.getParameter("patid"));
                            newAppBean=new appointmentsBean("", AB.SB.id, AB.id, PB.id, "", null, null, "", "", "", "", "", "");
                            newAppBean.PB=PB;
                            session.setAttribute("newAppBean", newAppBean);
                        }
                        
                        ArrayList<ExamTypeBean> allExamTypesList=null;
                        if(session.getAttribute("allExamTypesList")!=null)
                        {
                            allExamTypesList=(ArrayList<ExamTypeBean>)session.getAttribute("allExamTypesList");
                        }
                        else
                        {
                            allExamTypesList=DBH.getAllExamTypes();
                            session.setAttribute("allExamTypesList",allExamTypesList);
                        }
                        
                        if(request.getParameter("insertError")!=null && request.getParameter("insertError").trim().length()>0 && request.getParameter("insertError").trim().equals("true"))
                        {
                            out.println("<font color='red'><b>The appointment could not be saved. Try again later or contact IT department.</b></font><br/><br/>");
                        }
                    %>                           
                        <div class="post" id="searchTimeslotFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("new_appointment") %> </a></h2>
                            <table border="0">
                                <tr>
                                    <td>
                                        <table border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("patient_information") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                                <td>
                                                     <%= newAppBean.PB.name %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("surname") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.surname %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("date_of_birth") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.getBirthDateStr(langBacking.getDateFormat()) %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("sex") %>:</td>
                                                <td>
                                                    <%= langBacking.getLiteral(newAppBean.PB.sex.toLowerCase()) %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td>
                                        <table border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("address") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.getAddressStr() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.homephone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.workphone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.mobilephone %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("insurance") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("social_security_number") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.getSsn() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                                <td>
                                                    <%= newAppBean.PB.insurancename %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        <div class="entry">
                            <form id="searchTimeslotForm" method="post" action="actions/search_examroom_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td>Examination type:</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <select id="apExamType" name="apExamType">
                                                <option selected disabled="true" value="">Select examination type</option>
                                                <%
                                                for(ExamTypeBean curExamType : allExamTypesList)
                                                {
                                                    String shortDescr="";
                                                    shortDescr=curExamType.getDescriptionEl();
                                                    if(shortDescr.length()>80)
                                                    {
                                                        shortDescr=shortDescr.substring(0,80);
                                                    }
                                                    if(newAppBean.ETB!=null && curExamType.getId().equals(newAppBean.ETB.getId()))
                                                    {
                                                        out.println("<option selected value='"+curExamType.getId()+"'>"+shortDescr +"</option>");
                                                    }
                                                    else
                                                    {
                                                        out.println("<option value='"+curExamType.getId()+"'>"+shortDescr+"</option>");
                                                    }
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Duration (in minutes):</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <select id="durationSelector" style="width: 200px;" name="appDuration">
                                                <%
                                                for(int i=5; i<=60; i=i+5)
                                                {
                                                    if(newAppBean.duration.length()>0)
                                                    {
                                                        if(i==Integer.parseInt(newAppBean.duration))
                                                        {
                                                            out.println("<option selected value='"+i+"'>"+i+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if(i==15)
                                                        {
                                                            out.println("<option selected value='"+i+"'>"+i+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                    }
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                    <td align="center" colspan="5">
                                        <input type="button" value="<%= langBacking.getLiteral("search") %>" onClick="javascript:checkSearchTimeslotForm();"/>
                                    </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                    </div>
                    <%
                    ArrayList<ExamroomsBean> examRoomsResults=(ArrayList<ExamroomsBean>)session.getAttribute("examRoomsResults");
                    //do not remove examRoomsResults from session because user will select one object of this list.
                    //However, it should be removed at the end of add_appoint_action.jsp
                    
                    if(examRoomsResults!=null)
                    {
                        if(examRoomsResults.size()>0)
                        { 
                    %>

                    <div class="post" id="searchExamRoomsFormDiv">
                        <h2 class="title">
                            <a href="#">Availability table</a></h2>
                        <div class="entry">
                        <form id="addAppointmentForm" method="post" action="actions/add_appoint_action.jsp">
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#timeslotsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 32,
                                    allowColSizing: true,
                                    data: [
                            <%
                                Date today=new Date();
                                String curDate=(today.getMonth()+1)+"/"+today.getDate()+"/"+(today.getYear()+1900);
                                if(onDate!=null && onDate.length()>0)
                                {
                                    curDate=onDate;
                                }
                                int timeslotDuration=Integer.parseInt(newAppBean.duration);
                                int startHour=7;
                                int startMin=0;
                                int hour1=startHour;
                                int min1=startMin;
                                int hour2=0;
                                int min2;
                                
                                //1day = 1440mins (24*60)
                                //totalMins=140
                                //hoursPassed=2
                                //minsPasses=20
                                int totalMins=timeslotDuration;
                                int hoursPassed;
                                int minsPassed;
                                int cellNum=0;
                                while(totalMins<=1440)
                                {
                                    hoursPassed=(int)(totalMins*1.0/60.0);
                                    minsPassed=totalMins-(60*hoursPassed);
                                    
                                    hour2=startHour+hoursPassed;
                                    min2=startMin+minsPassed;
                                    
                                    String h1=hour1+"";
                                    String h2=hour2+"";
                                    String m1=min1+"";
                                    String m2=min2+"";
                                    if(hour1>=24)
                                    {
                                        h1=hour1-24+"";
                                    }
                                    if(hour2>=24)
                                    {
                                        h2=hour2-24+"";
                                    }
                                    if(min1<10)
                                    {
                                        m1="0"+min1;
                                    }
                                    if(min2<10)
                                    {
                                        m2="0"+min2;
                                    }
                                    
                                    String timeslotStr=h1+":"+m1+" - "+h2+":"+m2;
                                    String curRowData="['"+timeslotStr+"'";
                                    for(ExamroomsBean curExRoom : examRoomsResults)
                                    {
                                        String isReserved=curExRoom.isReserved(curDate, hour1, min1, hour2, min2);
                                        if(isReserved.equalsIgnoreCase("FREE"))
                                        {
                                            curRowData+=",'<div id=\"DV"+cellNum+"\" title=\""+curDate+" "+timeslotStr+"\" onclick=enlightDV(this,\""+curExRoom.id+"\");>&nbsp;</div>'";
                                            cellNum++;
                                        }
                                        else 
                                        {
                                            //curRowData+=",'<div style=\"background-color:#b0c4de;\">"+curExRoom.modBean.name+"</div>'";
                                            curRowData+=",'<div style=\"background-color:#b0c4de;\">&nbsp;</div>'";
                                        }
                                    }

                                    if(totalMins<=1440)
                                    {
                                        curRowData+="],";
                                    }
                                    else
                                    {
                                        curRowData+="]";
                                    }
                                    out.println(curRowData);
                                    
                                    hour1=hour2;
                                    min1=min2;
                                    totalMins+=timeslotDuration;
                                }
                            %>
                                    ],
                                    columns: [
                                        { headerText: "Timeslot" },
                                        <%
                                        for(int i=0; i<examRoomsResults.size(); i++)
                                        {
                                            ExamroomsBean curExRoom=examRoomsResults.get(i);
                                            if(i==examRoomsResults.size()-1)
                                                out.println("{ headerText: '"+curExRoom.name+"'}");
                                            else
                                                out.println("{ headerText: '"+curExRoom.name+"'},");
                                        }
                                        %>
                                    ]
                                    }); 
                                });
                            </script>
                            <table id='timeslotsTable'>
                            </table>
                            
                            <br/><br/>
                            
                            <input type="hidden" id="examRoomIDHidden" name="examRoomIDHidden"/>
                            
                            <table border="0">
                                <tr>
                                    <td>
                                        Date and time:
                                    </td>
                                    <td>
                                        <input readonly type="text" id="selectedAppDatetime" name="selectedAppDatetime"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        External:
                                    </td>
                                    <td>
                                        <input type="radio" name="externalPat" value="1">Yes</input> &nbsp; <input type="radio" name="externalPat" id="externalPat" value="0" checked>No</input>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Comments:
                                    </td>
                                    <td>
                                        <textarea name="appComments" rows="2" cols="70"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="center">
                                        <input type="button" value="Save" onClick="javascript:checkNewAppointForm();"/>
                                    </td>
                                </tr>
                            </table>
                        
                        </form>
                        </div>
                    </div>
                <%
                }
                    else
                    {
                        out.println("No available timeslots found!");
                    }
               
                }             
            }
            else if(request.getParameter("action")!=null && request.getParameter("action").length()>0 && request.getParameter("action").equalsIgnoreCase("confirmApp"))
            {
                //new scheduled appointment confirmation view
                appointmentsBean newAppBean=(appointmentsBean)session.getAttribute("newAppBean");
            %>
                <div class="post" id="searchPatientFormDiv">
                    <h2 class="title">
                    <a href="#">New appointment scheduled successfully!</a></h2>
                    <div class="entry">
                        <table border="0">
                            <tr>
                                <td>Patient:</td>
                                <td>
                                    <%= newAppBean.PB.name+" "+newAppBean.PB.surname %>
                                </td>
                            </tr>
                            <tr>
                                <td>SSN:</td>
                                <td>
                                    <%= newAppBean.PB.getSsn() %>
                                </td>
                            </tr>
                            <tr>
                                <td>Exam. Type:</td>
                                <td>
                                    <%= newAppBean.ETB.getDescriptionEl() %>
                                </td>
                            </tr>
                            <tr>
                                <td>Date & Time:</td>
                                <td>
                                    <%= newAppBean.startdatetimeStr %>
                                </td>
                            </tr>
                            <tr>
                                <td>Duration:</td>
                                <td>
                                    <%= newAppBean.duration %> minutes
                                </td>
                            </tr>
                            <tr>
                                <td>External:</td>
                                <td>
                                    <%= (newAppBean.isexternal.equals("0")) ? "No" : "Yes" %>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <input type="button" value="Print" onClick="javascript:print();"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            <%
            }
            %>
                    
            </div>
		<!-- end #content -->
            <div id="sidebar">
                <ul>
                    <li>
                        <h2><%= langBacking.getLiteral("actions") %></h2>
                        <ul>
                            <li><a href="patients.jsp"><%= langBacking.getLiteral("search_patient") %></a></li>
                            <li><a href="addNewPatient.jsp"><%= langBacking.getLiteral("add_patient") %></a></li>
                            <li><a href="emergency.jsp?patient=unknown">Έκτακτο Περιστατικό <br/>Αγνώστου Ασθενούς</a></li>
                        </ul>
                    </li>
                </ul>

                <%
                ArrayList<ExamroomsBean> examRoomsResults=(ArrayList<ExamroomsBean>)session.getAttribute("examRoomsResults");
                if(examRoomsResults!=null && examRoomsResults.size()>0)
                {
                    appointmentsBean newAppBean=(appointmentsBean)session.getAttribute("newAppBean");
                %>
                    <br/><br/><br/><br/><br/><br/><br/>
                    Date:
                    <br/>
                    <input type="text" id="previewDatePicker" name="previewDatePicker" />
                    <br/>
                    <input type="button" value="Refresh" onClick="javascript:window.location='patients.jsp?action=newAppoint&patid=<%=newAppBean.PB.id%>&onDate='+document.getElementById('previewDatePicker').value;"/>
                <%
                }
                %>

            </div>
		<!-- end #sidebar -->
            <div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    </body>
</html>