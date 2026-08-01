<%@page import="beans.TeleAppointmentFileBean"%>
<%@page import="beans.TeleAppointmentBean"%>
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


<script language="javascript">
function completeTeleAppointment(teleAppHash)
{
    var answer = confirm("<%= langBacking.getLiteral("tele_appointment_complete_confirm") %>");
    if(answer==true)
    {
        window.location="actions/complete_teleappointment_action.jsp?teleAppHash="+teleAppHash;
    }
}
function cancelTeleAppointment(teleAppHash)
{
    var answer = confirm("<%= langBacking.getLiteral("cancel_appointment_confirm") %>");
    if(answer==true)
    {
        window.location="actions/cancel_teleappointment_action.jsp?teleAppHash="+teleAppHash;
    }
}

function popupShowConsultant(consHash)
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("popup_show_consultant_title") %>",
        width: 700, 
        height: 500, 
        modal: false,
        contentUrl: 'popupShowConsultant.jsp?consHash='+consHash, 
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

function popupAddDiagnosis(teleAppHash)
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("insert_diagnosis") %>",
        width: 600, 
        height: 600, 
        modal: true,
        contentUrl: 'popupAddDiagnosis.jsp?teleAppHash='+teleAppHash, 
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
function popupAddIcdDiagnosis(teleAppHash)
{
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("insert_icd_code") %>",
        width: 700, 
        height: 700, 
        modal: true,
        contentUrl: 'popupAddIcdDiagnosis.jsp?teleAppHash='+teleAppHash, 
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

function copyToClipboard(text) {
  window.prompt("Copy to clipboard: Ctrl+C, Enter", text);
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
        
        <div id="popup"></div>

        <div id="wrapper">
            <jsp:include page="header.jsp"/>
            <hr><!-- end #logo -->
            <% request.setAttribute("target", "teleAppointments"); %>
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
                                    <a href="#"><%= langBacking.getLiteral("tele-appointments") %></a>
                                </h2>
                                <div class="entry">
                                    <form name="searchAppointmentsForm" action="actions/search_appointments_action.jsp" method="post">
                                        <table border="0">
                                            <tr>
<!--                                                <td>
                                                    <%= langBacking.getLiteral("examination_room") %>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                </td>-->
                                                <td>
                                                    <%= langBacking.getLiteral("date") %>
                                                </td>
                                            </tr>
                                            <tr>        
<!--                                                <td>
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
                                                </td>-->
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
                            ArrayList<TeleAppointmentBean> APPList=siteDoctorBacking.teleAppointmentsSearchResults;
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
                                        for(int i=0; i<APPList.size(); i++)
                                        {
                                            TeleAppointmentBean APPB=APPList.get(i);
                                            APPB.setAdviceIcdList(siteDoctorBacking.findAdviceIcdListByAppId(APPB.getId()));
                                            APPB.setDiagnosisIcdList(siteDoctorBacking.findDiagnosisIcdListByAppId(APPB.getId()));

                                            String hrefs="";
                                            if(APPB.getStatus().equalsIgnoreCase("completed")==false && APPB.getStatus().equalsIgnoreCase("Cancelled")==false)
                                            {
                                                String confCaller = siteDoctorBacking.AB.getSipConference();
                                                String medicalCaller = siteDoctorBacking.AB.getSipMedical();
                                                
                                                String confCallee = "";
                                                String medicalCallee = "";
                                                if(APPB.getConsultantBean1()!=null)
                                                {
                                                    confCallee = APPB.getConsultantBean1().getSipConference();
                                                    medicalCallee = APPB.getConsultantBean1().getSipMedical();
                                                }
                                                else if(APPB.getConsultantBean2()!=null)
                                                {
                                                    confCallee = APPB.getConsultantBean2().getSipConference();
                                                    medicalCallee = APPB.getConsultantBean2().getSipMedical();
                                                }
                                                
                                                hrefs+="<div align=\"center\">";
                                                hrefs+="<a target=\"_blank\" href=\"videoCalls.jsp?confCaller="+confCaller+"&medicalCaller="+medicalCaller+"&confCallee="+confCallee+"&medicalCallee="+medicalCallee+"\"><img src=\"../images/videoConf.png\" width=\"32px\"/></a>";
                                                hrefs+="&nbsp;&nbsp;";
                                                hrefs+="<a href=\"javascript:completeTeleAppointment("+APPB.hashCode()+");\"><img src=\"../images/completed.png\" width=\"32px\" title=\""+langBacking.getLiteral("complete_appointment")+"\"/></a>";
                                                hrefs+="&nbsp;&nbsp;";
                                                hrefs+="<a href=\"javascript:cancelTeleAppointment("+APPB.hashCode()+");\"><img src=\"../images/cancelAppointment.png\" width=\"32px\" title=\""+langBacking.getLiteral("cancel_appointment")+"\"/></a></div>";
                                            }
                                            else
                                            {
                                                hrefs="";
                                            }

                                            String appointmentDetails=langBacking.getLiteral("sitedoctor")+": "+APPB.getSiteDoctorBean().name+" "+APPB.getSiteDoctorBean().surname+" ("+APPB.getSiteDoctorBean().specialtyBean.getNameByLang(langBacking.lang)+")";
                                            appointmentDetails+="<br/>";
                                            appointmentDetails+=langBacking.getLiteral("stia")+": "+APPB.getSiteDoctorBean().SB.name;
                                            appointmentDetails+="<br/><br/>";
                                            appointmentDetails+=langBacking.getLiteral("consultant")+": <a href=\"javascript:popupShowConsultant("+APPB.getConsultantBean1().hashCode()+");\">"+APPB.getConsultantBean1().getName()+" "+APPB.getConsultantBean1().getSurname()+"</a> ("+APPB.getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                                            appointmentDetails+="<br/>";
                                            appointmentDetails+=langBacking.getLiteral("stis")+": "+APPB.getStisBean1().getTitle()+" ("+APPB.getStisBean1().getNosokomeio()+")";
                                            appointmentDetails+="<br/>";
                                            
                                            if(APPB.getStisBean2()!=null && APPB.getConsultantBean2()!=null)
                                            {
                                                appointmentDetails+="<br/>";
                                                appointmentDetails+=langBacking.getLiteral("consultant")+": <a href=\"javascript:popupShowConsultant("+APPB.getConsultantBean2().hashCode()+");\">"+APPB.getConsultantBean2().getName()+" "+APPB.getConsultantBean2().getSurname()+"</a> ("+APPB.getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                                                appointmentDetails+="<br/>";
                                                appointmentDetails+=langBacking.getLiteral("stis")+": "+APPB.getStisBean2().getTitle()+" ("+APPB.getStisBean2().getNosokomeio()+")";
                                                appointmentDetails+="<br/>";
                                            }
                                            
                                            appointmentDetails+="<br/>";
                                            
                                            if(APPB.getStatus().equalsIgnoreCase("Completed")==true)
                                            {
                                                appointmentDetails+=langBacking.getLiteral("status")+": <font color=\"green\"><b>"+langBacking.getLiteral(APPB.getStatus())+"</b></font>";
                                            }
                                            else if(APPB.getStatus().equalsIgnoreCase("Cancelled")==true)
                                            {
                                                appointmentDetails+=langBacking.getLiteral("status")+": <font color=\"red\"><b>"+langBacking.getLiteral(APPB.getStatus())+"</b></font>";
                                            }
                                            else
                                            {
                                                appointmentDetails+=langBacking.getLiteral("status")+": "+langBacking.getLiteral(APPB.getStatus());
                                            }
                                            appointmentDetails+="<br/>";
                                            appointmentDetails+=langBacking.getLiteral("comments")+": "+APPB.getComments();
                                            
                                            String dateTime = APPB.getStartDateStr(langBacking.getDateFormat())+"<br/>";
                                            dateTime+=APPB.getStartTimeStr()+" - "+APPB.getEndTimeStr();
                                            
                                            ArrayList<TeleAppointmentFileBean> allAppFiles = siteDoctorBacking.getTeleAppointmentFilesByAppointmentId(APPB.getId());
                                            String appFiles="";
                                            for(TeleAppointmentFileBean curFile : allAppFiles)
                                            {
                                                String iconName = GlobalHelper.getIconFileName(curFile.getFileName());
                                                appFiles+="<a href=\"actions/download_teleAppointment_file_action.jsp?fileId="+curFile.getId()+"\"><img src=\"../images/"+iconName+"\" width=\"32px\"/></a> "+curFile.getFileNameSubStr(30)+"<br/><br/>";
                                            }
                                            
                                            String adviceIcdText="";
                                            for(Icd10Bean curIcd : APPB.getAdviceIcdList())
                                            {
                                                adviceIcdText+=curIcd.code+" - "+curIcd.nameEl+"<br/>";
                                            }
                                            if(adviceIcdText.length()>0)
                                            {
                                                adviceIcdText="<div align=\"center\"><img src=\"../images/icd10.jpg\" width=\"40px\"/></div>"+adviceIcdText;
                                            }
                                            
                                            String diagnosisButton="<div align=\"center\"><a href=\"javascript:popupAddDiagnosis("+APPB.hashCode()+");\"><img src=\"../images/add-advice.png\" width=\"32px\" /></a></div>";
                                            String diagnosisIcdButton="<div align=\"center\"><a href=\"javascript:popupAddIcdDiagnosis("+APPB.hashCode()+");\"><img src=\"../images/add-icd-advice.png\" width=\"32px\" /></a></div>";
                                            if(APPB.getStatus().equalsIgnoreCase("completed")==true || APPB.getStatus().equalsIgnoreCase("cancelled")==true)
                                            {
                                                diagnosisButton="";
                                                diagnosisIcdButton="";
                                            }
                                            String diagnosisIcdText="";
                                            for(Icd10Bean curIcd : APPB.getDiagnosisIcdList())
                                            {
                                                diagnosisIcdText+=curIcd.code+" - "+curIcd.nameEl+"<br/>";
                                            }
                                            if(diagnosisIcdText.length()>0)
                                            {
                                                diagnosisIcdText="<div align=\"center\"><img src=\"../images/icd10.jpg\" width=\"32px\"/></div>"+diagnosisIcdText;
                                            }

                                            if(i<APPList.size()-1)
                                            {
                                                out.println("['"+dateTime+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+APPB.getPatientBean().id+"\">"+APPB.getPatientBean().name+"<br/>"+APPB.getPatientBean().surname+"</a><br/>("+APPB.getPatientBean().id+")<br/><br/>"+APPB.getReadableId()+"','"+appointmentDetails+"', '"+appFiles+"', '"+APPB.getTeleAdvice()+"<br/><br/>"+adviceIcdText+"', '"+diagnosisButton+" "+APPB.getDiagnosis()+" <br/><br/>"+diagnosisIcdButton+" "+diagnosisIcdText+"', '"+hrefs+"'],");
                                            }
                                            else
                                            {
                                                out.println("['"+dateTime+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+APPB.getPatientBean().id+"\">"+APPB.getPatientBean().name+"<br/>"+APPB.getPatientBean().surname+"</a><br/>("+APPB.getPatientBean().id+")<br/><br/>"+APPB.getReadableId()+"','"+appointmentDetails+"', '"+appFiles+"', '"+APPB.getTeleAdvice()+"<br/><br/>"+adviceIcdText+"', '"+diagnosisButton+" "+APPB.getDiagnosis()+" <br/><br/>"+diagnosisIcdButton+" "+diagnosisIcdText+"', '"+hrefs+"']");
                                            }
                                        }
                                        %>
                                        ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("date_time") %> - <%= langBacking.getLiteral("patient") %> - <%= langBacking.getLiteral("code") %>" , width: "160px" }, 
                                            { headerText: "<%= langBacking.getLiteral("appointment_details") %>" , width: "220px" }, 
                                            { headerText: "<%= langBacking.getLiteral("files") %>" , width: "230px"}, 
                                            { headerText: "<%= langBacking.getLiteral("tele_advice") %>" }, 
                                            { headerText: "<%= langBacking.getLiteral("diagnosis") %>" }, 
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width: "130px"}
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