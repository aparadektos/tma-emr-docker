
<%@page import="beans.EmergencyRegistrationFormBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="beans.DoctorBean"%>
<%@page import="backings.SiteDoctorBacking"%>
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

<%
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
    function checkEmergencyForm()
    {
        document.getElementById("emergencyForm").submit();
    }
</script>
    
    <body >
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "patients"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content" >
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
                    
                    
                
                    ArrayList<ExamroomsBean> examroomsBeans = siteDoctorBacking.getAllExamroomsBySiteId();

                    patBean PB=null;
                    String patient=request.getParameter("patient");
                    if(patient!=null && patient.trim().length()>0 && patient.trim().equals("unknown"))
                    {
                        PB=new patBean("", "", "", "", "", "", "", "", "", "", "", "", "true");
                        //new emergency case
                        siteDoctorBacking.newEmergencyCaseBean=new EmergencyCaseBean();
                        siteDoctorBacking.newEmergencyCaseBean.patientBean=PB;
                        siteDoctorBacking.newEmergencyCaseBean.erRegForm=new EmergencyRegistrationFormBean();
                        siteDoctorBacking.searchedPatientBean=null;
                    }
                    else
                    {
                        String patId=request.getParameter("patid");
                        if(patId!=null && patId.trim().length()>0)
                        {
                            PB = siteDoctorBacking.getPatientById(patId.trim());
                            //new emergency case
                            siteDoctorBacking.newEmergencyCaseBean=new EmergencyCaseBean();
                            siteDoctorBacking.newEmergencyCaseBean.patientBean=PB;
                            siteDoctorBacking.newEmergencyCaseBean.erRegForm=new EmergencyRegistrationFormBean();
                        }
                        else if(siteDoctorBacking.searchedPatientBean!=null)
                        {
                            PB=siteDoctorBacking.searchedPatientBean;
                            //new emergency case
                            siteDoctorBacking.newEmergencyCaseBean=new EmergencyCaseBean();
                            siteDoctorBacking.newEmergencyCaseBean.patientBean=PB;
                            siteDoctorBacking.newEmergencyCaseBean.erRegForm=new EmergencyRegistrationFormBean();
                        }
                    }
                    
                    if(siteDoctorBacking.newEmergencyCaseBean!=null && siteDoctorBacking.newEmergencyCaseBean.patientBean!=null)
                    {
                        PB=siteDoctorBacking.newEmergencyCaseBean.patientBean;
                %>
                    <form name="emergencyForm" id="emergencyForm" method="post" action="actions/add_emergency_action.jsp">
                        <div class="post">
                            <h2 class="title"><a href="#"><%= langBacking.getLiteral("patient") %></a></h2>
                            <div class="entry">
                                <%
                                if(PB.unknown!=null && PB.unknown.equals("true"))
                                {
                                %>
                                <table border="0">
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("name") %></td>
                                        <td>
                                            <input type="text" name="patName" value="<%= PB.name %>" style="width: 180px;"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right"><%= langBacking.getLiteral("surname") %></td>
                                        <td>
                                            <input type="text" name="patSurname" value="<%= PB.surname %>" style="width: 180px;"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("sex") %></td>
                                        <td>
                                            <select id="patSex" name="patSex">
                                                <%
                                                if(PB.sex.equalsIgnoreCase("male"))
                                                {
                                                    out.println("<option selected='true' value='male'>"+langBacking.getLiteral("male")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='male'>"+langBacking.getLiteral("male")+"</option>");
                                                }
                                                if(PB.sex.equalsIgnoreCase("female"))
                                                {
                                                    out.println("<option selected='true' value='female'>"+langBacking.getLiteral("female")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='female'>"+langBacking.getLiteral("female")+"</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right"><%= langBacking.getLiteral("mobile_phone") %></td>
                                        <td>
                                            <input type="text" name="patMobilePhone" value="<%= PB.mobilephone %>" style="width: 180px;"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("other_identifier") %></td>
                                        <td>
                                            <input type="text" name="patOtherIdentifier" value="<%= PB.otherIdentifier %>" style="width: 180px;"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right"><%= langBacking.getLiteral("home_phone") %></td>
                                        <td>
                                            <input type="text" name="patHomePhone" value="<%= PB.homephone %>" style="width: 180px;"/>
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
                                                         <%= PB.name %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("surname") %>:</td>
                                                    <td>
                                                        <%= PB.surname %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("fathers_name") %>:</td>
                                                    <td>
                                                        <%= PB.fathersName %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("date_of_birth") %>:</td>
                                                    <td>
                                                        <%= PB.getBirthDateStr(langBacking.getDateFormat()) %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("sex") %>:</td>
                                                    <td>
                                                        <%= langBacking.getLiteral(PB.sex) %>
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
                                                        <%= PB.getAddressStr() %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                                    <td>
                                                        <%= PB.homephone %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                                    <td>
                                                        <%= PB.workphone %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                                    <td>
                                                        <%= PB.mobilephone %>
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
                                                        <%= PB.getSsn() %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                                    <td>
                                                        <%= PB.insurancename %>
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
                                <%
                                }
                                %>
                            </div>
                        </div>
                        
                        <div class="post" >
                            <h2 class="title"><a href="#"><%= langBacking.getLiteral("efimeries") %></a></h2>
                            <div class="entry">
                                <script id="scriptInit" type="text/javascript">
                                    $(document).ready(function () {
                                    $("#emergencyTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    data: [
                                    <%
                                    for(int i=0; i<examroomsBeans.size(); i++)
                                    {
                                        ExamroomsBean ERB=examroomsBeans.get(i);

                                        if(i<examroomsBeans.size()-1)
                                        {
                                            out.println("['"+ERB.name+"','"+ERB.description+"','"+ERB.modBean.name+" ("+ERB.modBean.manufacturer+")"+"','"+ERB.modBean.comments+"','<input type=\"radio\" name=\"examRoomId\" value=\""+ERB.id+"\"/>'],");
                                        }
                                        else
                                        {
                                            out.println("['"+ERB.name+"','"+ERB.description+"','"+ERB.modBean.name+" ("+ERB.modBean.manufacturer+")"+"','"+ERB.modBean.comments+"','<input type=\"radio\" name=\"examRoomId\" value=\""+ERB.id+"\"/>']");
                                        }
                                    }
                                    %>
                                    ],
                                    columns: [
                                        { headerText: "<%= langBacking.getLiteral("exam_room") %>"}, { headerText: "<%= langBacking.getLiteral("exam_room_description") %>" }, { headerText: "<%= langBacking.getLiteral("modality") %>" }, { headerText: "<%= langBacking.getLiteral("description") %>" }, { headerText: " ", width:"20px"}
                                    ]
                                    });
                                });
                                </script>

                                <table id='emergencyTable'>
                                </table>
                            </div>
                        </div>

                        <div class="post">
                            <h2 class="title"><a href="#"><%= langBacking.getLiteral("emergency_case_information") %></a></h2>
                            <div class="entry">
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("date_time") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("name_surname") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("age") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <%
                                            siteDoctorBacking.newEmergencyCaseBean.caseDate=new Date();
                                            String erDateTime="";
                                            SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy,  HH:mm");
                                            erDateTime = DATE_FORMAT.format(siteDoctorBacking.newEmergencyCaseBean.caseDate);
                                            out.println(erDateTime);
                                            out.println("<input type='hidden' name='erDateTime' value='"+erDateTime+"'/>");
                                            %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= PB.name+" "+PB.surname %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="erAge" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.erAge %>" style="width: 40px;"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("the_patient_came") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("serum") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("other") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <select id="proselefsiSelect" name="erProselefsi">
                                                <%
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.erProselefsi.equalsIgnoreCase(langBacking.getLiteral("alone")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("alone")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("alone")+"</option>");
                                                }
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.erProselefsi.equalsIgnoreCase(langBacking.getLiteral("accompanied")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("accompanied")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("accompanied")+"</option>");
                                                }
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.erProselefsi.equalsIgnoreCase(langBacking.getLiteral("ambulatory_transfer")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("ambulatory_transfer")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("ambulatory_transfer")+"</option>");
                                                }
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.erProselefsi.equalsIgnoreCase(langBacking.getLiteral("patient_transfer")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("patient_transfer")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("patient_transfer")+"</option>");
                                                }
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.erProselefsi.equalsIgnoreCase(langBacking.getLiteral("immobilization")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("immobilization")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("immobilization")+"</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="erOros" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.erOros %>" style="width: 290px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="erAllo" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.erAllo %>" style="width: 290px;"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("patient_history") %></b>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("symptom") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("smoker") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("alergies") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("infectious_diseases") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="text" name="histSymptom" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.histSymptom %>" style="width: 250px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <select id="smokerSelect" name="histSmoker">
                                                <%
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.histSmoker.equalsIgnoreCase(langBacking.getLiteral("yes")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                if(siteDoctorBacking.newEmergencyCaseBean.erRegForm.histSmoker.equalsIgnoreCase(langBacking.getLiteral("no")))
                                                {
                                                    out.println("<option selected='true'>"+langBacking.getLiteral("no")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option>"+langBacking.getLiteral("no")+"</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="histAlergic" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.histAlergic %>" style="width: 200px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="histLoimodi" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.histLoimodi %>" style="width: 200px;"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("trauma") %></b>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("accident") %> 
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.trauma,langBacking.getLiteral("accident")))
                                            {
                                                out.println("<input type='checkbox' name='woundAccident' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='woundAccident'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("beating") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.trauma,langBacking.getLiteral("beating")))
                                            {
                                                out.println("<input type='checkbox' name='woundBitten' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='woundBitten'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("car_accident") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.trauma,langBacking.getLiteral("car_accident")))
                                            {
                                                out.println("<input type='checkbox' name='woundCar' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='woundCar'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("industrial_accident") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.trauma,langBacking.getLiteral("industrial_accident")))
                                            {
                                                out.println("<input type='checkbox' name='woundWork' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='woundWork'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("fall") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.trauma,langBacking.getLiteral("fall")))
                                            {
                                                out.println("<input type='checkbox' name='woundFell' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='woundFell'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("suicide_attempt") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.trauma,langBacking.getLiteral("suicide_attempt")))
                                            {
                                                out.println("<input type='checkbox' name='woundCommitted' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='woundCommitted'/>");
                                            }
                                            %>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("vital_signs") %></b>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("time") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("pulses") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("blood_pressure") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("breaths") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("spo2") %>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            T(*)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="text" name="vitalTime" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.vitalTime %>" style="width: 50px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="vitalPulses" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.vitalPulses %>" style="width: 50px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="vitalAP" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.vitalAP %>" style="width: 50px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="vitalInhale" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.vitalInhale %>" style="width: 50px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="vitalSpo2" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.vitalSpo2 %>" style="width: 50px;"/>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td>
                                            <input type="text" name="vitalT" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.vitalT %>" style="width: 50px;"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("skin") %></b>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("cold") %> 
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("cold")))
                                            {
                                                out.println("<input type='checkbox' name='skinCold' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinCold'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("hot") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("hot")))
                                            {
                                                out.println("<input type='checkbox' name='skinHot' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinHot'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("dry") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("dry")))
                                            {
                                                out.println("<input type='checkbox' name='skinDry' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinDry'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("wet") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("wet")))
                                            {
                                                out.println("<input type='checkbox' name='skinWet' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinWet'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("sallow") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("sallow")))
                                            {
                                                out.println("<input type='checkbox' name='skinOxro' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinOxro'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("cyan") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("cyan")))
                                            {
                                                out.println("<input type='checkbox' name='skinCyan' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinCyan'/>");
                                            }
                                            %>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%= langBacking.getLiteral("jaundiced") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.derma,langBacking.getLiteral("jaundiced")))
                                            {
                                                out.println("<input type='checkbox' name='skinIkteros' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='skinIkteros'/>");
                                            }
                                            %>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <%= langBacking.getLiteral("comment") %> 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%//= langBacking.getLiteral("doctor") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input type="text" name="erComments" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.erComments %>" style="width: 350px;"/> 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td>
                                            <%
//                                            ArrayList<DoctorBean> siteDoctors = siteDoctorBacking.getAllDoctorsBySite();
//                                            out.println("<select name='erDocId' id='erDoctorSelect'>");
//                                            for(DoctorBean docBean : siteDoctors)
//                                            {
//                                                out.println("<option value='123'>"+docBean.name+" "+docBean.surname+" ("+docBean.specialtyBean.nameEl+")"+"</option>");
//                                            }
//                                            out.println("</select>");
                                            %>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("general_semiology") %>:</b>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("fever") %> 
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("fever")))
                                            {
                                                out.println("<input type='checkbox' name='genFever' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genFever'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("shiver") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("shiver")))
                                            {
                                                out.println("<input type='checkbox' name='genRigos' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genRigos'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("cough") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("cough")))
                                            {
                                                out.println("<input type='checkbox' name='genVixas' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genVixas'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("debilitation") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("debilitation")))
                                            {
                                                out.println("<input type='checkbox' name='genKatavoli' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genKatavoli'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("hardship") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("hardship")))
                                            {
                                                out.println("<input type='checkbox' name='genKakouxia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genKakouxia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("nausea") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("nausea")))
                                            {
                                                out.println("<input type='checkbox' name='genNaftia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genNaftia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("dizziness") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("dizziness")))
                                            {
                                                out.println("<input type='checkbox' name='genZali' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genZali'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("dry_mouth") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("dry_mouth")))
                                            {
                                                out.println("<input type='checkbox' name='genKsirostomia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genKsirostomia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                    </tr>
                                    <tr height="15px">
                                        <td align="right">
                                            <%= langBacking.getLiteral("vommit") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("vommit")))
                                            {
                                                out.println("<input type='checkbox' name='genEmetos' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genEmetos'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("eructation") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("eructation")))
                                            {
                                                out.println("<input type='checkbox' name='genEriges' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genEriges'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("disingestion") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("disingestion")))
                                            {
                                                out.println("<input type='checkbox' name='genDiskataposia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genDiskataposia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("dyspepsia") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("dyspepsia")))
                                            {
                                                out.println("<input type='checkbox' name='genDispepsia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genDispepsia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("feeling_fullness") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("feeling_fullness")))
                                            {
                                                out.println("<input type='checkbox' name='genAisthimaPlirotitas' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genAisthimaPlirotitas'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("hematemesis") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("hematemesis")))
                                            {
                                                out.println("<input type='checkbox' name='genAimatemesi' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genAimatemesi'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("melaena") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("melaena")))
                                            {
                                                out.println("<input type='checkbox' name='genMelainaKenosi' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genMelainaKenosi'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("abdominal_pain") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("abdominal_pain")))
                                            {
                                                out.println("<input type='checkbox' name='genKoiliakoAlgos' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genKoiliakoAlgos'/>");
                                            }
                                            %>
                                            
                                        </td>
                                    </tr>
                                    <tr height="15px">
                                        <td align="right">
                                            <%= langBacking.getLiteral("diarrhea") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("diarrhea")))
                                            {
                                                out.println("<input type='checkbox' name='genDiarroia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genDiarroia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("constipation") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("constipation")))
                                            {
                                                out.println("<input type='checkbox' name='genDiskoiliotita' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genDiskoiliotita'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("levitation") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("levitation")))
                                            {
                                                out.println("<input type='checkbox' name='genMeteorismos' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genMeteorismos'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("ascites") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("ascites")))
                                            {
                                                out.println("<input type='checkbox' name='genAskitis' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genAskitis'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("rash") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("rash")))
                                            {
                                                out.println("<input type='checkbox' name='genEksanthima' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genEksanthima'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("itch") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("itch")))
                                            {
                                                out.println("<input type='checkbox' name='genKnismos' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genKnismos'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("edema") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("edema")))
                                            {
                                                out.println("<input type='checkbox' name='genOidima' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genOidima'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("intoxication") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("intoxication")))
                                            {
                                                out.println("<input type='checkbox' name='genMethi' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genMethi'/>");
                                            }
                                            %>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("poisoning") %> 
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("poisoning")))
                                            {
                                                out.println("<input type='checkbox' name='genDilitiriasi' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genDilitiriasi'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("hypertension") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("hypertension")))
                                            {
                                                out.println("<input type='checkbox' name='genYpertasi' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genYpertasi'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("glycemia") %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("glycemia")))
                                            {
                                                out.println("<input type='checkbox' name='genGlykaimia' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genGlykaimia'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            Ηλεκ/κές διαταραχές(*)
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.optionIsContained(siteDoctorBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia,langBacking.getLiteral("Ηλεκ/κές")))
                                            {
                                                out.println("<input type='checkbox' name='genHlektrDiataraxes' checked='true'/>");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='genHlektrDiataraxes'/>");
                                            }
                                            %>
                                            
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("other") %>
                                        </td>
                                        <td colspan="10">
                                            <input type="text" name="genOther" value="<%= siteDoctorBacking.newEmergencyCaseBean.erRegForm.genOther %>" style="width:250px;"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("surgical_semiology") %></b>
                                <table border="0">
                                    <tr>
                                        <td width="50%" valign="top">
                                            <table>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("pain") %> 
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgAlgos"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("edema") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgOidima"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("injury") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgKakosi"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("bite") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgDigma"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("fracture") %> 
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgKatagma"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("sores_ulcer") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgKatakliseis"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("open_fracture") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgAnoiktoKatagma"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("abscess") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgApostima"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("crush") %> 
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgSinthlipsi"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("furuncle") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgDothiinas"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("amputation") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgAkrotiriasmos"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("hematoma") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgAimatoma"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("airy") %> 
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgDiamperes"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("rash") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgEksanthima"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("diatitainon") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgDiatitainon"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("burn") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgEgkavma"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("shreding") %> 
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgKatatemaxismos"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("receding") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgThlastiko"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("excoriation") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgEkdora"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("deformation") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgParamorfosi"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("mobility") %> 
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgKinitikotita"/>
                                                    </td>
                                                    <td>&nbsp;&nbsp;</td>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("pulses") %>
                                                    </td>
                                                    <td>
                                                        <input type="checkbox" name="surgSfikseis"/>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td valign="top">
                                            <table border="0" >
                                                <tr>
                                                    <td>
<!--                                                        <img src="../images/hand.jpg" width="100px"/>-->
                                                    </td>
                                                    <td rowspan="4">
<!--                                                            mpros-->
                                                    </td>
                                                    <td rowspan="4">
<!--                                                        <img src="../images/body.jpg" width="250px"/>-->
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
<!--                                                        <img src="../images/head.gif" width="100px"/>-->
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("neurologic_semiology") %>:</b>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("headache") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroKefalalgia"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("quadriplegia") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroTetrapligia"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("dysarthria") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroDysarthria"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("paraplegia") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroParapligia"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("formicary") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroAimodies"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("convulsions") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSpasmoi"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("visual_disturbance") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroOptikiDiataraxi"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("speech_disorder") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroDiataraxiOmilias"/>
                                        </td>
                                    </tr>
                                </table>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("paresis") %>: 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("left") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroParesiAristera"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("right") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroParesiDeksia"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("hemiplegia") %> : 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("left") %>  
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroHmipligiaAristera"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("right") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroHmipligiaDeksia"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("neurosurgery_semiology") %> :</b>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("loss_consciousness") %> : 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("transient") %>  
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergParodiki"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("lethargy") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergLithargos"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("light_coma") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergLightKoma"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("deep_coma") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergDeepKoma"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("open_eyes") %> : 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("none") %>  
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergOpenEyesOuden"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("pain") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergAlgos"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("oral_pain") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergProforikoAlgos"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("spontaneously") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergOpenEyesAuthormita"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("best_oral_answer") %> : 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("none") %>  
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergOralOuden"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("aloof_sounds") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergSounds"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("incongruous_words") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergWords"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("confounding") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergSygxitiki"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("directed") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergProsanatolismeni"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("best_cinetic_response") %> : 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("none") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergCineticOuden"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("extend_in_pain") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergEktasiAlgos"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("bending_in_pain") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergKampsiAlgos"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("impression_of_pain") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergEntyposiAlgous"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("obedience_to_order") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergYpakoi"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("spontaneously") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="neuroSergCineticAfthormita"/>
                                        </td>
                                    </tr>
                                </table>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("iris_size") %>: 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("left") %> 
                                        </td>
                                        <td>
                                            <input type="text" name="neuroSergKoresMegethosAristero" style="width: 20px;"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("right") %>
                                        </td>
                                        <td>
                                            <input type="text" name="neuroSergKoresMegethosDeksi" style="width: 20px;"/>
                                        </td>
                                        <td rowspan="2">&nbsp;&nbsp;</td>
                                        <td align="center" rowspan="3">
                                            <img src="../images/kores/2mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/3mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/4mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/5mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/6mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/7mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/8mm.png"/>
                                            &nbsp;
                                            <img src="../images/kores/9mm.png"/>


<!--                                                <img src="../images/kores.jpg" width="80%"/>-->
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("iris_reaction") %>: 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("left") %>
                                        </td>
                                        <td>
                                            <input type="text" name="neuroSergKoresAntidrasiAristero" style="width: 20px;"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("right") %>
                                        </td>
                                        <td>
                                            <input type="text" name="neuroSergKoresAntidrasiDeksi" style="width: 20px;"/>
                                        </td>
                                    </tr>
                                </table>
                                <table>        
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("total_points") %>:
                                        </td>
                                        <td align="left" colspan="5">
                                            <input type="text" name="neuroSergSynoloVathmwn" style="width: 50px;"/>
                                        </td>
                                    </tr>
                                </table>        
                                <br/>
                                <b><%= langBacking.getLiteral("cardiorespiratory_semiology") %>:</b>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("chest_pain") %>: 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("retrosternal") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioOpisthosterniko"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("epigastric") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioEpigastric"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("back") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioBack"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("ruff") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioRuff"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("mandible") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioKatoGnatho"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("maxillary") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioAnoGnatho"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <i><%= langBacking.getLiteral("character") %>: </i>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("pressure") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioPiesi"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("strangulation") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioPniksimo"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("tightening") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioSfiksimo"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("weight") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioVaros"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("burning") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioKafsos"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <i><%= langBacking.getLiteral("commencement") %>: </i>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("stress") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioStress"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("after_eating") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioEating"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("tranquility") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioHremia"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <i><%= langBacking.getLiteral("duration") %>: </i>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("20_to_30_min") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardio20_30"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("gt_of_20_min") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioGreaterOf20"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("hours") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioOres"/>
                                        </td>
                                    </tr>
                                </table>
                                <table>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("palpirations") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioAisthimaPalmwn"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("leg_swelling") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioOidimaKatwAkrwn"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("breathlessness") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioDispnoia"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("haemoptysis") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioAimoptisi"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("repeated_crises_fainting") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioSygkrotikesLipothimia"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("cyanosis") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioKyanosi"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("pleftodynia") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioPleftodynia"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("cough") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="cardioVixas"/>
                                        </td>
                                    </tr>
                                </table>
                                <br/>
                                <b><%= langBacking.getLiteral("psychiatric_semiology") %>:</b>
                                <table border="0">
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("mood") %>: 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("anxious") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoAgxodeis"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("depression") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoKatathlipsi"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("behavior") %>:
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("aggressive") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoEpithetikos"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("stimulating") %> 
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoDiegertikos"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("thoughts") %> : 
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("hallucinations") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoParaisthiseis"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("delirium") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoParalirima"/>
                                        </td>
                                        <td>&nbsp;&nbsp;</td>
                                        <td align="right">
                                            <%= langBacking.getLiteral("confusion") %>
                                        </td>
                                        <td>
                                            <input type="checkbox" name="psychoSygxisi"/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>

                        <center>
                            <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkEmergencyForm();"/>
                        </center>
                    </form>
                    <%
                    }
                    else
                    {
                        //out.println("No patient selected!");
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
                            </ul>
                        </li>
                    </ul>
                </div>
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

$("#patSex").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

});
</script>
    
</html>