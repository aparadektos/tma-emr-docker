

<%@page import="beans.appointmentsBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.ExamTypeBean"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>


<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");
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
                            
                            String examTypeDescr = request.getParameter("examTypeDescr");
                            ArrayList<ExamTypeBean> examTypesResultsList=null;
                            if(examTypeDescr!=null && examTypeDescr.trim().length()>0)
                            {
                                examTypesResultsList=siteUserBacking.getExamTypesByDescription(examTypeDescr.trim());
                            }
                            else
                            {
//                                out.println("invalid examTypeDescr");
                            }
                            
                            appointmentsBean newAppBean = (appointmentsBean)session.getAttribute("newAppBean");
                            if(newAppBean!=null && newAppBean.ETB!=null && newAppBean.PB!=null && newAppBean.ETB.getDescriptionEl().length()>0)
                            {
                                out.println("<h3>Επιλεγμένος τύπος εξέτασης:</h3><br/>");
                                if(newAppBean.ETB.getModalityType()!=null && newAppBean.ETB.getModalityType().length()>0)
                                {
                                    out.println("<b>("+newAppBean.ETB.getModalityType()+") "+newAppBean.ETB.getDescriptionEl()+"</b><br/><br/>");
                                }
                                else
                                {
                                    out.println("<b>"+newAppBean.ETB.getDescriptionEl()+"</b><br/><br/>");
                                }
                                returnToPage="patients.jsp?action=newAppoint&patid="+newAppBean.PB.id;
                            }
                            
                            if(examTypesResultsList!=null && examTypesResultsList.size()>0)
                            {
                                out.println("<table id='examTypesTable' style='width:920px'>");
                                out.println("</table>");
                            %>
                                <script type="text/javascript">
                                    $("#examTypesTable").wijgrid({
                                        allowSorting: true,
                                        allowPaging: true,
                                        pageSize: 12,
                                        allowColSizing: true,
                                        ensureColumnsPxWidth:true,
                                        data: [
                            <%
                                for(int i=0; i<examTypesResultsList.size(); i++)
                                {
                                    ExamTypeBean curExamTypeBean = examTypesResultsList.get(i);
                                    String fullDescr=curExamTypeBean.getDescriptionEl();
                                    
                                    if(curExamTypeBean.getModalityType()!=null && curExamTypeBean.getModalityType().length()>0)
                                    {
                                        fullDescr="("+curExamTypeBean.getModalityType()+") "+fullDescr;
                                    }
                                    
                                    if(fullDescr.length()>400)
                                    {
                                        fullDescr=fullDescr.substring(0, 400)+"........";
                                    }
                                    fullDescr=fullDescr.replaceAll("\"", "&quot;");
                                    fullDescr=fullDescr.replaceAll("\'", "&#39;");
                                    fullDescr=fullDescr.replaceAll("΄", "&#39;");
                                    fullDescr=fullDescr.replaceAll("\n", " ");
                                    fullDescr=fullDescr.replaceAll("\r", " ");
                                    fullDescr=fullDescr.replaceAll("\n\r", " ");
                                    
                                    String href="<a href=\"actions/select_exam_type_action.jsp?examTypeId="+curExamTypeBean.getId()+"\"><img src=\"../images/completed.png\" width=\"30px\" title=\"Επιλογή τύπου εξέτασης\"/></a>";
                                    if(i<examTypesResultsList.size()-1)
                                    {
//                                        out.println("['"+href+"','"+fullDescr+"'],");
                                        out.println("['"+fullDescr+"','"+href+"'],");
                                    }
                                    else
                                    {
//                                        out.println("['"+href+"','"+fullDescr+"']");
                                        out.println("['"+fullDescr+"','"+href+"']");
                                    }
                                }
                            %>
                                        ],
                                        columns: [
                                            
                                            { headerText: "<%= langBacking.getLiteral("description") %>" , width:'840px'},
                                            { headerText: "<%= langBacking.getLiteral("actions") %>" , width:'80px' }
                                            
                                            
                                            
                                        ]
                                        });
                        
                                </script>
                            <%    
                            }
                            else
                            {
                                out.println("No results");
                            }
                            %>
                        </div>
                    </div>

                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
                <center>
                    <a href="<%= returnToPage %>" target="_parent"><input type="button" value="Επιστροφή"/></a>
                </center>
            </div>
        </div>
            
    </div>
    
    </body>

    <!-- Javascript functions  -->
    <script language="javascript">
        $(":input[type='button']").button();
    </script>

</html>