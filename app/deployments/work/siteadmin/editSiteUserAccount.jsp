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
    document.getElementById("addAccountForm").submit();
}
function checkDeleteAccountForm()
{
    document.getElementById("deleteAccountForm").submit();
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
                    
                    
                    
                    String accId=request.getParameter("accId");
                    if(accId!=null && accId.length()>0)
                    {
                        siteAdminBacking.accountToEdit=siteAdminBacking.getAccountById(accId);
                    }
                    %>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("edit_account") %></a></h2>
                        <div class="entry">
                            <%
                            if(siteAdminBacking.accountToEdit!=null)
                            {
                            %>
                            <form id="addAccountForm" method="post" action="actions/edit_account_action.jsp">
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
                                            <%= siteAdminBacking.accountToEdit.username %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <%
                                        String passFontColor="black";
                                        if(siteAdminBacking.accountToEdit.getByPassAd().equalsIgnoreCase("true"))
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
                                            if(siteAdminBacking.accountToEdit.getByPassAd().equalsIgnoreCase("true"))
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
                                                if(siteAdminBacking.accountToEdit.active.equalsIgnoreCase("yes"))
                                                {
                                                    out.println("<option selected='true' value='yes'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value='yes'>"+langBacking.getLiteral("yes")+"</option>");
                                                }
                                                if(siteAdminBacking.accountToEdit.active.equalsIgnoreCase("no"))
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
                                            <%
                                            if(siteAdminBacking.accountToEdit.getByPassAd().equalsIgnoreCase("true"))
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
                                            <input name="accName" value="<%= siteAdminBacking.accountToEdit.name %>" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <font color="red">
                                                <%= langBacking.getLiteral("surname") %>:
                                            </font>
                                        </td>
                                        <td>
                                            <input name="accSurname" value="<%= siteAdminBacking.accountToEdit.surname %>" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("email") %>:</td>
                                        <td>
                                            <input name="accEmail" value="<%= siteAdminBacking.accountToEdit.email %>" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                        <td>
                                            <input name="accMobilePhone" value="<%= siteAdminBacking.accountToEdit.mobilePhone %>" id="textbox" type="text" size="25"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("other_information") %>:</td>
                                        <td>
                                            <textarea name="accOtherInfo" id="area" rows="3" cols="40"><%= siteAdminBacking.accountToEdit.otherInfo %></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkNewAccountForm();"/>
                                        </td>
                                        <td align="right">
                                            <input type="button" value="<%= langBacking.getLiteral("delete_account") %>" onClick="javascript:checkDeleteAccountForm();"/>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <form id="deleteAccountForm" method="post" action="actions/delete_account_action.jsp">
                            </form>
                            <%
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
                                <li><a href="localAccounts.jsp"><%= langBacking.getLiteral("all_accounts") %></a></li>
                                <li><a href="newAccount.jsp"><%= langBacking.getLiteral("add_account") %></a></li>
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
});

$("#roleSelect").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#siteSelect").wijcombobox({
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