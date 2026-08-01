

<%@page import="beans.Icd10Bean"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">


<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ConsultantBacking consultantBacking = (ConsultantBacking)session.getAttribute("consultantBacking");
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
                            String teleAppHash=request.getParameter("teleAppHash");
                            consultantBacking.setSelectedTeleAppointment(null);
                            if(teleAppHash!=null && teleAppHash.length()>0)
                            {
                                //find teleAppointment from selected patient's teleAppointmentsList
                                consultantBacking.setSelectedTeleAppointment(consultantBacking.getSelectedPatientToViewHistory().getTeleAppointmentByHash(teleAppHash));
                            }

                            if(consultantBacking.getSelectedTeleAppointment()!=null && consultantBacking.getSelectedTeleAppointment().getAdviceIcdList()!=null)
                            {
                                out.println("<h3>"+langBacking.getLiteral("selected_deseases")+"</h3><br/>");
                                out.println("<table id='icdListTable' style='width:670px'>");
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
                                    for(int i=0; i<consultantBacking.getSelectedTeleAppointment().getAdviceIcdList().size(); i++)
                                    {
                                        Icd10Bean curIcdBean = consultantBacking.getSelectedTeleAppointment().getAdviceIcdList().get(i);
                                        String href="<div align=\"center\"><a href=\"actions/remove_advice_icd_action.jsp?icdId="+curIcdBean.id+"\"><img src=\"../images/trash.png\" width=\"25px\" title=\"Αφαίρεση κωδικού\"/></a></div>";
                                        if(i<consultantBacking.getSelectedTeleAppointment().getAdviceIcdList().size()-1)
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
                                            { headerText: "<%= langBacking.getLiteral("description") %>" , width: '510px'},
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width:'80px' }
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
                                            <input type="text" name="icdDescr" value="<%= consultantBacking.getIcdDescrSearchString() %>" style="width:400px" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="submit" value="<%= langBacking.getLiteral("search") %>"/>
                                        </td>
                                    </tr>
                                </table>
                            </form>
                            <br/>
                            <%
                            if(consultantBacking.getIcdResultsList()!=null)
                            {
                                out.println("<h3>"+langBacking.getLiteral("search_results") +"</h3><br/>");
                                out.println("<table id='icdSearchResultsTable' style='width:670px' >");
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
                                    for(int i=0; i<consultantBacking.getIcdResultsList().size(); i++)
                                    {
                                        Icd10Bean curIcdBean = consultantBacking.getIcdResultsList().get(i);
                                        String href="<div align=\"center\"><a href=\"actions/select_advice_icd_action.jsp?icdId="+curIcdBean.id+"\"><img src=\"../images/completed.png\" width=\"30px\" title=\"Επιλογή κωδικού\"/></a></div>";
                                        if(i<consultantBacking.getIcdResultsList().size()-1)
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
                                            { headerText: "<%= langBacking.getLiteral("description") %>" , width:'510px' },
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width:'80px' }
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
                    <a href="viewPatientHistory.jsp?patId=<%= consultantBacking.getSelectedPatientToViewHistory().id %>" target="_parent"><input type="button" value="<%= langBacking.getLiteral("return") %>" /></a>
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