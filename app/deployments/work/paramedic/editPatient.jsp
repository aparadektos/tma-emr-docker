<%@page import="backings.ParamedicBacking"%>
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
function checkEditPatientForm()
{
    document.getElementById("editPatientForm").submit();
}
function checkDeletePatientForm()
{
    if(confirm("<%= langBacking.getLiteral("delete_patient_confirm") %>"))
    {
        document.getElementById("deletePatientForm").submit();
    }
}
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
                        <h2 class="title"> <a href="#"><%= langBacking.getLiteral("edit_patient") %></a> </h2>
                        <div class="entry">
                            <%
                            patBean PB = null;
                            String patId=request.getParameter("patId");
                            if(patId!=null && patId.trim().length()>0)
                            {
                                PB = paramedicBacking.getPatientById(patId.trim());
                            }
                            if(PB!=null)
                            {
                            %>
                            
                            <form id="deletePatientForm" method="post" action="actions/delete_patient_action.jsp">
                                <input type="hidden" name="patId" value="<%= PB.id %>"/>
                            </form>
                            
                            <form id="editPatientForm" method="post" action="actions/edit_patient_action.jsp">
                                <input type="hidden" name="patId" value="<%= PB.id %>"/>
                                <table border="0">
                                    <tr>
                                        <td colspan="2">
                                            <b><i><%= langBacking.getLiteral("patient_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("name") %>:</font></td>
                                        <td>
                                            <input name="patName" id="textbox" type="text" size="53" value="<%= PB.name %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("surname") %>:</font></td>
                                        <td>
                                            <input name="patSurname" id="textbox" type="text" size="53" value="<%= PB.surname %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("fathers_name") %>:</font></td>
                                        <td>
                                            <input name="patFathersName" id="textbox" type="text" size="53" value="<%= PB.fathersName %>"/>
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
                                                                if(PB.birthDate!=null && PB.birthDate.getMonth()+1==i)
                                                                {
                                                                    out.println("<option selected='true' value='"+i+"'>"+i+"</option>");
                                                                }
                                                                else
                                                                {
                                                                    out.println("<option value='"+i+"'>"+i+"</option>");
                                                                }
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
                                                                if(PB.birthDate!=null && PB.birthDate.getDate()==i)
                                                                {
                                                                    out.println("<option selected='true' value='"+i+"'>"+i+"</option>");
                                                                }
                                                                else
                                                                {
                                                                    out.println("<option value='"+i+"'>"+i+"</option>");
                                                                }
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
                                                                if(PB.birthDate!=null && (PB.birthDate.getYear()+1900)==i)
                                                                {
                                                                    out.println("<option selected='true' value='"+i+"'>"+i+"</option>");
                                                                }
                                                                else
                                                                {
                                                                    out.println("<option value='"+i+"'>"+i+"</option>");
                                                                }
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
                                                                    if(PB.birthDate!=null && PB.birthDate.getDate()==i)
                                                                    {
                                                                        out.println("<option selected='true' value='"+i+"'>"+i+"</option>");
                                                                    }
                                                                    else
                                                                    {
                                                                        out.println("<option value='"+i+"'>"+i+"</option>");
                                                                    }
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
                                                                    if(PB.birthDate!=null && PB.birthDate.getMonth()+1==i)
                                                                    {
                                                                        out.println("<option selected='true' value='"+i+"'>"+i+"</option>");
                                                                    }
                                                                    else
                                                                    {
                                                                        out.println("<option value='"+i+"'>"+i+"</option>");
                                                                    }
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
                                                                    if(PB.birthDate!=null && (PB.birthDate.getYear()+1900)==i)
                                                                    {
                                                                        out.println("<option selected='true' value='"+i+"'>"+i+"</option>");
                                                                    }
                                                                    else
                                                                    {
                                                                        out.println("<option value='"+i+"'>"+i+"</option>");
                                                                    }
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
                                            <%
                                            if(PB.sex.equalsIgnoreCase("male"))
                                            {
                                                out.println("<input checked='true' name='patSex' value='male' type='radio'/>"+langBacking.getLiteral("male"));
                                            }
                                            else
                                            {
                                                out.println("<input name='patSex' value='male' type='radio'/>"+langBacking.getLiteral("male"));
                                            }
                                            if(PB.sex.equalsIgnoreCase("female"))
                                            {
                                                out.println("<input checked='true' name='patSex' value='female' type='radio'/>"+langBacking.getLiteral("female"));
                                            }
                                            else
                                            {
                                                out.println("<input name='patSex' value='female' type='radio'/>"+langBacking.getLiteral("female"));
                                            }
                                            %>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td colspan="2">
                                            <br/>
                                            <b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                        <td>
                                            <input name="patHomePhone" id="textbox" type="text" size="53" value="<%= PB.homephone %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                        <td>
                                            <input name="patWorkPhone" id="textbox" type="text" size="53" value="<%= PB.workphone %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                        <td>
                                            <input name="patMobilePhone" id="textbox" type="text" size="53" value="<%= PB.mobilephone %>"/>
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
                                            <font color="#FF7F00">
                                                <%= langBacking.getLiteral("social_security_number") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="patSSN" id="textbox" type="text" size="53" value="<%= PB.getSsn() %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                        <td>
                                            <input name="patInsuranceName" id="textbox" type="text" size="53" value="<%= PB.insurancename %>"/>
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
                                            <font color="#FF7F00">
                                                <%= langBacking.getLiteral("other_identifier") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="patOtherIdentifier" id="textbox" type="text" size="53" value="<%= PB.otherIdentifier %>"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4" align="center">
                                            <br/>
                                            <input type="button" value="<%= langBacking.getLiteral("save_changes") %>" onClick="javascript:checkEditPatientForm();"/>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <%
                            }
                            else
                            {
                                out.println("No valid patient selected!");
                            }
                            %>
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
    
<script type="text/javascript">
$(document).ready(function () {
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();

$("#durationSelector").wijdropdown();

$("#dayObPicker").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#monthObPicker").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#yearObPicker").wijcombobox({
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