

<%@page import="beans.EmergencyFileBean"%>
<%@page import="java.util.Date"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="beans.ConsultantBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
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
        <script src="../wijmotools/external/jquery.mousewheel.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
<!--        <link href="../wijmotools/wijmo/jquery.wijmo.wijcombobox.css" rel="stylesheet" type="text/css" />-->
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
        <script src="../wijmotools/wijmo/jquery.wijmo.wijcombobox.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijinputdate.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijtextselection.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijinputcore.js" type="text/javascript"></script>
        <script src="../wijmotools/wijmo/jquery.wijmo.wijevcal.js" type="text/javascript"></script>
        
        <script src="../wijmotools/external/cultures/globalize.culture.el-GR.js" type="text/javascript"></script>
        
    </head>

<!-- Javascript functions  -->
<script language="javascript">
    /*
    function markEfimeriaAndTime(divObj)
    {
        for(id=0; id<50; id++)
        {
            var curDivObj=document.getElementById("div#"+id);
            if(curDivObj!==null)
            {
                curDivObj.style.backgroundColor="transparent";
            }
        }
        divObj.style.backgroundColor="orange";
    }

    function submitConsultantAssignment()
    {
        if(confirm("<%= langBacking.getLiteral("emergency_assign_confirm") %>"))
        {
            for(id=0; id<50; id++)
            {
                var curDivObj = document.getElementById("div#"+id);
                if(curDivObj!==null && curDivObj.style.backgroundColor==="orange")
                {
                    var temp=document.getElementById("div#"+id).title.split("##");
                    var efimeriaId=temp[0];
                    var time=temp[1];

                    document.getElementById("selectedEmergencyEfimeriaId").value=efimeriaId;
                    document.getElementById("selectedEmergencyTime").value=time;

                    document.getElementById("selectedEmergencyEfimeriaFormId").submit();
                }
            }
        }
    }
    */
</script>
    
    <body >

    <div id="wrapper">
	
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
                    <div class="post">
                        <div class="entry">
                            <%
                            String erHash=request.getParameter("erHash");
                            if(erHash!=null && erHash.length()>0)
                            {
                                paramedicBacking.setSelectedEmergencyCaseBean(null);
                                paramedicBacking.setSelectedEmergencyCaseBean(paramedicBacking.getEmergencyCaseByHashFromResults(erHash));
                            }
                            
                            if(paramedicBacking.getSelectedEmergencyCaseBean()!=null && 
                               paramedicBacking.getSelectedEmergencyCaseBean().id!=null && 
                               paramedicBacking.getSelectedEmergencyCaseBean().id.length()>0)
                            {
                            %>
                                <form method="post" action="actions/upload_emergency_file_action.jsp" enctype="multipart/form-data">
                                    <input name="emergencyFile1" type="file" />
                                    <br/>
                                    <input name="emergencyFile2" type="file" />
                                    <br/>
                                    <input name="emergencyFile3" type="file" />
                                    <br/>
                                    <input name="emergencyFile4" type="file" />
                                    <br/>
                                    <br/>
                                    <center>
                                        <input type="submit" value="<%= langBacking.getLiteral("save") %>" />
                                    </center>
                                </form>
                            <%
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_selection"));
                            }
                            %>
                        </div>
                    </div>
                        
                    <div class="post">
                        <div class="entry">
                            <%
                            if(paramedicBacking.getSelectedEmergencyCaseBean()!=null)
                            {
                            %>
                            <table id='emergencyFilesTable' style="width:530px"></table>
                            <script id="scriptInit" type="text/javascript">
                                $("#emergencyFilesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 6,
                                    allowColSizing: true,
                                    ensureColumnsPxWidth:true,
                                    data: [
                                    <%
                                    String dataOutput="";
                                    for(EmergencyFileBean curFile : paramedicBacking.getSelectedEmergencyCaseBean().getFileList() )
                                    {
                                        dataOutput+="['"+curFile.getFileName()+"', '<div align=\"center\"><a href=\"actions/remove_emergency_file_action.jsp?erFileId="+curFile.getId()+"\"><img src=\"../images/trash.png\" width=\"25px\"></a></div>'],";
                                    }
                                    out.println(dataOutput);
                                    %>
                                    ],
                                    columns: [
                                        { headerText: "<%= langBacking.getLiteral("file") %>" , width: "450px"}, 
                                        { headerText: "<%= langBacking.getLiteral("actions") %>" , width: "80px"}
                                    ]
                                });
                            </script>
                            <%
                            }
                            %>
                        </div>
                    </div>
                    
                    <center>
                        <a href="emergencies.jsp" target="_parent"><input type="button" value="<%= langBacking.getLiteral("return") %>" /></a>
                    </center>
                    
                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
            </div>
        </div>
            
    </div>
                            
<script type="text/javascript">
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();
$("input[type=submit],input[type=button]").button();
</script>    
    </body>

</html>