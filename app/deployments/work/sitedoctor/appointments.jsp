<%@page import="beans.Icd10Bean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="org.jboss.weld.bootstrap.events.AbstractProcessProducerBean"%>
<%@page import="tools.GlobalHelper"%>
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
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ModalityBean "%>

<!-- Initializations -->
<%
//retrieve DBH from session
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
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
        <script src="../wijmotools/external/jquery.mousewheel.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
<!--        <link href="../wijmotools/wijmo/jquery.wijmo.wijcombobox.css" rel="stylesheet" type="text/css" />-->
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
        <script src="../wijmotools/wijmo/jquery.wijmo.wijcombobox.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijinputdate.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijtextselection.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijinputcore.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijevcal.js" type="text/javascript"></script>
        
        <script src="../wijmotools/external/cultures/globalize.culture.el-GR.js" type="text/javascript"></script>
    </head>

<!-- Javascript functions  -->
<script language="javascript">

function loadListByCartId()
{
    var cartId=document.getElementById("cartFilter").value;
    alert("Load cart List with id"+cartId);
    window.location = "appointments.jsp?cartId="+cartId;
}

function loadListByPatId()
{
    var patId=document.getElementById("patFilter").value;
    alert("Load patient List with id"+patId);
    window.location = "appointments.jsp?patId="+patId;
}


function showAppDetailsForm(appId){
    //alert("VB"+appId);
   // document.getElementById("showAppDetailsDiv").style.display = "inline";
   // document.getElementById("docPatCartFilters").style.display = "none";
   window.location="appointments.jsp?view=appDetails&id="+appId;
}

    
</script>

<!-- javascript pou prepei na paiksei molis fortwthei h selida -->
<script id="scriptInit" type="text/javascript">
$(document).ready(function () {

$("#appStartDatePicker").wijinputdate({
    <%
    if(langBacking.lang.equalsIgnoreCase("greek"))
    {
        out.println("culture: 'el-GR',");
    }
    %>
<%
if(siteDoctorBacking.appointmentSearchDateStr!=null && siteDoctorBacking.appointmentSearchDateStr.length()>0)
{
    out.println("date: '"+siteDoctorBacking.appointmentSearchDateStr+"',");
}
%>
//date: '12/8/2012',
dateFormat: '<%= langBacking.getDateFormat() %>',
showTrigger: true

});




});


</script>
    
    <body>

        <div id="wrapper">
            <jsp:include page="header.jsp"/>
            <hr><!-- end #logo -->
            <% request.setAttribute("target", "appointments"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
            <div id="page">
                <div id="page-bgtop">
                        <div id="content" style="width:100%">
                            <%
                            if(siteDoctorBacking!=null && siteDoctorBacking.errorMessage.length()>0)
                            {
                                out.println("<div class='post'>");
                                out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                                out.println("<img src='../images/error.png' width='64px'/>");
                                out.println("</td><td valign='middle'>");
                                out.println(siteDoctorBacking.errorMessage);
                                out.println("</td></tr></table>");
                                out.println("</div>");
                            }
                            else if(siteDoctorBacking!=null && siteDoctorBacking.okMessage.length()>0)
                            {
                                out.println("<div class='post'>");
                                out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                                out.println("<img src='../images/check.png' width='64px'/>");
                                out.println("</td><td valign='middle'>");
                                out.println(siteDoctorBacking.okMessage);
                                out.println("</td></tr></table>");
                                out.println("</div>");
                            }
                            else if(siteDoctorBacking!=null && siteDoctorBacking.infoMessage.length()>0)
                            {
                                out.println("<div class='post'>");
                                out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                                out.println("<img src='../images/info.png' width='64px'/>");
                                out.println("</td><td valign='middle'>");
                                out.println(siteDoctorBacking.infoMessage);
                                out.println("</td></tr></table>");
                                out.println("</div>");
                            }
                            siteDoctorBacking.resetMessages();
                            %>

                            <!-- div that contains all appointments and filters -->
                            <div id="docPatCartFilters" class="post" style="width:100%">
                             <%     
                                    ArrayList<ExamroomsBean> exRoomsList=DBH.getExamRoomsBySiteID(AB.SB.id);
                              %>      

                                <h2 class="title">
                                    <a href="#"><%= langBacking.getLiteral("appointments") %></a>
                                </h2>
                                <div class="entry">
                                    <form name="searchAppointmentsForm" action="actions/search_local_appointments_action.jsp" method="post">
                                        <table border="0">
                                            <tr>
                                                <td>
                                                    <%= langBacking.getLiteral("examination_room") %>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <%= langBacking.getLiteral("date") %>
                                                </td>
                                            </tr>
                                            <tr>        
                                                <td>
                                                    <select id="roomFilter" style="width: 200px;" name="roomFilter">
                                                    <%
                                                    if(siteDoctorBacking.appointmentSearchExamRoomId==null)
                                                    {
                                                        out.println("<option selected value='All rooms'>"+langBacking.getLiteral("all_rooms")+"</option>");
                                                    }
                                                    else
                                                    {
                                                        out.println("<option value='All rooms'>"+langBacking.getLiteral("all_rooms")+"</option>");
                                                    }

                                                    for(ExamroomsBean exRoom : exRoomsList)
                                                    {
                                                        if(exRoom.id.equalsIgnoreCase(siteDoctorBacking.appointmentSearchExamRoomId))
                                                        {
                                                            out.println("<option selected value='"+exRoom.id+"'>"+exRoom.name+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+exRoom.id+"'>"+exRoom.name+"</option>");
                                                        }
                                                    }
                                                    %>
                                                    </select>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>
                                                    <td valign="top">
                                                    <input type="text" id="appStartDatePicker" name="appStartDatePicker" />
                                                </td> 
                                            </tr>
                                            <tr>
                                                <td>
                                                  <input type="submit" value="<%= langBacking.getLiteral("search") %>"/>
                                               </td>            
                                            </tr>        
                                        </table>
                                    </form>
                                </div>
                            </div>

                            <%
                            ArrayList<appointmentsBean> APPList=siteDoctorBacking.appointmentsSearchResults;
                            if(APPList!=null && APPList.size()>0)
                            {
                            %>
                            <div class="post" style="width: 100%;" >
        <!--                        <h2 class="title"><a href="#">Appointments Table</a></h2>-->
                                <div class="entry">
                                    <script id="scriptInit" type="text/javascript">
                                    $(document).ready(function () {
                                        $("#patientAppointmentsTable").wijgrid({
                                            allowSorting: true,
                                            allowPaging: true,
                                            pageSize: 10,
                                            allowColSizing: true,
                                            ensureColumnsPxWidth:true,
                                            data: [
                                    <%
                                        String sendStudyURL="";
                                        for(int i=0; i<APPList.size(); i++)
                                        {
                                            appointmentsBean APPB=APPList.get(i);

                                            String hrefs="<div align=\"center\">";
                                            hrefs+="<a href=\"../HL7/sendOrder.jsp?docId="+siteDoctorBacking.AB.docBean.id+"&apid="+APPB.id+"\"><img title=\"Αποστολή εξέτασης στο PACS\" alt=\"Details\" src=\"../images/send.png\" style=\"width:35px;border:0px solid red;\"></a>";
                                            if(APPB.studyObj!=null && APPB.studyObj.studyID!=null && APPB.studyObj.studyID.length()>0)
                                            {
                                                hrefs+="&nbsp;&nbsp;<a target=\"_blank\" href=\"http://"+siteDoctorBacking.jivexPacsBean.ip+":"+siteDoctorBacking.jivexPacsBean.port+"/"+siteDoctorBacking.jivexPacsBean.context+"?login="+siteDoctorBacking.AB.username+"&password="+siteDoctorBacking.AB.password+"&mode=load&studyInstanceUID="+APPB.studyObj.studyID+"&URLescaped=true\"><img title=\"Open study in JiveX\" src=\"../images/xray.png\" style=\"width:40px;border:0px solid red;\"/></a>";
                                            }

                                            if(APPB.ETB.getDescriptionEl().indexOf("ΣΥΝΤΑΓΟΓ")>0 || APPB.ETB.getDescriptionEn().indexOf("PERSCRIPT")>0)
                                            {
                                                hrefs="";
                                            }

                                            if(APPB.ExamRoomBean.modBean.pacsConnection.equalsIgnoreCase("yes")==false)
                                            {
                                                hrefs="";
                                            }

                                            if(APPB.status.equalsIgnoreCase("completed")==false)
                                            {
                                                hrefs+="&nbsp;&nbsp;<a href=\"actions/complete_appointment_action.jsp?appId="+APPB.id+"\"><img src=\"../images/completed.png\" width=\"30px\" title=\"Ολοκλήρωση Ραντεβού\"/></a>";
                                            }
                                            else
                                            {
                                                hrefs="";
                                            }
                                            hrefs+="</div>";

                                            String icd10Details="";
//                                            if(APPB.icdList!=null)
//                                            {
//                                                for(Icd10Bean curIcd : APPB.icdList)
//                                                {
//                                                    icd10Details+="<b>"+curIcd.code+"</b> - "+curIcd.nameEl+"<br/>";
//                                                }
//
//                                            }

                                            String appointmentDetails="";
                                            if(APPB.ETB.getModalityType()!=null && APPB.ETB.getModalityType().length()>0)
                                            {
                                                appointmentDetails+=langBacking.getLiteral("examination_type")+": ("+APPB.ETB.getModalityType()+") "+APPB.ETB.getDescriptionEl()+"<br/>";
                                            }
                                            else
                                            {
                                                appointmentDetails+=langBacking.getLiteral("examination_type")+": "+APPB.ETB.getDescriptionEl()+"<br/>";
                                            }
                                            
                                            if(APPB.ExamRoomBean.deleted.equalsIgnoreCase("true"))
                                            {
                                                appointmentDetails+=langBacking.getLiteral("examination_room")+": <del>"+APPB.ExamRoomBean.name+"</del><br/>";
                                            }
                                            else
                                            {
                                                appointmentDetails+=langBacking.getLiteral("examination_room")+": "+APPB.ExamRoomBean.name+"<br/>";
                                            }
                                            
                                            if(APPB.MB!=null && APPB.MB.id!=null && APPB.MB.id.length()>0 && APPB.MB.name.length()>0)
                                            {
                                                if(APPB.MB.deleted.equalsIgnoreCase("true"))
                                                {
                                                    appointmentDetails+=langBacking.getLiteral("modality")+": <del>"+APPB.MB.name+"/"+APPB.MB.type+"</del><br/>";
                                                }
                                                else
                                                {
                                                    appointmentDetails+=langBacking.getLiteral("modality")+": "+APPB.MB.name+"/"+APPB.MB.type+"<br/>";
                                                }
                                            }

                                            appointmentDetails+=langBacking.getLiteral("duration")+": "+APPB.duration+" minutes<br/>";
                                            appointmentDetails+=langBacking.getLiteral("comment")+": "+APPB.comments+"<br/>";
                                            appointmentDetails+=langBacking.getLiteral("status")+": "+langBacking.getLiteral(APPB.status)+"<br/>";
                                            appointmentDetails+=langBacking.getLiteral("doctor")+": "+APPB.statusDocBean.name+" "+APPB.statusDocBean.surname+"<br/>";

                                            String historyDetails="";
                                            historyDetails+=langBacking.getLiteral("chief_complaint")+": "+APPB.complaint+"<br/>";
                                            historyDetails+=langBacking.getLiteral("present_illness")+": "+APPB.presentIllness+"<br/>";
                                            historyDetails+=langBacking.getLiteral("medication")+": "+APPB.medication+"<br/>";
                                            historyDetails+=langBacking.getLiteral("alergies")+": "+APPB.alergies+"<br/>";
                                            historyDetails+=langBacking.getLiteral("past_diseases")+": "+APPB.pastHistory+"<br/>"; 
                                            historyDetails+=langBacking.getLiteral("family_history")+": "+APPB.familyHistory+"<br/>";

                                            if(i<APPList.size()-1)
                                            {
                                                out.println("['"+APPB.getAppointmentDateTimeStr(langBacking.getDateFormat())+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+APPB.PB.id+"\">"+APPB.PB.name+"<br/>"+APPB.PB.surname+"','"+appointmentDetails+"', '"+historyDetails+"', '"+hrefs+"'],");
                                            }
                                            else
                                            {
                                                out.println("['"+APPB.getAppointmentDateTimeStr(langBacking.getDateFormat())+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+APPB.PB.id+"\">"+APPB.PB.name+"<br/>"+APPB.PB.surname+"','"+appointmentDetails+"', '"+historyDetails+"', '"+hrefs+"']");
                                            }
                                        }
                                        %>
                                        ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("date_time") %> - <%= langBacking.getLiteral("patient") %>" , width: "180px" }, 
                                            { headerText: "<%= langBacking.getLiteral("appointment_details") %>" , width: "340px" }, 
                                            { headerText: "<%= langBacking.getLiteral("patient_history") %>" , width: "340px"}, 
                                            //{ headerText: "<%= langBacking.getLiteral("ICD-10") %>" , width: "230px"}, 
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width: "140px"}
                                        ]
                                        });
                                    });
                                    </script>
                                    <table id='patientAppointmentsTable' style="width:1000px"></table>
                                </div>
                            </div>
                        <%
                        }
                        %>
                        </div>
                        <!-- end #content -->
                        
                        <!-- end #sidebar -->
                        <div style="clear: both;"> </div>
                </div>
            </div>
	<!-- end #page -->
            <jsp:include page="footer.jsp"/>
        </div>
    
    </body>
    
    <script language="javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $("#select1").wijdropdown();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button'],:input[type='submit']").button(); 
        $("#roomFilter").wijdropdown();
        //$(":input[type='radio']").wijradio();
        $("#filter").wijdropdown();
    </script>
    
</html>