<%@page import="beans.ParamedicTypeBean"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="beans.roleBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.siteBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
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
function checkNewAccountForm()
{
    //alert("test");
    document.getElementById("addAccountForm").submit();
}
function changePasswordTextbox()
{
    if(document.getElementById("byPassAd").checked === true)
    {
        document.getElementById("passTextbox").disabled=false;
        document.getElementById("passFontId").style.color = "red";
    }
    else
    {
        document.getElementById("passTextbox").value="";
        document.getElementById("passTextbox").disabled=true;
        document.getElementById("passFontId").style.color = "black";
    }
}
</script>
    
    <body>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "localAccounts"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    <%
                    if(siteAdminBacking!=null && siteAdminBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteAdminBacking!=null && siteAdminBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteAdminBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteAdminBacking.resetMessages();
                    %>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("add_paramedic_account") %></a></h2>
                        <div class="entry">
                            
                            <form id="newParamedicForm" method="post" action="actions/add_paramedic_action.jsp" enctype="multipart/form-data">
                                <table border="0">
                                    <tr>
                                        <td colspan="4">
                                            <b><i><%= langBacking.getLiteral("account_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("username") %>
                                            </font>
                                        </td>
                                        <td>
                                            <input name="username" value="" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font id="passFontId" color="black">
                                                <%= langBacking.getLiteral("password") %>
                                            </font>
                                        </td>
                                        <td>
                                            <input disabled name="password" value="" id="passTextbox" type="password" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("active_account") %>
                                            </font>
                                        </td>
                                        <td>
                                            <select id="activeSelect" name="active">
                                                <%
                                                if(siteAdminBacking.newAccountBean.active.equalsIgnoreCase("yes"))
                                                {
                                                    out.println("<option selected='true' value='yes'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='yes'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                if(siteAdminBacking.newAccountBean.active.equalsIgnoreCase("no"))
                                                {
                                                    out.println("<option selected='true' value='no'>"+langBacking.getLiteral("no")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='no'>"+langBacking.getLiteral("no")+"</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("by_pass_ad") %>
                                        </td>
                                        <td>
                                            <input type='checkbox' name='byPassAd' id='byPassAd' onchange="changePasswordTextbox();" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br/><b><i><%= langBacking.getLiteral("personal_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("name") %></font></td>
                                        <td>
                                            <input type="text" name="name" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("surname") %></font></td>
                                        <td>
                                            <input type="text" name="surname" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("photo") %>:
                                        </td>
                                        <td>
                                            <input type="file" name="photo"  />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br/><b><i><%= langBacking.getLiteral("medical_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("specialty") %></font></td>
                                        <td>
                                            <%
                                            ArrayList<ParamedicTypeBean> allParamTypes = siteAdminBacking.getAllParamedicTypes(langBacking.lang);
                                            out.println("<select id='paramTypeId' name='paramTypeId'>");
                                            for(ParamedicTypeBean curType : allParamTypes)
                                            {
                                                String typeName = curType.getNameByLang(langBacking.lang);
                                                out.println("<option value='"+curType.getId()+"'>"+typeName+"</option>");
                                            }
                                            out.println("</select>");
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("mitroo") %></font></td>
                                        <td>
                                            <input type="text" name="mitroo" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("short_cv") %>:
                                        </td>
                                        <td>
                                            <textarea name="shortCv" cols="45" rows="8"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <br/><b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("sip_conference_number") %></td>
                                        <td>
                                            <input type="text" name="sipConference" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("sip_medical_number") %></td>
                                        <td>
                                            <input type="text" name="sipMedical" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("jabber_account") %></td>
                                        <td>
                                            <input type="text" name="jabberAccount" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("mobile_phone") %></td>
                                        <td>
                                            <input type="text" name="mobilePhone" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("work_phone") %></td>
                                        <td>
                                            <input type="text" name="workPhone" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("home_phone") %></td>
                                        <td>
                                            <input type="text" name="homePhone" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("address") %></td>
                                        <td>
                                            <input type="text" name="address" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("email") %></td>
                                        <td>
                                            <input type="text" name="email" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("department") %></td>
                                        <td>
                                            <input type="text" name="department" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" align="center">
                                            <input type="submit" value="<%= langBacking.getLiteral("save") %>"/>
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
                                <li><a href="localAccounts.jsp"><%= langBacking.getLiteral("all_local_accounts") %></a></li>
                                <li><a href="newSiteUserAccount.jsp"><%= langBacking.getLiteral("add_site_user_account") %></a></li>
                                <li><a href="newSiteDoctorAccount.jsp"><%= langBacking.getLiteral("add_site_doctor_account") %></a></li>
                                <li><a href="newParamedicAccount.jsp"><%= langBacking.getLiteral("add_paramedic_account") %></a></li>
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
$(":input[type='button'],:input[type='submit']").button();
});

$("#paramTypeId").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: true,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#activeSelect").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});



</script>
    
</html>