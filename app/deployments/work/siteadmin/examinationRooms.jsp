<%@page import="beans.DepartmentBean"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.ModalityBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="beans.cartAvBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.cartBean"%>

<!-- Initializations -->
<%
//retrieve DBH from session
DBHelper DBH=(DBHelper)session.getAttribute("DBH");
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteAdminBacking siteAdminBacking = (SiteAdminBacking)session.getAttribute("siteAdminBacking");
%>

<%
// retrieve all carts that are not assigned to the examination rooms
ArrayList<ModalityBean> UnallocatedModalityList = DBH.getAllUnallocatedModalities(AB.SB.id);
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
        <script src="../wijmotools/external/jquery.mousewheel.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
        <!--<link href="../wijmotools/wijmo/jquery.wijmo.wijcombobox.css" rel="stylesheet" type="text/css" />-->
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
    </head>

<!-- Javascript functions  -->
<script language="javascript">
function checkNewExamForm()
{
    document.getElementById("addExamForm").submit();
}

function checkEditExamForm()
{
    document.getElementById("editExamForm").submit();
}

function showNewExamForm()
{
    document.getElementById("newExamFormDiv").style.display = "inline";
    document.getElementById("editExamFormDiv").style.display = "none";
}

function confirmExamDelete(examID)
{
    if (confirm("<%= langBacking.getLiteral("delete_exam_room_confirm") %>")) { 
       window.location = "actions/delete_exam_action.jsp?id="+examID;
    }
}


</script>

    
<body>  
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "examination_rooms"); %>
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
                    
                    <div class="post" id="newExamFormDiv" style="display:inline;">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("add_examination_room") %></a></h2>
                        <div class="entry">
                            
                            <form id="addExamForm" method="post" action="actions/add_exam_action.jsp">
                                <table border="0">
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                        <td>
                                            <input name="examName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("modality") %>:</td>
                                        <td>
                                            <select style="width: 200px;" id="newExamCartId" name="newExamCartId">
                                                <option selected="true" value="none">None</option>
                                                <%
                                                for(int i=0; i<UnallocatedModalityList.size(); i++)
                                                {
                                                   ModalityBean mBean=UnallocatedModalityList.get(i);
                                                   out.println("<option value='"+mBean.id+"'>"+mBean.name+" ("+mBean.manufacturer+")</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("department") %>:</td>
                                        <td>
                                            <select style="width: 200px;" id="newExamRoomDepartId" name="newExamRoomDepartId">
                                                <option selected="true" value="none">None</option>
                                                <%
                                                ArrayList<DepartmentBean> activeDepartments = siteAdminBacking.getAllActiveDepartmentsBySiteId();
                                                for(DepartmentBean curDepart : activeDepartments)
                                                {
                                                    out.println("<option value='"+curDepart.getId()+"'>"+curDepart.getName()+"</option>");
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("description") %>:</td>
                                        <td>
                                            <textarea name="examDescription" id="area" rows="3" cols="50"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("availability") %></td>
                                        <td>
                                            <input type="radio" name="examAvailable" value="1" /><%= langBacking.getLiteral("available") %><br />
                                            <input type="radio" name="examAvailable" value="0" /><%= langBacking.getLiteral("not_available") %><br />
                                        </td>
                                    </tr>        
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkNewExamForm();"/>
                                    </td>
                                    </tr>
                                </table>
                            </form>
                       </div>
                    </div>
                    <%
                    if(request.getParameter("view")!=null && request.getParameter("id")!=null && request.getParameter("id").length()>0 && request.getParameter("view").equals("edit"))
                    {
                        ExamroomsBean editERB=DBH.getExamRoomByID(request.getParameter("id"));
            %>
                    <div class="post" id="editExamFormDiv">
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("edit_examination_room") %></a></h2>
                        <div class="entry">
                            
                            <form id="editExamForm" method="post" action="actions/edit_exam_action.jsp">
                                <input type="hidden" name="examid" value="<%=editERB.id%>"/>
                                <table border="0">
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                        <td>
                                            <input value="<%=editERB.name%>" name="examName" id="textbox" type="text" size="53"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("modality") %></td>
                                        <td>
                                            <select style="width: 200px;" id="exammodalityid" name="exammodalityid">
                                                <option value="<%=editERB.modalityid%>"><%=DBH.getModalityByID(editERB.modalityid).name%></option> 
                                                <option value="none">None</option>
                                                <%
                                                for(int i=0; i<UnallocatedModalityList.size(); i++)
                                                {
                                                   ModalityBean mBean=UnallocatedModalityList.get(i);
                                                   out.println("<option value='"+mBean.id+"'>"+mBean.name+" ("+mBean.type+")");
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("department") %>:</td>
                                        <td>
                                            <select style="width: 200px;" id="examRoomDepartId" name="examRoomDepartId">
                                                <option selected="true" value="none">None</option>
                                                <%
                                                activeDepartments = siteAdminBacking.getAllActiveDepartmentsBySiteId();
                                                for(DepartmentBean curDepart : activeDepartments)
                                                {
                                                    if(curDepart.getId().equals(editERB.getDepartmentBean().getId()))
                                                    {
                                                        out.println("<option selected value='"+curDepart.getId()+"'>"+curDepart.getName()+"</option>");
                                                    }
                                                    else
                                                    {
                                                        out.println("<option value='"+curDepart.getId()+"'>"+curDepart.getName()+"</option>");
                                                    }
                                                }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("description") %>:</td>
                                        <td>
                                            <textarea name="examDescription" id="area" rows="3" cols="50"><%=editERB.description%></textarea>
                                        </td>
                                    </tr>    
                                    <tr>
                                        <td align="right"><%= langBacking.getLiteral("availability") %>:</td>
                                        <td>
                                            <input type="radio" name="examAvailable" id="examAvailable" value="1" <% if(editERB.available.equalsIgnoreCase("1")){out.println("checked");}%> ><%= langBacking.getLiteral("available") %></input>
                                            <input type="radio" name="examAvailable" id="examAvailable" value="0" <% if(editERB.available.equalsIgnoreCase("0")){out.println("checked");}%> ><%= langBacking.getLiteral("not_available") %></input>
                                        </td>
                                    </tr>    
                                    <tr>
                                    <td align="center" colspan="2">
                                        <input type="button" value="<%= langBacking.getLiteral("save") %>" onClick="javascript:checkEditExamForm();"/>
                                    </td>
                                    </tr>
                                </table>
                                </form>
                        </div>
                    </div>
                    <%
                    }%>
                    <!-- div that contains all examination rooms -->
                    <div class="post" style="width: 800px;" >
                        <h2 class="title">
                            <a href="#"><%= langBacking.getLiteral("examination_rooms") %></a></h2>
                        <div class="entry">
                            <%                            
                            //retrieve all carts
                            ArrayList<ExamroomsBean> ERBList=DBH.getExamRoomsBySiteID(AB.SB.id);
                            if(ERBList!=null && ERBList.size()>0)
                            {
                            %>
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#examsTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 10,
                                    allowColSizing: true,
                                    data: [
                            <%
                                String isAvailable;
                                for(int i=0; i<ERBList.size(); i++)
                                {
                                    ExamroomsBean ERB=ERBList.get(i);
                                    String hrefs="<a onmouseover=\"ShowContentEdit(); return true;\" onmouseout=\"HideContentEdit();return true;\" href=\"examinationRooms.jsp?view=edit&id="+ERB.id+"\"><img alt=\"Edit\" src=\"../images/update.gif\" style=\"border:0px;\"></a>&nbsp;"
                                                    + "&nbsp;<a onmouseover=\"ShowContentDelete(); return true;\" onmouseout=\"HideContentDelete();return true;\" href=\"javascript:confirmExamDelete("+ERB.id+");\"><img alt=\"Delete\" src=\"../images/delete.gif\" style=\"border:0px;\"></a>&nbsp;";
                                    
                                    if (ERB.available.equalsIgnoreCase("1")){
                                        isAvailable="<h4>"+langBacking.getLiteral("available")+"</h4>";
                                    }
                                    else{
                                        isAvailable="<h4 Style=\"color:#980000;\">"+langBacking.getLiteral("not_available")+"</h4>";
                                    }
                                    
                                    
                                    if(i<ERBList.size()-1)
                                    {
                                        out.println("['<b>"+ERB.name+"</b><br/>("+ERB.getDepartmentBean().getName()+")','"+ERB.modBean.name+"<br/>("+ERB.modBean.type+")','<h4>"+ERB.description+"</h4>','<h4>"+isAvailable+"</h4>','"+hrefs+"'],");
                                    }
                                    else
                                    {
                                        out.println("['<b>"+ERB.name+"</b><br/>("+ERB.getDepartmentBean().getName()+")','"+ERB.modBean.name+"</h4>("+ERB.modBean.type+")','<h4>"+ERB.description+"</h4>','<h4>"+isAvailable+"</h4>','"+hrefs+"']");                                     
                                    }
                                }
                            %>
                            ],
                            columns: [
                                     { headerText: "<%= langBacking.getLiteral("name") %> <br/> (<%= langBacking.getLiteral("department") %>) " },
                                     { headerText: "<%= langBacking.getLiteral("modality") %>"},
                                     { headerText: "<%= langBacking.getLiteral("description") %>"},
                                     { headerText: "<%= langBacking.getLiteral("availability") %>"},
                                     { headerText: "<%= langBacking.getLiteral("actions") %>"}
                            ]
                        });
                    });
                    </script>
                            <%
                                out.println("<table id='examsTable'>");
                                out.println("</table>");
                            }
                            else
                            {
                                out.println("No records found!");
                            }
                            %>
                            <br/>
                        </div>
                    </div>
                </div>
		<!-- end #content -->
		<div id="sidebar">
                    <ul>
                        <li>
                            <h2><%= langBacking.getLiteral("actions") %></h2>
                            <ul>
                                <li><a href="javascript:showNewExamForm();"><%= langBacking.getLiteral("add_examination_room") %></a></li>
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
  
    <script language="javascript">
        $(":input[type='text'],:input[type='password'],textarea").wijtextbox();
        $(":input[type='radio']").wijradio();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
        $(":input[type='checkbox']").wijcheckbox();
        $(":input[type='button']").button();
        $("#newExamCartId").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
        $("#newExamRoomDepartId").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
        document.getElementById("newExamFormDiv").style.display = "none";
        
        $("#exammodalityid").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
        $("#examRoomDepartId").wijcombobox({
        showingAnimation: { effect: "blind" },
        isEditable: false,
        autoFilter: true,
        autoComplete: true,
        highlightMatching: true,
        hidingAnimation: { effect: "blind" }
        });
        
    </script>
    
    </body>
</html>