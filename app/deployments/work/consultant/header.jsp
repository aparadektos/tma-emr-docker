<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="beans.accountBean"%>
<%@page import="beans.roleBean"%>

<%
accountBean AB=(accountBean)session.getAttribute("AB");
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
%>

<div id="logo">
    <table border="0" width="100%">
        <tr>
            <td>
                <%
                if(AB.getPhotoBytes()!=null && AB.getPhotoBytes().length>0)
                {
                    out.println("<img src='data:image/jpg;base64,"+AB.getPhotoByteArrayString()+"' style='max-width:200px; max-height: 80px' />");
                }
                else
                {
                    out.println("<img src='../images/doc.jpg' style='max-width:200px; max-height: 80px'/>");
                }
                %>
            </td>
            <td width="100%">
                <font color="white">
                    <b><%= langBacking.getLiteral("user") %>:</b> <%= AB.consultantBean.getFullName() %> 
                    <br/> 
                    <b><%= langBacking.getLiteral("role") %>:</b> <%= langBacking.getLiteral(AB.RB.roleName) %>
                    <br/>
                    <b><%= langBacking.getLiteral("specialty") %></b>: <%= AB.consultantBean.getSpecialtyBean().getNameByLang(langBacking.lang) %>
                </font>
            </td>
            <td align="right" valign="middle" rowspan="4">
                <img src="../images/TMA_LOGO_120_pixel_height.png"/>
            </td>
        </tr>
        <tr>
            <td valign="top" colspan="2">
                <font color="white" style="font-size: 2.2em;"><%= GH.headerTitle %></font>
<!--                <p><em> <%= GH.headerSubtitle %></em></p>-->
            </td>
        </tr>
    </table>
</div>