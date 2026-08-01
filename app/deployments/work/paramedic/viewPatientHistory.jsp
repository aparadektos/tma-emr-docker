
<%@page import="beans.PatientFileBean"%>
<%@page import="beans.TeleAppointmentFileBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="beans.ReferralBean"%>
<%@page import="beans.Icd10Bean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="beans.DoctorBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.appointmentsBean"%>
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
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
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
        /*
        function popupViewEmergencyForm()
        {
            $("#popup").wijdialog({ 
                title: "Προβολή στοιχείων έκτακτου περιστατικού",
                width: 600, 
                height: 600, 
                modal: true,
                contentUrl: 'popupViewEmergencyForm.jsp', 
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
        
        */
       
       function removePatientFile(patFileHash)
       {
            if(confirm("<%= langBacking.getLiteral("delete_patient_file_confirm") %>"))
            {
                window.location.href="actions/remove_patient_file_action.jsp?patFileHash="+patFileHash;
            }
       }
    </script>
    
    <body >
        
        <%
        String patId=request.getParameter("patId");
        if(patId!=null && patId.trim().length()>0)
        {
            paramedicBacking.selectedPatientToViewHistory = paramedicBacking.getPatientById(patId.trim());
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
                    if(paramedicBacking!=null && paramedicBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(paramedicBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(paramedicBacking!=null && paramedicBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(paramedicBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(paramedicBacking!=null && paramedicBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(paramedicBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    paramedicBacking.resetMessages();
                    %>
                    
                    <%
                    if(paramedicBacking.selectedPatientToViewHistory!=null)
                    {
                    %>
                    <div class="post" style="width:100%">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("patient_demographics") %></a></h2>
                        <div class="entry">
                            <table border="0">
                                <tr>
                                    <td></td>
                                    <td colspan="7">
                                        <i><b><%= langBacking.getLiteral("unique_identifier") %></i></b>: <%= paramedicBacking.selectedPatientToViewHistory.id %>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="135px">
                                        <%
                                        paramedicBacking.selectedPatientToViewHistory=paramedicBacking.getPatientPhotoInfo(paramedicBacking.selectedPatientToViewHistory);
                                        if(paramedicBacking.selectedPatientToViewHistory.getPhotoFileBytes()!=null && paramedicBacking.selectedPatientToViewHistory.getPhotoFileBytes().length>0)
                                        {
                                            out.println("<img src='data:image/jpg;base64,"+paramedicBacking.selectedPatientToViewHistory.getPhotoByteArrayString()+"' style='max-width:200px; max-height: 110px' />");
                                        }
                                        else
                                        {
                                            out.println("<img src='../images/patient-icon.png' style='width:120px;'/>");
                                        }
                                        %>
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
                                                     <%= paramedicBacking.selectedPatientToViewHistory.name %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("surname") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.surname %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("fathers_name") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.fathersName %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("date_of_birth") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.getBirthDateStr(langBacking.getDateFormat()) %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("sex") %>:</td>
                                                <td>
                                                    <%= langBacking.getLiteral(paramedicBacking.selectedPatientToViewHistory.sex) %>
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
                                                    <%= paramedicBacking.selectedPatientToViewHistory.getAddressStr() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.homephone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.workphone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.mobilephone %>
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
                                                    <%= paramedicBacking.selectedPatientToViewHistory.getSsn() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                                <td>
                                                    <%= paramedicBacking.selectedPatientToViewHistory.insurancename %>
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
                                        <b><i><%= langBacking.getLiteral("other_identifier") %></i></b>: <%= paramedicBacking.selectedPatientToViewHistory.otherIdentifier %>
                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>
                    
                    <div id="accordion" style="width:1000px">
                        <div>
                            <h3><a href="#"><%= langBacking.getLiteral("view_patient_appointments") %></a></h3>
                            <div>
                                
                                <%
                                ArrayList<TeleAppointmentBean> patientTeleAppointmentsList = paramedicBacking.getAllTeleAppointmentsByPatientId(paramedicBacking.selectedPatientToViewHistory.id);
                                if(patientTeleAppointmentsList!=null && patientTeleAppointmentsList.size()>0)
                                {
                                %>
                                    <script id="scriptInit" type="text/javascript">
                                        $(document).ready(function () {
                                            $("#patientAppointmentsTable").wijgrid({
                                                allowSorting: true,
                                                allowPaging: true,
                                                pageSize: 3,
                                                allowColSizing: true,
                                                ensureColumnsPxWidth:true,
                                                data: [
                                        <%
                                            for(int i=0; i<patientTeleAppointmentsList.size(); i++)
                                            {
                                                TeleAppointmentBean curTeleAppointment=patientTeleAppointmentsList.get(i);
                                                curTeleAppointment.setAdviceIcdList(paramedicBacking.findAdviceIcdListByAppId(curTeleAppointment.getId()));
                                                curTeleAppointment.setDiagnosisIcdList(paramedicBacking.findDiagnosisIcdListByAppId(curTeleAppointment.getId()));
                                                
                                                if(curTeleAppointment.getEmergency().equalsIgnoreCase("true"))
                                                {
                                                    continue;
                                                }
                                                
                                                String dateTime = curTeleAppointment.getStartDateStr(langBacking.getDateFormat())+"<br/>";
                                                dateTime+=curTeleAppointment.getStartTimeStr()+" - "+curTeleAppointment.getEndTimeStr();
                                                
                                                String appointmentDetails="";
                                                if(curTeleAppointment.getSiteDoctorBean()!=null && curTeleAppointment.getSiteDoctorBean().id!=null && 
                                                   curTeleAppointment.getSiteDoctorBean().id.trim().length()>0)
                                                {
                                                    appointmentDetails=langBacking.getLiteral("sitedoctor")+": "+curTeleAppointment.getSiteDoctorBean().name+" "+curTeleAppointment.getSiteDoctorBean().surname+" ("+curTeleAppointment.getSiteDoctorBean().specialtyBean.nameEl+")";
                                                    appointmentDetails+="<br/>";
                                                    appointmentDetails+=langBacking.getLiteral("stia")+": "+curTeleAppointment.getSiteDoctorBean().SB.name;
                                                    appointmentDetails+="<br/><br/>";
                                                }
                                                else if(curTeleAppointment.getParamedicBean()!=null && curTeleAppointment.getParamedicBean().getId()!=null && 
                                                   curTeleAppointment.getParamedicBean().getId().trim().length()>0)
                                                {
                                                    appointmentDetails=langBacking.getLiteral("paramedic")+": "+curTeleAppointment.getParamedicBean().getFullName()+" ("+curTeleAppointment.getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")";
                                                    appointmentDetails+="<br/>";
                                                    appointmentDetails+=langBacking.getLiteral("stia")+": "+curTeleAppointment.getSB().name;
                                                    appointmentDetails+="<br/><br/>";
                                                }

                                                appointmentDetails+=langBacking.getLiteral("consultant")+": "+curTeleAppointment.getConsultantBean1().getName()+" "+curTeleAppointment.getConsultantBean1().getSurname()+" ("+curTeleAppointment.getConsultantBean1().getSpecialtyBean().getNameEl()+")";
                                                appointmentDetails+="<br/>";
                                                appointmentDetails+=langBacking.getLiteral("stis")+": "+curTeleAppointment.getStisBean1().getTitle()+" ("+curTeleAppointment.getStisBean1().getNosokomeio()+")";
                                                appointmentDetails+="<br/>";
                                                
                                                if(curTeleAppointment.getStisBean2()!=null && curTeleAppointment.getConsultantBean2()!=null)
                                                {
                                                    appointmentDetails+="<br/>";
                                                    appointmentDetails+=langBacking.getLiteral("consultant")+": "+curTeleAppointment.getConsultantBean2().getName()+" "+curTeleAppointment.getConsultantBean2().getSurname()+" ("+curTeleAppointment.getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                                                    appointmentDetails+="<br/>";
                                                    appointmentDetails+=langBacking.getLiteral("stis")+": "+curTeleAppointment.getStisBean2().getTitle()+" ("+curTeleAppointment.getStisBean2().getNosokomeio()+")";
                                                    appointmentDetails+="<br/>";
                                                }

                                                appointmentDetails+="<br/>";
                                                
                                                appointmentDetails+=langBacking.getLiteral("status")+": "+langBacking.getLiteral(curTeleAppointment.getStatus());
                                                appointmentDetails+="<br/>";
                                                appointmentDetails+=langBacking.getLiteral("comments")+": "+curTeleAppointment.getComments();
                                                
                                                ArrayList<TeleAppointmentFileBean> allAppFiles = paramedicBacking.getTeleAppointmentFilesByAppointmentId(curTeleAppointment.getId());
                                                String appFiles="<table style=\"border-collapse: collapse;border-style:none;\">";
                                                for(TeleAppointmentFileBean curFile : allAppFiles)
                                                {
                                                    String iconName = GlobalHelper.getIconFileName(curFile.getFileName());
                                                    appFiles+="<tr>";
                                                        appFiles+="<td style=\"border-collapse: collapse;border-style:none;\">";
                                                            appFiles+="<a href=\"actions/download_teleAppointment_file_action.jsp?fileId="+curFile.getId()+"\"><img src=\"../images/"+iconName+"\" width=\"25px\"/></a>";
                                                        appFiles+="</td>";
                                                        appFiles+="<td style=\"border-collapse: collapse;border-style:none;\">";
                                                            appFiles+=curFile.getFileName()+"<br/>";
                                                        appFiles+="</td>";
                                                    appFiles+="</tr>";
                                                }
                                                appFiles+="</table>";
                                                
                                                String adviceIcdText="";
                                                for(Icd10Bean curIcd : curTeleAppointment.getAdviceIcdList())
                                                {
                                                    adviceIcdText+=curIcd.code+" - "+curIcd.nameEl+"<br/>";
                                                }
                                                if(adviceIcdText.length()>0)
                                                {
                                                    adviceIcdText="<div align=\"center\"><img src=\"../images/icd10.jpg\" width=\"40px\"/></div>"+adviceIcdText;
                                                }
                                                
                                                String diagnosisIcdText="";
                                                for(Icd10Bean curIcd : curTeleAppointment.getDiagnosisIcdList())
                                                {
                                                    diagnosisIcdText+=curIcd.code+" - "+curIcd.nameEl+"<br/>";
                                                }
                                                if(diagnosisIcdText.length()>0)
                                                {
                                                    diagnosisIcdText="<div align=\"center\"><img src=\"../images/icd10.jpg\" width=\"40px\"/></div>"+diagnosisIcdText;
                                                }
                                                
                                                if(i<patientTeleAppointmentsList.size()-1)
                                                {
                                                    out.println("['"+dateTime+"','"+appointmentDetails+"','"+appFiles+"','"+curTeleAppointment.getTeleAdvice()+"<br/><br/>"+adviceIcdText+"','"+curTeleAppointment.getDiagnosis()+" <br/><br/>"+diagnosisIcdText+"'],");
                                                }
                                                else
                                                {
                                                    out.println("['"+dateTime+"','"+appointmentDetails+"','"+appFiles+"','"+curTeleAppointment.getTeleAdvice()+"<br/><br/>"+adviceIcdText+"','"+curTeleAppointment.getDiagnosis()+" <br/><br/>"+diagnosisIcdText+"']");
                                                }
                                            }
                                        %>
                                        ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("date_time") %>" , width: "110px" }, 
                                            { headerText: "<%= langBacking.getLiteral("appointment_details") %>" , width: "230px" }, 
                                            { headerText: "<%= langBacking.getLiteral("files") %>" , width: "220px"}, 
                                            { headerText: "<%= langBacking.getLiteral("tele_advice") %>" , width: "210px"}, 
                                            { headerText: "<%= langBacking.getLiteral("diagnosis") %>" , width: "210px"}
                                        ]
                                        });
                                    });
                                    </script>
                                    <table id='patientAppointmentsTable' style="width:950px"></table>
                                <%
                                }
                                else
                                {
                                    out.println(langBacking.getLiteral("no_appointments_found"));
                                }
                                %>
                            </div>
                        </div>
                        <div>
                            <h3><a href="#"><%= langBacking.getLiteral("view_patient_emergencies") %></a></h3>
                            <div>
                                <%
                                ArrayList<EmergencyCaseBean> patientEmergenciesList = paramedicBacking.getAllEmergenciesByPatientId(paramedicBacking.selectedPatientToViewHistory.id);
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
                                                ensureColumnsPxWidth:true,
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
                                                    out.println("['"+curER.getEmergencyDateAndTime(langBacking.getDateFormat())+"<br/><br/>"+langBacking.getLiteral("site")+": "+curER.SB.name+"','"+erDetails+"', '"+erDetails2+"', ''],");
                                                }
                                                else
                                                {
                                                    out.println("['"+curER.getEmergencyDateAndTime(langBacking.getDateFormat())+"<br/><br/>"+langBacking.getLiteral("site")+": "+curER.SB.name+"','"+erDetails+"', '"+erDetails2+"', '']");
                                                }
                                            }
                                        %>
                                        ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("date_time") %>" , width: "120px" }, 
                                            { headerText: "<%= langBacking.getLiteral("emergency_details") %>" , width: "350px" }, 
                                            { headerText: "<%= langBacking.getLiteral("emergency_details") %>" , width: "340px" }, 
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width: "140px"}
                                        ]
                                        });
                                    });
                                    </script>
                                    <table id='patientEmergenciesTable' style="width:950px"></table>
                                <%
                                }
                                else
                                {
                                    out.println(langBacking.getLiteral("no_emergencies_found"));
                                }
                                %>
                            </div>
                        </div>
                        <div>
                            <h3><a href="#"><%= langBacking.getLiteral("patient_files") %></a></h3>
                            <div>
                                <b><%= langBacking.getLiteral("add_file") %></b>
                                <form method="post" action="actions/upload_patient_file_action.jsp" enctype="multipart/form-data">
                                    <table border="0" width="100%">
                                        <tr>
                                            <td >
                                                <input type="file" name="patFile"/>
                                            </td>
                                            <td width="300px" align="left">
                                                <input type="text" name="comments" placeholder="Σχόλια" style="width:350px" />
                                            </td>
                                            <td width="300px" align="left">
                                                <input type="submit" value="<%= langBacking.getLiteral("save") %>"/>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                                <br/>
                                <table id='patientFilesTable' style="width:950px"></table>
                                <script type="text/javascript">
                                    $("#patientFilesTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 10,
                                        allowColSizing: true,
                                        ensureColumnsPxWidth:true,
                                        data: [
                                        <%
                                        ArrayList<PatientFileBean> allPatientFilesResults = paramedicBacking.getAllPatientFilesResults();
                                        String tableContents="";
                                        for(PatientFileBean curPatFileBean : allPatientFilesResults)
                                        {
                                            SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
                                            String curDateTime = "<div align=\"center\">"+sdf.format(new Date(curPatFileBean.getDateTime().getTime()))+"</div>";
                                            String iconName = GlobalHelper.getIconFileName(curPatFileBean.getFileName());
                                            String curFileName = "<a href=\"actions/download_patient_file_action.jsp?patFileId="+curPatFileBean.getId()+"\"><img src=\"../images/"+iconName+"\" width=\"35px\" /></a>&nbsp;"+curPatFileBean.getFileName();
                                            String curAccountInfo = curPatFileBean.getAB().getFullName();
                                            if(curPatFileBean.getAB().getParamedicBean()!=null && curPatFileBean.getAB().getParamedicBean().getId()!=null && curPatFileBean.getAB().getParamedicBean().getId().length()>0)
                                            {
                                                curAccountInfo+="<br/>"+curPatFileBean.getAB().getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang);
                                                curAccountInfo+="<br/>"+curPatFileBean.getUploadSiteBean().name;
                                            }
                                            else if(curPatFileBean.getAB().docBean!=null && curPatFileBean.getAB().docBean.id!=null && curPatFileBean.getAB().docBean.id.length()>0)
                                            {
                                                curAccountInfo+="<br/>"+curPatFileBean.getAB().docBean.specialtyBean.getNameByLang(langBacking.lang);
                                                curAccountInfo+="<br/>"+curPatFileBean.getUploadSiteBean().name;
                                            }
                                            else if(curPatFileBean.getAB().consultantBean!=null && curPatFileBean.getAB().consultantBean.getId()!=null && curPatFileBean.getAB().consultantBean.getId().length()>0)
                                            {
                                                curAccountInfo+="<br/>"+curPatFileBean.getAB().consultantBean.getSpecialtyBean().getNameByLang(langBacking.lang);
                                            }
                                            String curComments=curPatFileBean.getComments();
                                            String curActions="<div align=\"center\">";
                                            if(curPatFileBean.getAB().id.equals(paramedicBacking.getAB().id))
                                            {
                                                curActions+="<a href=\"javascript:removePatientFile("+curPatFileBean.hashCode()+");\"><img src=\"../images/delete.gif\" width=\"30px\"/></a>";
                                            }
                                            curActions+="</div>";
                                            
                                            tableContents+="['"+curDateTime+"','"+curFileName+"','"+curAccountInfo+"','"+curComments+"','"+curActions+"'],";
                                        }
                                        if(tableContents.endsWith(","))
                                        {
                                            tableContents.substring(0, tableContents.length()-1);
                                        }
                                        out.println(tableContents);
                                        %>
                                                ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("date_time") %>" , width: "100px" }, 
                                            { headerText: "<%= langBacking.getLiteral("file") %>" , width: "290px" }, 
                                            { headerText: "<%= langBacking.getLiteral("account_information") %>" , width: "200px" }, 
                                            { headerText: "<%= langBacking.getLiteral("comments") %>" , width: "280px" }, 
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width: "80px"}
                                        ]
                                        });
                                </script>
                            </div>
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
                
                <input type="hidden" id="cancelAppId" value=""/>
                
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
$("input[type=submit]").button();



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

$("#accordion").wijaccordion({
header: "h3",
requireOpenedPane: false,
collapsible: true,
selectedIndex: 5
});



});
</script>
    
</html>