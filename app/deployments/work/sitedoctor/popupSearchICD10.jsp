
<%@page import="beans.Icd10Bean"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
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
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../popupStyle.css" rel="stylesheet" type="text/css" media="screen"/>
        
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
    
</script>
    
    <body >

    <div id="wrapper">
	
	<div id="page">
            <div id="page-bgtop">
                <div id="content">
                    <div class="post">
                        
                        <div class="entry">

                            <%
                            request.setCharacterEncoding("UTF-8");
                            String returnToPage=request.getHeader("Referer");
                            if(returnToPage!=null && returnToPage.indexOf("patients.jsp")>0)
                            {
                                siteDoctorBacking.urlToReturn=request.getHeader("Referer");
                            }
                            
                            appointmentsBean newAppBean = (appointmentsBean)session.getAttribute("newAppBean");
                            if(newAppBean!=null && newAppBean.icdList!=null)
                            {
                                out.println("<h3>"+langBacking.getLiteral("selected_deseases")+"</h3><br/>");
                                out.println("<table id='icdListTable' >");
                                out.println("</table>");
                            %>
                                <script type="text/javascript">
                                    $("#icdListTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 12,
                                        allowColSizing: true,
                                        ensureColumnsPxWidth:true,
                                        data: [
                            <%
                                    for(int i=0; i<newAppBean.icdList.size(); i++)
                                    {
                                        Icd10Bean curIcdBean = newAppBean.icdList.get(i);
                                        String href="<a href=\"actions/remove_icd_action.jsp?icdId="+curIcdBean.id+"\"><img src=\"../images/trash.png\" width=\"25px\" title=\"Αφαίρεση κωδικού\"/></a>";
                                        if(i<newAppBean.icdList.size()-1)
                                        {
                                            out.println("['"+curIcdBean.code+"','"+curIcdBean.nameEl+"','"+href+"'],");
                                        }
                                        else
                                        {
                                            out.println("['"+curIcdBean.code+"','"+curIcdBean.nameEl+"','"+href+"']");
                                        }
                                    }
                            %>
                                        ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("icd10_code") %>" , width:'80px' },
                                            { headerText: "<%= langBacking.getLiteral("description") %>" , width:'760px'},
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width:'90px' }
                                        ]
                                        });
                                </script>
                            <%                                
                            }
                            %>
                            <br/>
                            <form method="post" action="actions/search_icd10_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td>
                                            <input type="text" name="icdDescr" value="<%= siteDoctorBacking.icdDescrSearchString %>" style="width:400px" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="submit" value="<%= langBacking.getLiteral("search") %>"/>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <br/>
                            <%
                            if(siteDoctorBacking.icdResultsList!=null)
                            {
                                out.println("<h3>"+langBacking.getLiteral("search_results") +"</h3><br/>");
                                out.println("<table id='icdSearchResultsTable' >");
                                out.println("</table>");
                                
                            %>
                                <script type="text/javascript">
                                    $("#icdSearchResultsTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 5,
                                        allowColSizing: true,
                                        ensureColumnsPxWidth:true,
                                        data: [
                            <%
                                    for(int i=0; i<siteDoctorBacking.icdResultsList.size(); i++)
                                    {
                                        Icd10Bean curIcdBean = siteDoctorBacking.icdResultsList.get(i);
                                        String href="<a href=\"actions/select_icd_action.jsp?icdId="+curIcdBean.id+"\"><img src=\"../images/completed.png\" width=\"30px\" title=\"Επιλογή κωδικού\"/></a>";
                                        if(i<siteDoctorBacking.icdResultsList.size()-1)
                                        {
                                            out.println("['"+curIcdBean.code+"','"+curIcdBean.nameEl+"','"+href+"'],");
                                        }
                                        else
                                        {
                                            out.println("['"+curIcdBean.code+"','"+curIcdBean.nameEl+"','"+href+"']");
                                        }
                                    }
                            %>
                                        ],
                                        columns: [
                                            { headerText: "<%= langBacking.getLiteral("icd10_code") %>" , width:'80px' },
                                            { headerText: "<%= langBacking.getLiteral("description") %>" , width:'760px'},
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width:'90px' }
                                        ]
                                        });
                                </script>
                            <%   
                            }
                            else
                            {
//                                out.println("No results");
                            }
                            %>
                            
                        </div>
                    </div>

                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
                <center>
                    <a href="<%= siteDoctorBacking.urlToReturn %>" target="_parent"><input type="button" value="Επιστροφή"/></a>
                </center>
            </div>
        </div>
            
    </div>
    
    </body>

    <!-- Javascript functions  -->
    <script language="javascript">
        $(":input[type='button'],:input[type='submit']").button(); 
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
    </script>

</html>