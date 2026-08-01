
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="beans.DoctorBean"%>
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
        function popupPrintMenu(appHash)
        {
            $("#popup").wijdialog({ 
                title: "Εκτυπωτικά",
                width: 500, 
                height: 200, 
                modal: true,
                contentUrl: 'popupPrintMenu.jsp?appHash='+appHash,
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
        
        function cancelAppointment(appHash)
        {
            if(confirm("Επιθυμειτε την ακύρωση του επιλεγμένου ραντεβού;"))
            {
                window.location.href="actions/cancel_appointment_action.jsp?appHash="+appHash;
            }
        }
    </script>
    
    <body >
        
        <%
        String patId=request.getParameter("patId");
        if(patId!=null && patId.trim().length()>0)
        {
            siteUserBacking.selectedPatientToViewHistory = siteUserBacking.getPatientById(patId.trim());
        }
        %>
        
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
		<div id="content" style="width:100%">
                    
                    <%
                    if(siteUserBacking!=null && siteUserBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteUserBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteUserBacking!=null && siteUserBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteUserBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteUserBacking!=null && siteUserBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteUserBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteUserBacking.resetMessages();
                    %>
                    
                    <%
                    if(siteUserBacking.selectedPatientToViewHistory!=null)
                    {
                    %>
                    <div class="post" style="width:100%">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("patient_demographics") %></a></h2>
                        <div class="entry">
                            <table border="0">
                                <tr>
                                    <td width="135px">
                                        <img src="../images/patient-icon.png" width="120px"/>
                                    </td>
                                    <td valign="top">
                                        <table border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("patient_information") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                                <td>
                                                     <%= siteUserBacking.selectedPatientToViewHistory.name %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("surname") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.surname %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("fathers_name") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.fathersName %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("date_of_birth") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.getBirthDateStr(langBacking.getDateFormat()) %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("sex") %>:</td>
                                                <td>
                                                    <%= langBacking.getLiteral(siteUserBacking.selectedPatientToViewHistory.sex) %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td valign="top">
                                        <table border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("address") %>:</td>
                                                <td>
                                                    
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.homephone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.workphone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.mobilephone %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td valign="top">
                                        <table>
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("insurance") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("social_security_number") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.getSsn() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                                <td>
                                                    <%= siteUserBacking.selectedPatientToViewHistory.insurancename %>
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
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="7">
                                        <b><i><%= langBacking.getLiteral("other_identifier") %></i></b>: <%= siteUserBacking.selectedPatientToViewHistory.otherIdentifier %>
                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>

                    <div class="post" style="width:100%">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("view_patient_appointments") %></a></h2>
                        <div class="entry">
                            <%
                            ArrayList<appointmentsBean> patientAppointmentsList = siteUserBacking.getAllAppointmentsByPatientId(siteUserBacking.selectedPatientToViewHistory.id);
                            if(patientAppointmentsList!=null && patientAppointmentsList.size()>0)
                            {
                            %>
                                <script id="scriptInit" type="text/javascript">
                                    $(document).ready(function () {
                                        $("#patientAppointmentsTable").wijgrid({
                                            allowSorting: true,
                                            allowPaging: true,
                                            pageSize: 5,
                                            ensureColumnsPxWidth:true,
                                            allowColSizing: true,
                                            data: [
                                    <%
                                        String sendStudyURL="";
                                        for(int i=0; i<patientAppointmentsList.size(); i++)
                                        {
                                            appointmentsBean APPB=patientAppointmentsList.get(i);
                                            
                                            String hrefs="";
                                            if(APPB.status.equalsIgnoreCase("completed")==false)
                                            {
                                                hrefs+="<div align=\"center\"><a href=\"javascript:cancelAppointment("+APPB.hashCode()+");\";\"><img src=\"../images/cancelAppointment.png\" width=\"35px\" title=\""+langBacking.getLiteral("cancel_appointment")+"\"/></a><div>";
                                            }
                                            
                                            String appointmentDetails="";
                                            appointmentDetails+=langBacking.getLiteral("examination_type")+": "+APPB.ETB.getDescriptionEl()+"<br/>";
                                            
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
                                            
//                                            String historyDetails="";
//                                            historyDetails+=langBacking.getLiteral("chief_complaint")+": "+APPB.complaint+"<br/>";
//                                            historyDetails+=langBacking.getLiteral("present_illness")+": "+APPB.presentIllness+"<br/>";
//                                            historyDetails+=langBacking.getLiteral("medication")+": "+APPB.medication+"<br/>";
//                                            historyDetails+=langBacking.getLiteral("alergies")+": "+APPB.alergies+"<br/>";
//                                            historyDetails+=langBacking.getLiteral("past_health_history")+": "+APPB.pastHistory+"<br/>";
//                                            historyDetails+=langBacking.getLiteral("family_history")+": "+APPB.familyHistory+"<br/>";
                                            
                                            String siteName = "";
                                            if(APPB.SB!=null && APPB.SB.getDeleted().equalsIgnoreCase("false"))
                                            {
                                                siteName = APPB.SB.name;
                                            }
                                            else if(APPB.SB!=null && APPB.SB.getDeleted().equalsIgnoreCase("true"))
                                            {
                                                siteName = "<i><del>"+APPB.SB.name+"</del></i>";
                                            }
                                            
//                                            hrefs+="&nbsp;&nbsp;<a href=\"javascript:popupPrintMenu("+APPB.hashCode()+");\"><img src=\"../images/printer.png\" width=\"35px\" title=\""+langBacking.getLiteral("print_docs")+"\"/></a>";
                                            
                                            if(i<patientAppointmentsList.size()-1)
                                            {
                                                out.println("['"+APPB.getAppointmentDateTimeStr(langBacking.getDateFormat())+"<br/><br/>"+langBacking.getLiteral("site")+": "+siteName+"','"+appointmentDetails+"', '"+hrefs+"'],");
                                            }
                                            else
                                            {
                                                out.println("['"+APPB.getAppointmentDateTimeStr(langBacking.getDateFormat())+"<br/><br/>"+langBacking.getLiteral("site")+": "+siteName+"','"+appointmentDetails+"', '"+hrefs+"']");
                                            }
                                        }
                                    %>
                                    ],
                                    columns: [
                                        { headerText: "<%= langBacking.getLiteral("date_time") %>" , width: "200px" }, 
                                        { headerText: "<%= langBacking.getLiteral("appointment_details") %>" }, 
                                        { headerText: "<%= langBacking.getLiteral("actions") %>" , width: "100px"}
                                    ]
                                    });
                                });
                                </script>
                                <table id='patientAppointmentsTable' width="1000px"></table>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_appointments_found"));
                            }
                            %>
                        </div>
                    </div>

                    <div class="post" style="width:100%">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("view_patient_emergencies") %></a></h2>
                        <div class="entry">
                            
                            <%
                            ArrayList<EmergencyCaseBean> patientEmergenciesList = siteUserBacking.getAllEmergenciesByPatientId(siteUserBacking.selectedPatientToViewHistory.id);
                            if(patientEmergenciesList!=null && patientEmergenciesList.size()>0)
                            {
                            %>
                                <script id="scriptInit" type="text/javascript">
                                    $(document).ready(function () {
                                        $("#patientEmergenciesTable").wijgrid({
                                            allowSorting: true,
                                            allowPaging: true,
                                            pageSize: 2,
                                            allowColSizing: true,
                                            data: [
                                    <%
                                        for(int i=0; i<patientEmergenciesList.size(); i++)
                                        {
                                            EmergencyCaseBean curER=patientEmergenciesList.get(i);
                                            
                                            String erDetails="";
                                            String erDetails2="";
                                            
                                            erDetails+="<b>"+langBacking.getLiteral("basic_details") +"</b><br/>";
                                            if(curER.erRegForm.erAge!=null && curER.erRegForm.erAge.length()>0){
                                                erDetails+=langBacking.getLiteral("age")+": "+curER.erRegForm.erAge+"<br/>";
                                            }
                                            erDetails+=langBacking.getLiteral("the_patient_came")+": "+curER.erRegForm.erProselefsi+"<br/>";
                                            if(curER.erRegForm.erOros!=null && curER.erRegForm.erOros.length()>0){
                                                erDetails+=langBacking.getLiteral("serum")+": "+curER.erRegForm.erOros+"<br/>";
                                            }
                                            if(curER.erRegForm.erAllo!=null && curER.erRegForm.erAllo.length()>0){
                                                erDetails+=langBacking.getLiteral("other")+": "+curER.erRegForm.erAllo+"<br/>";
                                            }
                                            
                                            erDetails+="<br/><b>"+langBacking.getLiteral("patient_history")+"</b><br/>";
                                            if(curER.erRegForm.histSymptom!=null && curER.erRegForm.histSymptom.length()>0){
                                                erDetails+=langBacking.getLiteral("symptom")+": "+curER.erRegForm.histSymptom+"<br/>";
                                            }
                                            if(curER.erRegForm.histSmoker!=null && curER.erRegForm.histSmoker.length()>0){
                                                erDetails+=langBacking.getLiteral("smoker")+": "+curER.erRegForm.histSmoker+"<br/>";
                                            }
                                            if(curER.erRegForm.histAlergic!=null && curER.erRegForm.histAlergic.length()>0){
                                                erDetails+=langBacking.getLiteral("alergies")+": "+curER.erRegForm.histAlergic+"<br/>";
                                            }
                                            if(curER.erRegForm.histLoimodi!=null && curER.erRegForm.histLoimodi.length()>0){
                                                erDetails+=langBacking.getLiteral("infectious_diseases")+": "+curER.erRegForm.histLoimodi+"<br/>";
                                            }
                                            
                                            if(curER.erRegForm.trauma!=null && curER.erRegForm.trauma.length()>0){
                                                erDetails+="<br/><b>"+langBacking.getLiteral("trauma")+"</b><br/>";
                                                erDetails+=curER.erRegForm.trauma+"<br/>";
                                            }
                                            
                                            if((curER.erRegForm.vitalTime!=null && curER.erRegForm.vitalTime.length()>0) || 
                                               (curER.erRegForm.vitalPulses!=null && curER.erRegForm.vitalPulses.length()>0) ||
                                               (curER.erRegForm.vitalAP!=null && curER.erRegForm.vitalAP.length()>0) ||
                                               (curER.erRegForm.vitalInhale!=null && curER.erRegForm.vitalInhale.length()>0) ||
                                               (curER.erRegForm.vitalSpo2!=null && curER.erRegForm.vitalSpo2.length()>0) ||
                                               (curER.erRegForm.vitalT!=null && curER.erRegForm.vitalT.length()>0)){
                                                    erDetails+="<br/><b>"+langBacking.getLiteral("vital_signs")+"</b><br/>";
                                            }
                                            if(curER.erRegForm.vitalTime!=null && curER.erRegForm.vitalTime.length()>0){
                                                erDetails+=langBacking.getLiteral("time")+": "+curER.erRegForm.vitalTime+"<br/>";
                                            }
                                            if(curER.erRegForm.vitalPulses!=null && curER.erRegForm.vitalPulses.length()>0){
                                                erDetails+=langBacking.getLiteral("pulses")+": "+curER.erRegForm.vitalPulses+"<br/>";
                                            }
                                            if(curER.erRegForm.vitalAP!=null && curER.erRegForm.vitalAP.length()>0){
                                                erDetails+="Α/Π: "+curER.erRegForm.vitalAP+"<br/>";
                                            }
                                            if(curER.erRegForm.vitalInhale!=null && curER.erRegForm.vitalInhale.length()>0){
                                                erDetails+=langBacking.getLiteral("breaths")+": "+curER.erRegForm.vitalInhale+"<br/>";
                                            }
                                            if(curER.erRegForm.vitalSpo2!=null && curER.erRegForm.vitalSpo2.length()>0){
                                                erDetails+="SPo2: "+curER.erRegForm.vitalSpo2+"<br/>";
                                            }
                                            if(curER.erRegForm.vitalT!=null && curER.erRegForm.vitalT.length()>0){
                                                erDetails+="Τ: "+curER.erRegForm.vitalT+"<br/>";
                                            }
                                            
                                            if(curER.erRegForm.derma!=null && curER.erRegForm.derma.length()>0){
                                                erDetails+="<br/><b>"+langBacking.getLiteral("skin")+"</b><br/>";
                                                erDetails+=curER.erRegForm.derma+"<br/>";
                                            }
                                            
                                            if(curER.erRegForm.erComments!=null && curER.erRegForm.erComments.length()>0){
                                                erDetails+="<br/><b>"+langBacking.getLiteral("comment")+"</b><br/>";
                                                erDetails+=curER.erRegForm.erComments+"<br/>";
                                            }
                                            
                                            if(curER.erRegForm.genikiSimeiologia!=null && curER.erRegForm.genikiSimeiologia.length()>0){
                                                erDetails2+="<br/><b>"+langBacking.getLiteral("general_semiology")+"</b><br/>";
                                                erDetails2+=curER.erRegForm.genikiSimeiologia+"<br/>";
                                            }
                                            
                                            if(curER.erRegForm.xeirourgikiSimeiologia!=null && curER.erRegForm.xeirourgikiSimeiologia.length()>0){
                                                erDetails2+="<br/><b>"+langBacking.getLiteral("surgical_semiology")+"</b><br/>";
                                                erDetails2+=curER.erRegForm.xeirourgikiSimeiologia+"<br/>";
                                            }
                                            
                                            if((curER.erRegForm.neurologikiSimeiologia!=null && curER.erRegForm.neurologikiSimeiologia.length()>0) || 
                                               (curER.erRegForm.neuroParesi!=null && curER.erRegForm.neuroParesi.length()>0) ||
                                               (curER.erRegForm.neuroHmipligia!=null && curER.erRegForm.neuroHmipligia.length()>0)){
                                                erDetails2+="<br/><b>"+langBacking.getLiteral("neurologic_semiology")+"</b><br/>";
                                            }
                                            if(curER.erRegForm.neurologikiSimeiologia!=null && curER.erRegForm.neurologikiSimeiologia.length()>0){
                                            erDetails2+=curER.erRegForm.neurologikiSimeiologia+"<br/>";
                                            }
                                            if(curER.erRegForm.neuroParesi!=null && curER.erRegForm.neuroParesi.length()>0){
                                                erDetails2+=langBacking.getLiteral("paresis")+": "+curER.erRegForm.neuroParesi+"<br/>";
                                            }
                                            if(curER.erRegForm.neuroHmipligia!=null && curER.erRegForm.neuroHmipligia.length()>0){
                                                erDetails2+=langBacking.getLiteral("hemiplegia")+": "+curER.erRegForm.neuroHmipligia+"<br/>";
                                            }
                                            
                                            if((curER.erRegForm.neuroSergApoleiaSineidisis!=null && curER.erRegForm.neuroSergApoleiaSineidisis.length()>0) || 
                                               (curER.erRegForm.neuroSergAnoiktoiOfthalmoi!=null && curER.erRegForm.neuroSergAnoiktoiOfthalmoi.length()>0) ||
                                               (curER.erRegForm.neuroSergKalyteriProforikiApantisi!=null && curER.erRegForm.neuroSergKalyteriProforikiApantisi.length()>0) ||
                                               (curER.erRegForm.neuroSergKalyteriKinitikiApantisi!=null && curER.erRegForm.neuroSergKalyteriKinitikiApantisi.length()>0) ||
                                               (curER.erRegForm.neuroSergKoresMegethosAristero!=null && curER.erRegForm.neuroSergKoresMegethosAristero.length()>0) ||
                                               (curER.erRegForm.neuroSergKoresAntidrasiAristero!=null && curER.erRegForm.neuroSergKoresAntidrasiAristero.length()>0) ||
                                               (curER.erRegForm.neuroSergSynoloVathmwn!=null && curER.erRegForm.neuroSergSynoloVathmwn.length()>0)){
                                                erDetails2+="<br/><b>"+langBacking.getLiteral("neurosurgery_semiology")+"</b><br/>";
                                            }
                                            if(curER.erRegForm.neuroSergApoleiaSineidisis!=null && curER.erRegForm.neuroSergApoleiaSineidisis.length()>0){
                                                erDetails2+=langBacking.getLiteral("loss_consciousness")+": "+curER.erRegForm.neuroSergApoleiaSineidisis+"<br/>";
                                            }
                                            if(curER.erRegForm.neuroSergAnoiktoiOfthalmoi!=null && curER.erRegForm.neuroSergAnoiktoiOfthalmoi.length()>0){
                                                erDetails2+=langBacking.getLiteral("open_eyes")+": "+curER.erRegForm.neuroSergAnoiktoiOfthalmoi+"<br/>";
                                            }
                                            if(curER.erRegForm.neuroSergKalyteriProforikiApantisi!=null && curER.erRegForm.neuroSergKalyteriProforikiApantisi.length()>0){
                                                erDetails2+=langBacking.getLiteral("best_oral_answer")+": "+curER.erRegForm.neuroSergKalyteriProforikiApantisi+"<br/>";
                                            }
                                            if(curER.erRegForm.neuroSergKalyteriKinitikiApantisi!=null && curER.erRegForm.neuroSergKalyteriKinitikiApantisi.length()>0){
                                                erDetails2+=langBacking.getLiteral("best_cinetic_response")+": "+curER.erRegForm.neuroSergKalyteriKinitikiApantisi+"<br/>";
                                            }
                                            if((curER.erRegForm.neuroSergKoresMegethosAristero!=null && curER.erRegForm.neuroSergKoresMegethosAristero.length()>0) || (curER.erRegForm.neuroSergKoresMegethosDeksi!=null && curER.erRegForm.neuroSergKoresMegethosDeksi.length()>0)){
                                                erDetails2+=langBacking.getLiteral("iris_size")+": "+curER.erRegForm.neuroSergKoresMegethosAristero+"(Α), "+curER.erRegForm.neuroSergKoresMegethosDeksi+"(Δ)<br/>";
                                            }
                                            if((curER.erRegForm.neuroSergKoresAntidrasiAristero!=null && curER.erRegForm.neuroSergKoresAntidrasiAristero.length()>0) || (curER.erRegForm.neuroSergKoresAntidrasiDeksi!=null && curER.erRegForm.neuroSergKoresAntidrasiDeksi.length()>0)){
                                                erDetails2+=langBacking.getLiteral("iris_reaction")+": "+curER.erRegForm.neuroSergKoresAntidrasiAristero+"(Α), "+curER.erRegForm.neuroSergKoresAntidrasiDeksi+"(Δ)<br/>";
                                            }
                                            if(curER.erRegForm.neuroSergSynoloVathmwn!=null && curER.erRegForm.neuroSergSynoloVathmwn.length()>0){
                                                erDetails2+=langBacking.getLiteral("total_points")+": "+curER.erRegForm.neuroSergSynoloVathmwn+"<br/>";
                                            }
                                            
                                            
                                            if((curER.erRegForm.cardioThorakikoAlgos!=null && curER.erRegForm.cardioThorakikoAlgos.length()>0) || 
                                               (curER.erRegForm.cardioXaraktiras!=null && curER.erRegForm.cardioXaraktiras.length()>0) ||
                                               (curER.erRegForm.cardioEnarxi!=null && curER.erRegForm.cardioEnarxi.length()>0) ||
                                               (curER.erRegForm.cardioDiarkeia!=null && curER.erRegForm.cardioDiarkeia.length()>0)){
                                                erDetails2+="<br/><b>"+langBacking.getLiteral("cardiorespiratory_semiology")+"</b><br/>";
                                            }
                                            if(curER.erRegForm.cardioThorakikoAlgos!=null && curER.erRegForm.cardioThorakikoAlgos.length()>0){
                                                erDetails2+=langBacking.getLiteral("chest_pain")+": "+curER.erRegForm.cardioThorakikoAlgos+"<br/>";
                                            }
                                            if(curER.erRegForm.cardioXaraktiras!=null && curER.erRegForm.cardioXaraktiras.length()>0){
                                                erDetails2+="- "+langBacking.getLiteral("character")+": "+curER.erRegForm.cardioXaraktiras+"<br/>";
                                            }
                                            if(curER.erRegForm.cardioEnarxi!=null && curER.erRegForm.cardioEnarxi.length()>0){
                                                erDetails2+="- "+langBacking.getLiteral("commencement")+": "+curER.erRegForm.cardioEnarxi+"<br/>";
                                            }
                                            if(curER.erRegForm.cardioDiarkeia!=null && curER.erRegForm.cardioDiarkeia.length()>0){
                                                erDetails2+="- "+langBacking.getLiteral("duration")+": "+curER.erRegForm.cardioDiarkeia+"<br/>";
                                            }
                                            if(curER.erRegForm.cardioanapneustikiSimeiologia!=null && curER.erRegForm.cardioanapneustikiSimeiologia.length()>0){
                                                erDetails2+=curER.erRegForm.cardioanapneustikiSimeiologia+"<br/>";
                                            }
                                            
                                            
                                            if((curER.erRegForm.psychoDiathesi!=null && curER.erRegForm.psychoDiathesi.length()>0) || 
                                               (curER.erRegForm.psychoSymperifora!=null && curER.erRegForm.psychoSymperifora.length()>0) ||
                                               (curER.erRegForm.psychoSkepseis!=null && curER.erRegForm.psychoSkepseis.length()>0)){
                                                erDetails2+="<br/><b>"+langBacking.getLiteral("psychiatric_semiology")+"</b><br/>";
                                            }
                                            if(curER.erRegForm.psychoDiathesi!=null && curER.erRegForm.psychoDiathesi.length()>0){
                                                erDetails2+=langBacking.getLiteral("mood")+": "+curER.erRegForm.psychoDiathesi+"<br/>";
                                            }
                                            if(curER.erRegForm.psychoSymperifora!=null && curER.erRegForm.psychoSymperifora.length()>0){
                                                erDetails2+=langBacking.getLiteral("behavior")+": "+curER.erRegForm.psychoSymperifora+"<br/>";
                                            }
                                            if(curER.erRegForm.psychoSkepseis!=null && curER.erRegForm.psychoSkepseis.length()>0){
                                                erDetails2+=langBacking.getLiteral("thoughts")+": "+curER.erRegForm.psychoSkepseis+"<br/>";
                                            }
                                            
                                            if(i<patientEmergenciesList.size()-1)
                                            {
                                                out.println("['"+curER.getEmergencyDateAndTime(langBacking.getDateFormat())+"<br/><br/>"+langBacking.getLiteral("site")+": "+curER.SB.name+"','"+erDetails+"', '"+erDetails2+"'],");
                                            }
                                            else
                                            {
                                                out.println("['"+curER.getEmergencyDateAndTime(langBacking.getDateFormat())+"<br/><br/>"+langBacking.getLiteral("site")+": "+curER.SB.name+"','"+erDetails+"', '"+erDetails2+"']");
                                            }
                                        }
                                    %>
                                    ],
                                    columns: [
                                        { headerText: "<%= langBacking.getLiteral("date_time") %>" }, { headerText: "<%= langBacking.getLiteral("emergency_details") %>" }, { headerText: "<%= langBacking.getLiteral("emergency_details") %>" }
                                    ]
                                    });
                                });
                                </script>
                                <table id='patientEmergenciesTable'></table>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_emergencies_found"));
                            }
                            %>
                            
                        </div>
                    </div>
                    
                    
                <%
                }
                else
                {
                    out.println("No valid patient selected");
                }
                %>
                </div>
		<!-- end #content -->
                
<!--		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%//= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="viewPatientHistory.jsp?action=viewAppointments"><%//= langBacking.getLiteral("view_patient_appointment") %></a></li>
                                <li><a href="viewPatientHistory.jsp?action=viewEmergencies"><%//= langBacking.getLiteral("view_patient_emergencies") %></a></li>
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
    
    <script id="scriptInit" type="text/javascript">
$(document).ready(function () {
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();


$("#proselefsiSelect").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#smokerSelect").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#erDoctorSelect").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#tabs").wijtabs({
scrollable:false
});

});
</script>
    
</html>