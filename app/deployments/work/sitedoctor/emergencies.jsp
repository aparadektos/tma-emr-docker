
<%@page import="beans.EmergencyFileBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="backings.SiteDoctorBacking"%>
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
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
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
        
        function popupAssignConsultant(erHash)
        {
            $("#popup").wijdialog({ 
                title: "<%= langBacking.getLiteral("instant_consultant_assignment") %>",
                width: 700, 
                height: 800, 
                modal: true,
                contentUrl: 'popupAssignConsultant.jsp?erHash='+erHash, 
                captionButtons: {
                    pin: { visible: false },
                    refresh: { visible: false },
                    toggle: { visible: false },
                    minimize: { visible: false },
                    maximize: { visible: true }
                },
                autoOpen: true
            });
        }
        
        function popupNewEmergencyFile(erHash)
        {
            $("#popup").wijdialog({ 
                title: "<%= langBacking.getLiteral("add_file") %>",
                width: 570, 
                height: 570, 
                modal: true,
                contentUrl: 'popupNewEmergencyFile.jsp?erHash='+erHash, 
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
    
    <body >
        
        <div id="popup"></div>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "emergencies"); %>
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
                    
                    <div class="post" style="width: 100%;" >
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("emergency_cases") %></a>
                        </h2>
                        
                        <div class="entry">
                            <form name="searchEmergenciesForm" action="actions/search_emergencies_action.jsp" method="post">
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
                                           if(siteDoctorBacking.emergenciesSearchExamRoomId==null)
                                           {
                                               out.println("<option selected value='All rooms'>"+langBacking.getLiteral("all_rooms")+"</option>");
                                           }
                                           else
                                           {
                                               out.println("<option value='All rooms'>"+langBacking.getLiteral("all_rooms")+"</option>");
                                           }
            
                                            ArrayList<ExamroomsBean> exRoomsList=DBH.getExamRoomsBySiteID(AB.SB.id);
                                           for(ExamroomsBean exRoom : exRoomsList)
                                           {
                                               if(exRoom.id.equalsIgnoreCase(siteDoctorBacking.emergenciesSearchExamRoomId))
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
                                           <input type="text" id="erStartDatePicker" name="erStartDatePicker" />
                                       </td> 
                                   </tr>
                                   <tr>
                                       <td>
                                         <input type="submit" value="<%= langBacking.getLiteral("search") %>"/>
                                      </td> 
                                      <td>
                                           &nbsp;&nbsp;&nbsp;
                                       </td>
                                      <td>
                                           &nbsp;&nbsp;&nbsp;
                                       </td>
                                      <td rowsan="5" width="100%" align="right">
                                           <a href="emergency.jsp?patient=unknown">
                                                <input type="button" value="<%= langBacking.getLiteral("unknown_patient_emergency_case") %>" />
                                            </a>
                                       </td>
                                   </tr>        
                               </table>
                           </form>

                        </div>
                    </div>

                    <%
                    ArrayList<EmergencyCaseBean> emergenciesList=siteDoctorBacking.emergenciesSearchResults;
                    if(emergenciesList!=null && emergenciesList.size()>0)
                    {
                    %>
                    <div class="post" style="width: 100%;" >
<!--                        <h2 class="title"><a href="#">Appointments Table</a></h2>-->
                        <div class="entry">
                            <%
                            
                            if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("patientSentError"))
                            {
                                out.println("<font color='red'>Appointment failed to be sent to PACS.</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("patientSentOK"))
                            {
                                out.println("<font color='green'>Appointment sent to PACS!</font><br/><br/>");
                            }
                            else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("invalidAppID"))
                            {
                                out.println("<font color='red'>Invalid appointment</font><br/><br/>");
                            }
                            %>
                                <script id="scriptInit" type="text/javascript">
                                $(document).ready(function () {
                                    $("#emergenciesTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 10,
                                        allowColSizing: true,
                                        ensureColumnsPxWidth:true,
                                        data: [
                                <%
                                    String sendStudyURL="";
                                    for(int i=0; i<emergenciesList.size(); i++)
                                    {
                                        EmergencyCaseBean curER=emergenciesList.get(i);
                                            
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
                                        
                                        String actionsHref="";
                                        String teleAdvice="";
                                        TeleAppointmentBean teleAppBean = siteDoctorBacking.getTeleAppointmentByEmergencyCaseId(curER.id);
                                        if(teleAppBean!=null && teleAppBean.getId()!=null && teleAppBean.getId().length()>0)
                                        {
                                            actionsHref+=langBacking.getLiteral("consultant")+": "+teleAppBean.getConsultantBean1().getFullName()+" ("+teleAppBean.getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")<br/><br/>";
                                            actionsHref+=langBacking.getLiteral("stis")+": "+teleAppBean.getStisBean1().getTitle()+" ("+teleAppBean.getStisBean1().getNosokomeio()+")<br/><br/>";
                                            actionsHref+=langBacking.getLiteral("date_time")+": "+teleAppBean.getStartEndDateTimeStr(langBacking.getDateFormat())+"<br/><br/>";
                                            teleAdvice=teleAppBean.getTeleAdvice();
                                        }
                                        else
                                        {
                                            actionsHref="<div align=\"center\"><a href=\"javascript:popupAssignConsultant("+curER.hashCode()+");\"><img title=\""+langBacking.getLiteral("instant_consultant_assignment")+"\" src=\"../images/consultAssign2.png\" width=\"32px\" /></a></div>";
                                        }
                                        
                                        String newErFileButton="<div align=\"center\"><a href=\"javascript:popupNewEmergencyFile("+curER.hashCode()+");\"><img src=\"../images/file_add.png\" width=\"30px\"></a></div>";
                                        
                                        String erFiles="";
                                        for(EmergencyFileBean curFile : curER.getFileList() )
                                        {
                                            String iconName = GlobalHelper.getIconFileName(curFile.getFileName());
                                            erFiles+="<a href=\"actions/download_emergency_file_action.jsp?erCaseId="+curER.id+"&erFileId="+curFile.getId()+"\"><img src=\"../images/"+iconName+"\" width=\"32px\"/></a> "+curFile.getFileNameSubStr(30)+"<br/><br/>";
                                        }
                                        
                                        String examRoomContent = "";
                                        if(curER.examRoomBean!=null && curER.examRoomBean.name!=null)
                                        {
                                            examRoomContent=curER.examRoomBean.name;
                                        }

                                        if(i<emergenciesList.size()-1)
                                        {
                                            out.println("['"+curER.getEmergencyDateAndTime(langBacking.getDateFormat())+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+curER.patientBean.id+"\">"+curER.patientBean.name+"<br/> "+curER.patientBean.surname+"</a><br/>("+curER.patientBean.id+")<br/><br/> "+examRoomContent+"<br/><br/>"+curER.getReadableId()+" ','"+erDetails+"', '"+erDetails2+"', '"+actionsHref+"', '"+newErFileButton+"<br/>"+erFiles+"','"+teleAdvice+"'],");
                                        }
                                        else
                                        {
                                            out.println("['"+curER.getEmergencyDateAndTime(langBacking.getDateFormat())+"<br/><br/><a target=\"_blank\" href=\"viewPatientHistory.jsp?patId="+curER.patientBean.id+"\">"+curER.patientBean.name+"<br/> "+curER.patientBean.surname+"</a><br/>("+curER.patientBean.id+")<br/><br/> "+examRoomContent+"<br/><br/>"+curER.getReadableId()+" ','"+erDetails+"', '"+erDetails2+"', '"+actionsHref+"', '"+newErFileButton+"<br/>"+erFiles+"','"+teleAdvice+"']");
                                        }
                                    }
                                %>
                                ],
                                columns: [
                                    { headerText: "<%= langBacking.getLiteral("date_time") %> - <%= langBacking.getLiteral("patient") %> - <%= langBacking.getLiteral("examination_room") %> - <%= langBacking.getLiteral("code") %>" , width: "130px" }, 
                                    { headerText: "<%= langBacking.getLiteral("emergency_details") %>" , width: "180px"}, 
                                    { headerText: "<%= langBacking.getLiteral("emergency_details") %>" , width: "180px"}, 
                                    { headerText: "<%= langBacking.getLiteral("consultant") %>" , width: "150px"},
                                    { headerText: "<%= langBacking.getLiteral("files") %>" , width: "200px" } ,
                                    { headerText: "<%= langBacking.getLiteral("tele_advice") %>" , width: "160px"},
                                ]
                                });
                            });
                            </script>
                            <table id='emergenciesTable' style="width:1000px"></table>
                        </div>
                    </div>
                <%
                }
                %>
                </div>

                </div>
		<!-- end #content -->
                <!--
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="emergency.jsp?patient=unknown"><%= langBacking.getLiteral("unknown_patient_emergency_case") %> </a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
                -->
		<!-- end #sidebar -->
		<div style="clear: both;"> </div>
	</div>
        </div>
            <!-- end #page -->
            <jsp:include page="footer.jsp"/>
        </div>
    </body>
    
    <script type="text/javascript">
        $("#roomFilter").wijdropdown();
        $(":input[type='button'],:input[type='submit']").button(); 

        $("#erStartDatePicker").wijinputdate({
            <%
            if(langBacking.lang.equalsIgnoreCase("greek"))
            {
                out.println("culture: 'el-GR',");
            }
            %>
        <%
        if(siteDoctorBacking.emergenciesSearchDateStr!=null && siteDoctorBacking.emergenciesSearchDateStr.length()>0)
        {
            out.println("date: '"+siteDoctorBacking.emergenciesSearchDateStr+"',");
        }
        %>
        //date: '12/8/2012',
        dateFormat: '<%= langBacking.getDateFormat() %>',
        showTrigger: true
        });



//$(document).ready(function () {
//$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
//$("#select1").wijdropdown();
//$(":input[type='radio']").wijradio();
//$(":input[type='checkbox']").wijcheckbox();
//
//
//
//$("#proselefsiSelect").wijcombobox({
//showingAnimation: { effect: "blind" },
//isEditable: false,
//autoFilter: true,
//autoComplete: true,
//highlightMatching: true,
//hidingAnimation: { effect: "blind" }
//});
//
//$("#smokerSelect").wijcombobox({
//showingAnimation: { effect: "blind" },
//isEditable: false,
//autoFilter: true,
//autoComplete: true,
//highlightMatching: true,
//hidingAnimation: { effect: "blind" }
//});
//
//$("#erDoctorSelect").wijcombobox({
//showingAnimation: { effect: "blind" },
//isEditable: false,
//autoFilter: true,
//autoComplete: true,
//highlightMatching: true,
//hidingAnimation: { effect: "blind" }
//});


</script>
    
</html>