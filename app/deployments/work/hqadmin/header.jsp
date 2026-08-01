<%@page import="tools.GlobalHelper"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.roleBean"%>

<%
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");
%>

<div id="logo">
    <table border="0" width="100%">
        <tr>
            <td>
                <font color="white"><b>User</b>: <%= AB.name+" "+AB.surname %> - <b>Role</b>: <%= AB.RB.roleName %></font>
            </td>
            <td align="right" valign="middle" rowspan="2">
                <img src="../images/TMA_LOGO_120_pixel_height.png"/>
            </td>
        </tr>
        <tr>
            <td valign="middle">
                <font color="white" style="font-size: 2.2em;"><%= GH.headerTitle %></font>
                <p><em> <%= GH.headerSubtitle %></em></p>
            </td>
        </tr>
    </table>
</div>