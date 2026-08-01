<%@page import="beans.SpecialtyBean"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.roleBean"%>
<%@page import="backings.HqAdminBacking"%>
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
HqAdminBacking hqAdminBacking = (HqAdminBacking)session.getAttribute("hqAdminBacking");
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
    if(document.getElementById("accByPassAd").checked === true)
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
            <% request.setAttribute("target", "accounts"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    <%
                    if(hqAdminBacking!=null && hqAdminBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(hqAdminBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(hqAdminBacking!=null && hqAdminBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(hqAdminBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(hqAdminBacking!=null && hqAdminBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(hqAdminBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    hqAdminBacking.resetMessages();
                    
                    String accId = request.getParameter("accId");
                    if(accId!=null && accId.length()>0)
                    {
                        hqAdminBacking.setSelectedConsultantAccountToEdit(hqAdminBacking.getAccountById(accId));
                    }
                    %>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("edit_consultant_account") %></a></h2>
                        <div class="entry">
                            <%
                            if(hqAdminBacking.getSelectedConsultantAccountToEdit()!=null)
                            {
                            %>
                            <form id="addConsultantAccountForm" method="post" action="actions/edit_consultant_account_action.jsp" enctype="multipart/form-data">
                                <table border="0">
                                    <tr>
                                        <td colspan="4">
                                            <b><i><%= langBacking.getLiteral("account_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("username") %>:
                                        </td>
                                        <td>
                                            <%= hqAdminBacking.getSelectedConsultantAccountToEdit().username %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <%
                                        String passFontColor="black";
                                        if(hqAdminBacking.getSelectedConsultantAccountToEdit().getByPassAd().equalsIgnoreCase("true"))
                                        {
                                            passFontColor="red";
                                        }
                                        %>
                                        <td align="right">
                                            <font id="passFontId" color="<%=passFontColor%>">
                                                <%= langBacking.getLiteral("password") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <%
                                            if(hqAdminBacking.getSelectedConsultantAccountToEdit().getByPassAd().equalsIgnoreCase("true"))
                                            {
                                                out.println("<input name='accPassword' value='' id='passTextbox' type='password' size='25'/>");
                                            }
                                            else
                                            {
                                                out.println("<input disabled name='accPassword' value='' id='passTextbox' type='password' size='25'/>");
                                            }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("active_account") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <select id="activeSelect" name="accActive">
                                                <%
                                                if(hqAdminBacking.getSelectedConsultantAccountToEdit().active.equalsIgnoreCase("yes"))
                                                {
                                                    out.println("<option selected='true' value='yes'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='yes'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                if(hqAdminBacking.getSelectedConsultantAccountToEdit().active.equalsIgnoreCase("no"))
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
                                                <%= langBacking.getLiteral("role") %>:
                                        </td>
                                        <td>
                                            <%= langBacking.getLiteral("consultant") %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("by_pass_ad") %>
                                        </td>
                                        <td>
                                            <%
                                            if(hqAdminBacking.getSelectedConsultantAccountToEdit().getByPassAd().equalsIgnoreCase("true"))
                                            {
                                                out.println("<input checked type='checkbox' name='accByPassAd' id='accByPassAd' onchange='changePasswordTextbox();' />");
                                            }
                                            else
                                            {
                                                out.println("<input type='checkbox' name='accByPassAd' id='accByPassAd' onchange='changePasswordTextbox();' />");
                                            }
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/><b><i><%= langBacking.getLiteral("personal_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("name") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="accName" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().name %>" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("surname") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="accSurname" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().surname %>" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("photo") %>:
                                        </td>
                                        <td>
                                            <input type="file" name="accPhoto"  />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <%= langBacking.getLiteral("short_cv") %>:
                                        </td>
                                        <td>
                                            <textarea name="consShortCv" cols="45" rows="8"><%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getShortCv() %></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">
                                            <br/><b><i><%= langBacking.getLiteral("medical_information") %></i></b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("stis") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <%
                                            ArrayList<StisBean> stisList=hqAdminBacking.getAllStis();
                                            for(StisBean curStis : stisList)
                                            {
                                                boolean sameStis=false;
                                                for(StisBean consStis : hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getStisList())
                                                {
                                                    if(consStis.getId().equals(curStis.getId()))
                                                    {
                                                        sameStis=true;
                                                        break;
                                                    }
                                                }
                                                if(sameStis==true)
                                                {
                                                    out.println("<input checked type='checkbox' name='stis#"+curStis.getId()+"' /> "+curStis.getTitle()+" ("+curStis.getNosokomeio()+")<br/>");//checked='true'
                                                }
                                                else
                                                {
                                                    out.println("<input type='checkbox' name='stis#"+curStis.getId()+"' /> "+curStis.getTitle()+" ("+curStis.getNosokomeio()+")<br/>");//checked='true'
                                                }
                                            }
                                            %>
                                            
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("specialty") %></font></td>
                                        <td>
                                            <%
                                            ArrayList<SpecialtyBean> allSpecialties = hqAdminBacking.getAllSpecialties(langBacking.lang);
                                            out.println("<select id='specialtySelectId' name='consSpecialtyId'>");
                                            for(SpecialtyBean curSpec : allSpecialties)
                                            {
                                                String specName = "";
                                                if(langBacking.lang.equalsIgnoreCase("greek"))
                                                {
                                                    specName=curSpec.nameEl;
                                                }
                                                else if(langBacking.lang.equalsIgnoreCase("english"))
                                                {
                                                    specName=curSpec.nameEn;
                                                }
                                                
                                                if(hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getSpecialtyBean().getId().equals(curSpec.getId()))
                                                {
                                                    out.println("<option selected value='"+curSpec.id+"'>"+specName+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='"+curSpec.id+"'>"+specName+"</option>");
                                                }
                                            }
                                            out.println("</select>");
                                            %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><font color="red"><%= langBacking.getLiteral("mitroo") %></font></td>
                                        <td>
                                            <input type="text" name="consMitroo" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getMitroo() %>" size="25"/>
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
                                            <input type="text" name="consSipConference" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().getSipConference() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("sip_medical_number") %></td>
                                        <td>
                                            <input type="text" name="consSipMedical" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().getSipMedical() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("jabber_account") %></td>
                                        <td>
                                            <input type="text" name="consJabberAccount" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().getJabberAccount() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("mobile_phone") %></td>
                                        <td>
                                            <input type="text" name="consMobilePhone" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getMobilePhone() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("work_phone") %></td>
                                        <td>
                                            <input type="text" name="consWorkPhone" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getWorkphone() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("home_phone") %></td>
                                        <td>
                                            <input type="text" name="consHomePhone" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getHomephone() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("address") %></td>
                                        <td>
                                            <input type="text" name="consAddress" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getAddress() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("email") %></td>
                                        <td>
                                            <input type="email" name="consEmail" value="<%= hqAdminBacking.getSelectedConsultantAccountToEdit().consultantBean.getEmail() %>" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            <input type="submit" value="<%= langBacking.getLiteral("save") %>" />
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_consultant_account_selected"));
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
                                <li><a href="accounts.jsp"><%= langBacking.getLiteral("all_accounts") %></a></li>
                                <li><a href="newAccount.jsp"><%= langBacking.getLiteral("add_account") %></a></li>
                                <li><a href="newConsultantAccount.jsp"><%= langBacking.getLiteral("add_consultant_account") %></a></li>
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
$(":input[type='text'],:input[type='password'],:input[type='email'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button'],:input[type='submit']").button();
});

$("#specialtySelectId").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: true,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#roleSelect").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
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