<%@page import="java.util.Date"%>
<%@page import="tools.DBManager"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.ConsultantBean"%>
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
//retrieve objects from session (if necessary)
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
function confirmAccountDelete(accountID)
{
    var r=confirm("Account (ID:"+accountID+") will be permanately deleted.\n\nDo you wish to proceed?");
    if (r==true)
    {
//        window.location="actions/delete_account_action.jsp?accId="+accountID;
    }
    else
    {
        //alert("You pressed Cancel!");
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
                    %>
                    
                    
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("accounts") %></a></h2>
                        <div class="entry">
                            <%
                            //retrieve all accounts
                            ArrayList<accountBean> accountsList=hqAdminBacking.getAllAccounts();
                            if(accountsList!=null && accountsList.size()>0)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#accountsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 15,
                                    allowColSizing: true,
                                    data: [
                            <%
                                for(int i=0; i<accountsList.size(); i++)
                                {
                                    accountBean curAccount=accountsList.get(i);
                                    
                                    String simeio = "";
                                    if(curAccount.RB.roleName.equalsIgnoreCase("consultant"))
                                    {
                                        ConsultantBean consultantBean = hqAdminBacking.getConsultantByAccountId(curAccount.id);
                                        if(consultantBean!=null)
                                        {
                                            for(StisBean siteBean : consultantBean.getStisList())
                                            {
                                                simeio+=siteBean.getTitle()+" ("+siteBean.getNosokomeio()+")<br/>";
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if(curAccount.SB!=null)
                                        {
                                            simeio = curAccount.SB.name;
                                        }
                                    }
                                    
                                    String contactContent="";
                                    String roleFurtherInfo="";
                                    if(curAccount.RB!=null && curAccount.RB.roleName.equalsIgnoreCase("consultant") && curAccount.consultantBean!=null)
                                    {
                                        roleFurtherInfo="("+curAccount.consultantBean.getSpecialtyBean().getNameEl()+")";
                                        contactContent="<table >";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/mobile-phone-icon3.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.consultantBean.getMobilePhone()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/work-phone-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.consultantBean.getWorkphone()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/telephone-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.consultantBean.getHomephone()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/email-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.consultantBean.getEmail()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/videoConf.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getSipConference()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/play.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getSipMedical()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/jabber-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getJabberAccount()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                        contactContent+="</table>";
                                    }
                                    
                                    String actionsHrefs="";
                                    if(curAccount.RB!=null && curAccount.RB.roleName.equalsIgnoreCase("consultant")==true)
                                    {
                                        actionsHrefs="<a href=\"editConsultantAccount.jsp?accId="+curAccount.id+"\"><img src=\"../images/edit2.png\"/></a>&nbsp;&nbsp;";
                                    }
                                    else if(curAccount.RB!=null && curAccount.RB.roleName.equalsIgnoreCase("siteadmin")==true)
                                    {
                                        actionsHrefs="<a href=\"editLocalAdminAccount.jsp?accId="+curAccount.id+"\"><img src=\"../images/edit2.png\"/></a>&nbsp;&nbsp;";
                                    }
                                    else if(curAccount.RB!=null && (curAccount.RB.roleName.equalsIgnoreCase("manager")==true || curAccount.RB.roleName.equalsIgnoreCase("counterdesk")==true || curAccount.RB.roleName.equalsIgnoreCase("hqadmin")==true))
                                    {
                                        actionsHrefs="<a href=\"editAccount.jsp?accId="+curAccount.id+"\"><img src=\"../images/edit2.png\"/></a>&nbsp;&nbsp;";
                                    }
                                    
                                    String usernameContent="<table width=\"100%\"><tr><td style=\"border-style:hidden;\">"+curAccount.username+"</td></tr>";
                                    if(curAccount.getByPassAd()!=null && curAccount.getByPassAd().equalsIgnoreCase("false"))
                                    {
                                        usernameContent+="<tr><td style=\"border-style:hidden;\" align=\"right\"><img src=\"../images/activeDirectoryIcon.png\" width=\"35px\" title=\"Active Directory Login\"/></td></tr>";
                                    }
                                    usernameContent+="</table>";
                                    
                                    
                                    if(i<accountsList.size()-1)
                                    {
                                        out.println("['"+curAccount.name+"<br/>"+curAccount.surname+"', '"+usernameContent+"', '"+langBacking.getLiteral(curAccount.RB.roleName)+"<br/>"+roleFurtherInfo+"', '"+simeio+"', '"+contactContent+"','"+actionsHrefs+"'],");
                                    }
                                    else
                                    {
                                        out.println("['"+curAccount.name+"<br/>"+curAccount.surname+"', '"+usernameContent+"', '"+langBacking.getLiteral(curAccount.RB.roleName)+"<br/>"+roleFurtherInfo+"', '"+simeio+"', '"+contactContent+"','"+actionsHrefs+"']");
                                    }
                                }
                            %>
                            ],
                            columns: [
                                { headerText: "<%= langBacking.getLiteral("name_surname") %>" }, { headerText: "<%= langBacking.getLiteral("username") %>" }, { headerText: "<%= langBacking.getLiteral("role") %>" }, { headerText: "<%= langBacking.getLiteral("stis") %>" }, { headerText: "<%= langBacking.getLiteral("contact") %>" }, { headerText: " ", width:60}
                            ]
                            });
                        });
                        </script>
                            <%
                                out.println("<table id='accountsTable'>");
                                out.println("</table>");
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("no_accounts_found"));
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
                                <li><a href="newLocalAdminAccount.jsp"><%= langBacking.getLiteral("add_local_admin_account") %></a></li>
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
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();
});


</script>
    
</html>