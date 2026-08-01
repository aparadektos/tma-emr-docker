<%@page import="backings.SiteAdminBacking"%>
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
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("accounts") %></a></h2>
                        <div class="entry">
                            <%
                            //retrieve all accounts
                            ArrayList<accountBean> accountsList=siteAdminBacking.getAllAccountsBySite();
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
                                    String editUrl="";
                                    String roleText=langBacking.getLiteral(curAccount.RB.roleName);
                                    String locationText=curAccount.SB.name;
                                    String contactContent=curAccount.mobilePhone+"<br/>"+curAccount.email;
                                    
                                    String docMitroo="";
                                    if(curAccount.RB.roleName.equalsIgnoreCase("siteadmin") || curAccount.RB.roleName.equalsIgnoreCase("hqadmin"))
                                    {
                                        editUrl="&nbsp;";
                                    }
                                    else if(curAccount.RB.roleName.equalsIgnoreCase("sitedoctor") && curAccount.docBean!=null)
                                    {
                                        docMitroo="<br/>("+curAccount.docBean.mitroo+")";
                                        contactContent=curAccount.docBean.mobilePhone+"<br/>"+curAccount.docBean.workphone+"<br/>"+curAccount.docBean.address+"<br/>"+curAccount.docBean.email;
                                        contactContent="<table >";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/mobile-phone-icon3.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.docBean.mobilePhone+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/work-phone-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.docBean.workphone+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/telephone-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.docBean.homephone+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/email-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.docBean.email+"<br/>";
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
                                        
                                        
                                        locationText+="<br/>"+curAccount.docBean.department;
                                        if(langBacking.lang.equalsIgnoreCase("greek"))
                                        {
                                            roleText+="<br/>("+curAccount.docBean.specialtyBean.nameEl+")";
                                        }
                                        else if(langBacking.lang.equalsIgnoreCase("english"))
                                        {
                                            roleText+="<br/>("+curAccount.docBean.specialtyBean.nameEn+")";
                                        }
                                        editUrl="<a href=\"editSiteDoctorAccount.jsp?accId="+curAccount.id+"\"><img src=\"../images/edit2.png\"/></a>";
                                    }
                                    else if(curAccount.RB.roleName.equalsIgnoreCase("paramedic") && curAccount.getParamedicBean()!=null)
                                    {
                                        docMitroo="<br/>("+curAccount.getParamedicBean().getMitroo()+")";
                                        contactContent=curAccount.getParamedicBean().getMobilePhone()+"<br/>"+curAccount.getParamedicBean().getWorkphone()+"<br/>"+curAccount.getParamedicBean().getAddress()+"<br/>"+curAccount.getParamedicBean().getEmail();
                                        contactContent="<table >";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/mobile-phone-icon3.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getParamedicBean().getMobilePhone()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/work-phone-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getParamedicBean().getWorkphone()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/telephone-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getParamedicBean().getHomephone()+"<br/>";
                                                contactContent+="</td>";
                                            contactContent+="</tr>";
                                            contactContent+="<tr>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+="<img src=\"../images/email-icon.png\" width=\"20px\"/>";
                                                contactContent+="</td>";
                                                contactContent+="<td style=\"border: 0;\">";
                                                    contactContent+=curAccount.getParamedicBean().getEmail()+"<br/>";
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
                                        
                                        locationText+="<br/>"+curAccount.getParamedicBean().getDepartment();
                                        roleText+="<br/>("+curAccount.getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")";
                                        editUrl="<a href=\"editParamedicAccount.jsp?accId="+curAccount.id+"\"><img src=\"../images/edit2.png\"/></a>";
                                    }
                                    else if(curAccount.RB.roleName.equalsIgnoreCase("siteuser"))
                                    {
                                        editUrl="<a href=\"editSiteUserAccount.jsp?accId="+curAccount.id+"\"><img src=\"../images/edit2.png\"/></a>";
                                    }
                                    
                                    String usernameContent="<table width=\"100%\"><tr><td style=\"border-style:hidden;\">"+curAccount.username+"</td></tr>";
                                    if(curAccount.getByPassAd()!=null && curAccount.getByPassAd().equalsIgnoreCase("false"))
                                    {
                                        usernameContent+="<tr><td style=\"border-style:hidden;\" align=\"right\"><img src=\"../images/activeDirectoryIcon.png\" width=\"35px\" title=\"Active Directory Login\"/></td></tr>";
                                    }
                                    usernameContent+="</table>";
                                    
                                    if(i<accountsList.size()-1)
                                    {
                                        out.println("['"+curAccount.name+"<br/>"+curAccount.surname+""+docMitroo+"', '"+usernameContent+"', '"+roleText+"', '"+locationText+"', '"+langBacking.getLiteral(curAccount.active)+"', '"+contactContent+"','"+editUrl+"'],");
                                    }
                                    else
                                    {
                                        out.println("['"+curAccount.name+"<br/>"+curAccount.surname+""+docMitroo+"', '"+usernameContent+"', '"+roleText+"', '"+locationText+"', '"+langBacking.getLiteral(curAccount.active)+"', '"+contactContent+"','"+editUrl+"']");
                                    }
                                }
                            %>
                            ],
                            columns: [
                                { headerText: "<%= langBacking.getLiteral("name_surname") %>" }, { headerText: "<%= langBacking.getLiteral("username") %>" }, { headerText: "<%= langBacking.getLiteral("role") %>" }, { headerText: "<%= langBacking.getLiteral("site") %>" }, { headerText: "<%= langBacking.getLiteral("active_account") %>" }, { headerText: "<%= langBacking.getLiteral("contact") %>" }, { headerText: " ", width:60}
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
$(":input[type='button']").button();
});


</script>
    
</html>