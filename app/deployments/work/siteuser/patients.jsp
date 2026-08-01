<%@page import="beans.ExamTypeBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.appointmentsBean"%>
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

function popupExamTypeSearchForm()
{
    if(document.getElementById("examTypeDescr").value.length<3)
    {
        alert("Συμπληρώστε τουλάχιστον 3 χαρακτήρες για να πραγματοποιηθεί αναζήτηση τύπου εξέτασης");
    }
    else
    {
        $("#popup").wijdialog({ 
            title: "Αναζήτηση τύπου εξέτασης",
            width: 950, 
            height: 750, 
            modal: true,
            contentUrl: 'popupSearchExamType.jsp?examTypeDescr='+document.getElementById("examTypeDescr").value, 
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
}

function popupICD10SearchForm()
{
    var xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
            //document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
        }
    }
    
    var url = "actions/select_timeslot_div_id_action.jsp?examRoomId="+document.getElementById("examRoomIDHidden").value;
    url+="&divId="+document.getElementById("DivIDHidden").value;
    url+="&appointmentComment="+document.getElementById("appComments").value;
    
    xmlhttp.open("POST",url,true);
    xmlhttp.send();
    
    $("#popup").wijdialog({ 
        title: "<%= langBacking.getLiteral("search_by_icd10") %>",
        width: 950, 
        height: 750, 
        modal: true,
        contentUrl: 'popupSearchICD10.jsp', 
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
    <%
    if(langBacking.lang.equalsIgnoreCase("greek"))
    {
        out.println("culture: 'el-GR',");
    }
    %>
    dateFormat: '<%= langBacking.getDateFormat() %>',
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
                    
                    boolean showResults=true;
                    %>
                    
                    
                    <%
                    if(request.getParameter("action")!=null && request.getParameter("action").length()>0 && request.getParameter("action").equalsIgnoreCase("addPatient"))
                    {
                        showResults=false;
                    %>
                    <div class="post" id="newSiteFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("add_new_patient") %></a></h2>
                        <div class="entry">
                            <form id="addPatientForm" method="post" action="actions/add_patient_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td colspan="2">
                                            <b><i><%= langBacking.getLiteral("patient_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><font color="red"><%= langBacking.getLiteral("name") %>:</font></td>
                                        <td>
                                            <input name="patName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><font color="red"><%= langBacking.getLiteral("surname") %>:</font></td>
                                        <td>
                                            <input name="patSurname" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><font color="red"><%= langBacking.getLiteral("fathers_name") %>:</font></td>
                                        <td>
                                            <input name="patFathersName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><font color="red"><%= langBacking.getLiteral("date_of_birth") %>:</font></td>
                                        <td>
                                            <%
                                            if(langBacking.lang.equalsIgnoreCase("english"))
                                            {
                                            %>
                                            <table border="0">
                                                <tr>
                                                    <td>
                                                        <%= langBacking.getLiteral("month") %>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td>
                                                        <%= langBacking.getLiteral("day") %>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td>
                                                        <%= langBacking.getLiteral("year") %>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td>
                                                        <select name="monthObPicker" id="monthObPicker">
                                                            <option selected="true" value=" "> </option>
                                                            <%
                                                            for(int i=1; i<=12; i++)
                                                            {
                                                                out.println("<option value='"+i+"'>"+i+"</option>");
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td>
                                                        <select name="dayObPicker" id="dayObPicker">
                                                            <option selected="true" value=" "> </option>
                                                            <%
                                                            for(int i=1; i<=31; i++)
                                                            {
                                                                out.println("<option value='"+i+"'>"+i+"</option>");
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;
                                                    </td>
                                                    <td>
                                                        <select name="yearObPicker" id="yearObPicker">
                                                            <option selected="true" value=" "> </option>
                                                            <%
                                                            Date today=new Date();
                                                            for(int i=(today.getYear()+1900); i>(today.getYear()+1900-140); i--)
                                                            {
                                                                out.println("<option value='"+i+"'>"+i+"</option>");
                                                            }
                                                            %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </table>
                                            <%
                                            }
                                            else if(langBacking.lang.equalsIgnoreCase("greek"))
                                            {
                                            %>
                                                <table border="0">
                                                    <tr>
                                                        <td>
                                                            <%= langBacking.getLiteral("day") %>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <%= langBacking.getLiteral("month") %>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <%= langBacking.getLiteral("year") %>
                                                        </td>
                                                    </tr>

                                                    <tr>
                                                        <td>
                                                            <select name="dayObPicker" id="dayObPicker">
                                                                <option selected="true" value=" "> </option>
                                                                <%
                                                                for(int i=1; i<=31; i++)
                                                                {
                                                                    out.println("<option value='"+i+"'>"+i+"</option>");
                                                                }
                                                                %>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <select name="monthObPicker" id="monthObPicker">
                                                                <option selected="true" value=" "> </option>
                                                                <%
                                                                for(int i=1; i<=12; i++)
                                                                {
                                                                    out.println("<option value='"+i+"'>"+i+"</option>");
                                                                }
                                                                %>
                                                            </select>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <select name="yearObPicker" id="yearObPicker">
                                                                <option selected="true" value=" "> </option>
                                                                <%
                                                                Date today=new Date();
                                                                for(int i=(today.getYear()+1900); i>(today.getYear()+1900-140); i--)
                                                                {
                                                                    out.println("<option value='"+i+"'>"+i+"</option>");
                                                                }
                                                                %>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                </table>
                                            <%
                                            }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><font color="red"><%= langBacking.getLiteral("sex") %>:</font></td>
                                        <td>
                                            <input name="patSex" value="male" type="radio"/><%= langBacking.getLiteral("male") %>
                                            <input name="patSex" value="female" type="radio"/><%= langBacking.getLiteral("female") %>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="2">
                                            <br/>
                                            <b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("address") %>:</td>
                                        <td>
                                            <textarea name="patAddress" id="area" rows="2" cols="50"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("home_phone") %>:</td>
                                        <td>
                                            <input name="patHomePhone" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("work_phone") %>:</td>
                                        <td>
                                            <input name="patWorkPhone" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                        <td>
                                            <input name="patMobilePhone" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br/>
                                            <b><i><%= langBacking.getLiteral("insurance") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("social_security_number") %>:</td>
                                        <td>
                                            <input name="patSSN" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                        <td>
                                            <input name="patInsuranceName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br/>
                                            <b><i><%= langBacking.getLiteral("other_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><%= langBacking.getLiteral("other_identifier") %>:</td>
                                        <td>
                                            <input name="patOtherIdentifier" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <br/>
                                            <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkNewPatientForm();"/>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                        </div>
                    </div>
                    <%
                    }
                    else if(request.getParameter("action")!=null && request.getParameter("patid")!=null && request.getParameter("patid").length()>0 &&  request.getParameter("action").length()>0 && request.getParameter("action").equalsIgnoreCase("newAppoint"))
                    {
                        showResults=false;
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
                    %>                           
                        <div class="post" id="searchTimeslotFormDiv">
                            <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("new_appointment") %></a></h2>
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
                            <br/>
                            <%= langBacking.getLiteral("examination_type") %>:
                            <br/>
                            <table border="0">
                                <tr>
                                    <td width="400px">
                                        <input type="text" style="width:400px" value="" name="examTypeDescr" id="examTypeDescr"/> 
                                    </td>
                                    <td>
                                        <a href="javascript: popupExamTypeSearchForm();"><img src="../images/kialia.png" width="40px"/></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5">
                                        <%
                                        if(newAppBean.ETB.getModalityType()!=null && newAppBean.ETB.getModalityType().length()>0)
                                        {
                                            out.println("("+newAppBean.ETB.getModalityType()+") "+newAppBean.ETB.getDescriptionEl());
                                        }
                                        else
                                        {
                                            out.println(newAppBean.ETB.getDescriptionEl());
                                        }
                                        %>
                                    </td>
                                </tr>
                            </table>

                            <form id="searchTimeslotForm" method="post" action="actions/search_examroom_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td>
                                            <input type="hidden" name="apExamType" value="<%= newAppBean.ETB.getId() %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <br/>
                                            <%= langBacking.getLiteral("duration_in_minutes") %>:
                                        </td>
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
                    <form id="addAppointmentForm" method="post" action="actions/add_appoint_action.jsp">
                    <div class="post" id="searchExamRoomsFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("exam_rooms_availability") %></a></h2>
                        <div class="entry">
                            
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#timeslotsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 32,
                                    allowColSizing: true,
                                    ensureColumnsPxWidth:true,
                                    data: [
                            <%
                                //curDate should be MM/dd/yyyy
                                Date today=new Date();
                                String curDate=(today.getMonth()+1)+"/"+today.getDate()+"/"+(today.getYear()+1900);
                                if(onDate!=null && onDate.length()>0)
                                {
                                    if(langBacking.lang.equalsIgnoreCase("greek"))
                                    {
                                        SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat());
                                        Date submittedDate = sdf.parse(onDate);
                                        sdf = new SimpleDateFormat("MM/dd/yyyy");
                                        onDate=sdf.format(submittedDate);
                                    }
                                    
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
                                        { headerText: "<%= langBacking.getLiteral("timeslot") %>" , width: "100px"},
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
                            
                            <%
                            if(examRoomsResults.size()<=6)
                            {
                                out.println("<table id='timeslotsTable'></table>");
                            }
                            else if(examRoomsResults.size()<=10)
                            {
                                out.println("<table id='timeslotsTable' style='width:1000px'></table>");
                            }
                            else
                            {
                                out.println("<table id='timeslotsTable' style='width:1800px'></table>");
                            }
                            %>
                            
                            <br/><br/>
                            
                            <input type="hidden" id="examRoomIDHidden" name="examRoomIDHidden"/>
                            
                            <table border="0">
                                <tr>
                                    <td align="right" width="110px">
                                        <%= langBacking.getLiteral("date_time") %>:
                                    </td>
                                    <td>
                                        <input readonly type="text" id="selectedAppDatetime" name="selectedAppDatetime"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("external_appointment") %>:
                                    </td>
                                    <td>
                                        <input type="radio" name="externalPat" value="1"><%= langBacking.getLiteral("yes") %></input> &nbsp; <input type="radio" name="externalPat" id="externalPat" value="0" checked><%= langBacking.getLiteral("no") %></input>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <%= langBacking.getLiteral("comment") %>:
                                    </td>
                                    <td>
                                        <textarea name="appComments" rows="2" cols="70"></textarea>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <div class="post" id="patientHistoryFormDiv">
                        <h2 class="title">
                        <a href="#"><%= langBacking.getLiteral("patient_history") %></a></h2>
                        <table border="0" width="100%">
                            <tr>
                                <td align="right" width="110px">
                                    <%= langBacking.getLiteral("chief_complaint") %>
                                </td>
                                <td>
                                    <textarea name="patComplaint" id="area" rows="2" cols="60"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <%= langBacking.getLiteral("alergies") %>
                                </td>
                                <td>
                                    <textarea name="patAlergies" id="area" rows="2" cols="60"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" align="center">
                                    <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkNewAppointForm();"/>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
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
                showResults=false;
                //new scheduled appointment confirmation view
                appointmentsBean newAppBean=siteUserBacking.newAppointment;
            %>
                <div class="post" id="searchPatientFormDiv">
                    <h2 class="title">
                    <a href="#"><%= langBacking.getLiteral("new_appointment_saved") %>!</a></h2>
                    <div class="entry">
                        <table border="0">
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("patient") %>:</td>
                                <td>
                                    <%
                                    out.println("<a href='viewPatientHistory.jsp?patId="+newAppBean.PB.id+"'>"+newAppBean.PB.name+" "+newAppBean.PB.surname+"</a>");
                                    %>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("ssn") %>:</td>
                                <td>
                                    <%= newAppBean.PB.getSsn() %>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("examination_type") %>:</td>
                                <td>
                                    <%= newAppBean.ETB.getDescriptionEl() %>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("examination_room") %>:</td>
                                <td>
                                    <%= newAppBean.ExamRoomBean.name %>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("date_time") %>:</td>
                                <td>
                                    <%= newAppBean.getAppointmentDateTimeStr(langBacking.getDateFormat()) %>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("duration") %>:</td>
                                <td>
                                    <%= newAppBean.duration %>'
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><%= langBacking.getLiteral("external_appointment") %>:</td>
                                <td>
                                    <%= (newAppBean.isexternal.equals("0")) ? langBacking.getLiteral("no") : langBacking.getLiteral("yes") %>
                                </td>
                            </tr>
<!--                            <tr>
                                <td align="left" colspan="2">
                                    <input type="button" value="<%//= langBacking.getLiteral("print") %>" onClick="javascript:print();"/>
                                </td>
                            </tr>-->
                        </table>
                    </div>
                </div>
            <%
            }
            else
            {
                //div gia searching
                session.setAttribute("newAppBean", null);
                session.setAttribute("examRoomsResults", null);
            %>
                <div class="post" id="searchPatientFormDiv">
                    <h2 class="title">
                        <a href="#"><%= langBacking.getLiteral("search_patient") %></a></h2>
                    <div class="entry">

                    <%
                    if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("error"))
                    {
                        out.println("<font color='red'>Cannot perform action! Make sure you filled all required fields.</font><br/><br/>");
                    }
                    else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("error4new"))
                    {
                        out.println("<font color='red'>"+langBacking.getLiteral("new_patient_failed")+".</font><br/><br/>");
                    }
                    else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("error4edit"))
                    {
                        out.println("<font color='red'>"+langBacking.getLiteral("edit_patient_failed")+".</font><br/><br/>");
                    }
                    else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("error4delete"))
                    {
                        out.println("<font color='red'>"+langBacking.getLiteral("delete_patient_failed")+".</font><br/><br/>");
                    }
                    else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("newPatientAdded"))
                    {
                        out.println("<font color='green'>New patient added!</font><br/><br/>");
                    }
                    else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("editPatientOK"))
                    {
                        out.println("<font color='green'>All changes have been successfully saved!</font><br/><br/>");
                    }
                    else if(request.getParameter("result")!=null && request.getParameter("result").equalsIgnoreCase("deletePatientOK"))
                    {
                        out.println("<font color='green'>Patient deleted successfully!</font><br/><br/>");
                    }
                    %>

                        <form id="searchPatientForm" method="post" action="actions/search_patient_action.jsp">
                            <table border="0">
                                <tr>
                                    <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                    <td>
                                        <input name="patName" id="textbox" type="text" size="25"/>
                                    </td>
                                    <td rowspan="7">&nbsp;&nbsp;</td>
                                    <td align="right"><%= langBacking.getLiteral("social_security_number") %>:</td>
                                    <td>
                                        <input name="patSSN" id="textbox" type="text" size="25"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right"><%= langBacking.getLiteral("surname") %>:</td>
                                    <td>
                                        <input name="patSurname" id="textbox" type="text" size="25"/>
                                    </td>
                                    <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                    <td>
                                        <input name="patMobilePhone" id="textbox" type="text" size="25"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right"><%= langBacking.getLiteral("fathers_name") %>:</td>
                                    <td>
                                        <input name="patFathersName" id="textbox" type="text" size="25"/>
                                    </td>
                                    <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                    <td>
                                        <input name="patHomePhone" id="textbox" type="text" size="25"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right"><%= langBacking.getLiteral("date_of_birth") %>:</td>
                                    <td>
                                        <%
                                        if(langBacking.lang.equalsIgnoreCase("english"))
                                        {
                                        %>
                                        <table border="0">
                                            <tr>
                                                <td>
                                                    <%= langBacking.getLiteral("month") %>:
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <%= langBacking.getLiteral("day") %>:
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <%= langBacking.getLiteral("year") %>:
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <select name="monthObPicker" id="monthObPicker">
                                                        <option selected value=" "> </option>
                                                        <%
                                                        for(int i=1; i<=12; i++)
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <select name="dayObPicker" id="dayObPicker">
                                                        <option selected value=" "> </option>
                                                        <%
                                                        for(int i=1; i<=31; i++)
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <select name="yearObPicker" id="yearObPicker">
                                                        <option selected value=" "> </option>
                                                        <%
                                                        Date today=new Date();
                                                        for(int i=(today.getYear()+1900); i>(today.getYear()+1900-140); i--)
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                        <%
                                        }
                                        else
                                        {
                                        %>
                                        <table border="0">
                                            <tr>
                                                <td>
                                                    <%= langBacking.getLiteral("day") %>:
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <%= langBacking.getLiteral("month") %>:
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <%= langBacking.getLiteral("year") %>:
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <select name="dayObPicker" id="dayObPicker">
                                                        <option selected value=" "> </option>
                                                        <%
                                                        for(int i=1; i<=31; i++)
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <select name="monthObPicker" id="monthObPicker">
                                                        <option selected value=" "> </option>
                                                        <%
                                                        for(int i=1; i<=12; i++)
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                                <td>
                                                    &nbsp;&nbsp;&nbsp;
                                                </td>
                                                <td>
                                                    <select name="yearObPicker" id="yearObPicker">
                                                        <option selected value=" "> </option>
                                                        <%
                                                        Date today=new Date();
                                                        for(int i=(today.getYear()+1900); i>(today.getYear()+1900-140); i--)
                                                        {
                                                            out.println("<option value='"+i+"'>"+i+"</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                        <%
                                        }
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                <td align="center" colspan="7">
                                    <input type="button" value="<%= langBacking.getLiteral("search") %>" onClick="javascript:checkSearchPatientForm();"/>
                                </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                </div>
                <%
                }
            
                if(siteUserBacking.patientSearchResults!=null && siteUserBacking.patientSearchResults.size()>0
                            && showResults==true)
                {
                    //search results
                %>
                <div class="post">
                    <h2 class="title">
                        <a href="#"><%= langBacking.getLiteral("search_results") %></a></h2>
                    <div class="entry">
                        <%
                        //show results
                        if(request.getParameter("results")!=null && request.getParameter("results").equalsIgnoreCase("noResults"))
                        {
                            out.println("<font color='red'>No patients found.</font><br/><br/>");
                        }
                        else if(request.getParameter("results")!=null && request.getParameter("results").equalsIgnoreCase("invalidParams"))
                        {
                            out.println("<font color='red'>"+langBacking.getLiteral("invalid_search")+"</font><br/><br/>");
                        }
                        //else if(request.getParameter("results").equalsIgnoreCase("true"))
                        else if(siteUserBacking.patientSearchResults!=null && siteUserBacking.patientSearchResults.size()>0)
                        {
                            //we have results
                            //ArrayList<patBean> patList=(ArrayList<patBean>)session.getAttribute("patList");
                            
                            ArrayList<patBean> patList=siteUserBacking.patientSearchResults;
                            if(patList!=null && patList.size()>0)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#patsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    ensureColumnsPxWidth:true,
                                    data: [
                            <%
                                for(int i=0; i<patList.size(); i++)
                                {
                                    patBean PB=patList.get(i);
                                    if(i<patList.size()-1)
                                    {
                                        out.println("['"+PB.name+"<br/>"+PB.surname+"<br/>("+PB.getBirthDateStr(langBacking.getDateFormat())+")<br/>"+langBacking.getLiteral(PB.sex)+"', '"+PB.fathersName+"', '"+PB.mobilephone+"<br/>"+PB.homephone+"<br/>','"+PB.insurancename+"<br/>"+PB.getSsn()+"','<a href=\"viewPatientHistory.jsp?patId="+PB.id+"\"><img title=\""+langBacking.getLiteral("view_patient_record")+"\" src=\"../images/openFile.png\"/></a>&nbsp;&nbsp;&nbsp;<a href=\"editPatient.jsp?patId="+PB.id+"\"><img title=\""+langBacking.getLiteral("edit_patient")+"\" src=\"../images/edit2.png\" width=\"30px\"/></a>&nbsp;&nbsp;<a href=\"patients.jsp?action=newAppoint&patid="+PB.id+"\"><img title=\""+langBacking.getLiteral("new_appointment")+"\" width=32px src=\"../images/addAppointment.png\"/></a>&nbsp;&nbsp;&nbsp;<a href=\"emergency.jsp?patid="+PB.id+"\"><img title=\""+langBacking.getLiteral("new_emergency_case")+"\" width=33px src=\"../images/emergencies.png\"/></a>' ],");
                                    }
                                    else
                                    {
                                        out.println("['"+PB.name+"<br/>"+PB.surname+"<br/>("+PB.getBirthDateStr(langBacking.getDateFormat())+")<br/>"+langBacking.getLiteral(PB.sex)+"', '"+PB.fathersName+"', '"+PB.mobilephone+"<br/>"+PB.homephone+"<br/>','"+PB.insurancename+"<br/>"+PB.getSsn()+"','<a href=\"viewPatientHistory.jsp?patId="+PB.id+"\"><img title=\""+langBacking.getLiteral("view_patient_record")+"\" src=\"../images/openFile.png\"/></a>&nbsp;&nbsp;&nbsp;<a href=\"editPatient.jsp?patId="+PB.id+"\"><img title=\""+langBacking.getLiteral("edit_patient")+"\" src=\"../images/edit2.png\" width=\"30px\"/></a>&nbsp;&nbsp;<a href=\"patients.jsp?action=newAppoint&patid="+PB.id+"\"><img title=\""+langBacking.getLiteral("new_appointment")+"\" width=32px src=\"../images/addAppointment.png\"/></a>&nbsp;&nbsp;&nbsp;<a href=\"emergency.jsp?patid="+PB.id+"\"><img title=\""+langBacking.getLiteral("new_emergency_case")+"\" width=33px src=\"../images/emergencies.png\"/></a>']");
                                    }
                                }
                            %>
                            ],
                            columns: [
                                { headerText: "<%= langBacking.getLiteral("name") %> / <%= langBacking.getLiteral("date_of_birth_short") %>", width: "180px"  }, 
                                { headerText: "<%= langBacking.getLiteral("fathers_name") %>" }, 
                                { headerText: "<%= langBacking.getLiteral("contact") %>", width: "180px"  }, 
                                { headerText: "<%= langBacking.getLiteral("insurance") %> / <%= langBacking.getLiteral("social_security_number") %>" }, 
                                { headerText: "<%= langBacking.getLiteral("actions") %>", width: "180px"}
                            ]
                            });
                        });
                        </script>

                            <%
                            out.println("<table id='patsTable'>");
                            out.println("</table>");
                            }
                            else
                            {
                                out.println("No patients found!");
                            }
                        }

//                        if(siteUserBacking.searchedPatientBean!=null)
//                        {
//                            out.println("<br/><br/>");
//                            out.println("<input type='button' value='Έκτακτο περιστατικό μη καταχωρημένου ασθενούς' onClick=\"javascript:window.location='emergency.jsp'\"/>");
//                        }
                        %>
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
                            <li><a href="emergency.jsp?patient=unknown"><%= langBacking.getLiteral("unknown_patient_emergency_case") %></a></li>
                        </ul>
                    </li>
                </ul>

                <%
                ArrayList<ExamroomsBean> examRoomsResults=(ArrayList<ExamroomsBean>)session.getAttribute("examRoomsResults");
                if(examRoomsResults!=null && examRoomsResults.size()>0)
                {
                    appointmentsBean newAppBean=(appointmentsBean)session.getAttribute("newAppBean");
                %>
                    <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
                    <%= langBacking.getLiteral("date") %>:
                    <br/>
                    <input type="text" id="previewDatePicker" name="previewDatePicker" />
                    <br/>
                    <input type="button" value="<%= langBacking.getLiteral("refresh") %>" onClick="javascript:window.location='patients.jsp?action=newAppoint&patid=<%=newAppBean.PB.id%>&onDate='+document.getElementById('previewDatePicker').value;"/>
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