<%@page import="beans.CountryBean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="java.util.Date"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>

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
    var patSSN = document.getElementById("patSSN").value;
    var patOtherIdentifier = document.getElementById("patOtherIdentifier").value;
    
    var amkaFilled=false;
    var amkaValid=false;
    var otherFilled=false;
    
    if(patSSN!==null && patSSN.length>0)
    {
        amkaFilled=true;
        if(patSSN!==null && patSSN.length!==11)
        {
            amkaValid=false;
        }
        else
        {
            amkaValid=true;
        }
    }
    
    if(patOtherIdentifier!==null && patOtherIdentifier.length>0)
    {
        otherFilled=true;
    }
    
    if(amkaFilled)
    {
        if(amkaValid===false)
        {
            alert("Το ΑΜΚΑ πρέπει να αποτελείται από 11 αριθμητικους χαρακτήρες.");
        }
        else
        {
            document.getElementById("addPatientForm").submit();
        }
    }
    else
    {
        if(otherFilled)
        {
            document.getElementById("addPatientForm").submit();
        }
        else
        {
            alert("Πρέπει να συμπληρωθεί τουλάχιστον το ΑΜΚΑ ή το Άλλο Αναγνωριστικό.")
        }
    }
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

$("#patNationalityId").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

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

                    <div class="post" id="newSiteFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("add_new_patient") %></a></h2>
                        <div class="entry">
                            <form id="addPatientForm" method="post" action="actions/add_patient_action.jsp" enctype="multipart/form-data">
                                <table border="0">
                                    <tr>
                                        <td colspan="2">
                                            <b><i><%= langBacking.getLiteral("patient_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("name") %>:</font></td>
                                        <td>
                                            <input name="patName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("surname") %>:</font></td>
                                        <td>
                                            <input name="patSurname" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("fathers_name") %>:</font></td>
                                        <td>
                                            <input name="patFathersName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("date_of_birth") %>:</font></td>
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
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("sex") %>:</font></td>
                                        <td>
                                            <input name="patSex" value="male" type="radio"/><%= langBacking.getLiteral("male") %>
                                            <input name="patSex" value="female" type="radio"/><%= langBacking.getLiteral("female") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("nationality") %>:</font></td>
                                        <td>
                                            <select name="patNationalityId" id="patNationalityId">
                                                <%
                                                paramedicBacking.getAllCountriesAndNationalities(langBacking.lang);
                                                for(CountryBean curNationBean : paramedicBacking.getAllCountriesAndNationalitiesList())
                                                {
                                                    if(langBacking.lang.equalsIgnoreCase("greek"))
                                                    {
                                                        if(curNationBean.getNationalityEn().equalsIgnoreCase("unknown"))
                                                        {
                                                            out.println("<option selected='true' value='"+curNationBean.getId()+"'>"+curNationBean.getNationalityEl()+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+curNationBean.getId()+"'>"+curNationBean.getNationalityEl()+"</option>");
                                                        }
                                                    }
                                                    else
                                                    {
                                                        if(curNationBean.getNationalityEn().equalsIgnoreCase("unknown"))
                                                        {
                                                            out.println("<option selected='true' value='"+curNationBean.getId()+"'>"+curNationBean.getNationalityEn()+"</option>");
                                                        }
                                                        else
                                                        {
                                                            out.println("<option value='"+curNationBean.getId()+"'>"+curNationBean.getNationalityEn()+"</option>");
                                                        }
                                                    }
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("photo") %>:</td>
                                        <td>
                                            <input name="patPhotoFile" type="file" />
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="2">
                                            <br/>
                                            <b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("street") %>:</td>
                                        <td>
                                            <input name="patAddressStreet" id="textbox" type="text" size="53"/>
<!--                                            <textarea name="patAddress" id="area" rows="2" cols="50"></textarea>-->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("number") %>:</td>
                                        <td>
                                            <input name="patAddressNumber" id="textbox" type="text" size="7"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("area") %>:</td>
                                        <td>
                                            <input name="patAddressArea" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("zip_code") %>:</td>
                                        <td>
                                            <input name="patAddressZip" id="textbox" type="text" size="7"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                        <td>
                                            <input name="patHomePhone" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                        <td>
                                            <input name="patWorkPhone" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
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
                                        <td align="right">
                                            <font color="orange"><%= langBacking.getLiteral("social_security_number") %>:</font>
                                        </td>
                                        <td>
                                            <input name="patSSN" id="patSSN" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
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
                                        <td align="right">
                                            <font color="orange">
                                                <%= langBacking.getLiteral("other_identifier") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="patOtherIdentifier" id="patOtherIdentifier" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="purple">
                                                <a href="ENTYPO-SYNAINESIS-ASTHENOYS-EDIT.pdf"><img src="../images/edit_icon.png"/></a>&nbsp;
                                                <%= langBacking.getLiteral("declaration_of_consent") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="patDeclarationFile" type="file" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <input type="checkbox" name="patDocDeclaration"/>
                                        </td>
                                        <td>
                                            <font color="purple">
                                                <%= langBacking.getLiteral("doctor_declaration") %>
                                            </font>
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