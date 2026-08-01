<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<% Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
   String cartid=request.getParameter("id"); //the cart id that will be updated
  
   Connection connection = DriverManager.getConnection("jdbc:odbc:tcos","root","nbuser"); 
   Statement selectSitesStatement=connection.createStatement();
   ResultSet Siteresultset = selectSitesStatement.executeQuery("select id,name from sites");
   
   Statement selectCartStatement=connection.createStatement();
   String query="select c.name, c.manufacturer,c.siteid,c.portable,c.statusid,c.comments, s.name, st.name from carts c, sites s, status st where s.id=c.siteid and  c.portable = st.id and c.id="+cartid;
   ResultSet Cartresultset = selectCartStatement.executeQuery(query);
   
   

     
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title></title>
<style type="text/css">
#updateCartForm{
font-family:Verdana, Arial, Helvetica, sans-serif;
font-size:12px;
color:#666666;
}
#updateCartForm th{
background-color:#CCCCCC;
color:#000000;
height:25px;
}
label{
height:25px;
}
.textInput{
border:1px solid #CCCCCC;
width:300px;

}
.textArea{
border:1px solid #CCCCCC;
width:300px;
}
.button{
background-color:#CCCCCC;
color:#000000;
}
</style>

</head>

<body>
<div id="result"></div>
<form id="updateCartForm" name="updateCartForm" method="post" action="test.jsp"  >

  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <th colspan="2" scope="col">Update Cart's Record with id:<% out.print(cartid);%> </th>
    </tr>
		<tr>
		<td colspan="2" height="10"></td>
	</tr>
    <tr>
      <td width="208"><label for="name">Cart Name</label>&nbsp;</td>
      <td width="292"><input name="name" type="text" id="name" class="textInput" value="" /></td>
    </tr>
    <tr>
      <td colspan="2" height="10"></td>
    </tr>
    <tr>
      <td width="208"><label for="manufacturer">manufacturer</label>&nbsp;</td>
      <td width="292"><input name="manufacturer" type="text" id="manufacturer" class="textInput" /></td>
    </tr>
    <tr>
      <td colspan="2" height="10"></td>
    </tr>
    <tr>
      <td width="208"><label for="Select the Site that the Cart belongs to">Site</label>&nbsp;</td>
      <td width="292"><select name="siteid" id="siteid">
                      <option value=""></option>
                      <% while(Siteresultset.next()){ 
                             String id=Siteresultset.getString(1);
                             String name=Siteresultset.getString(2);
                             out.println("<option value="+id+">"+name+"</option>");
                          }
                       %>
                      </select>
      </td>    
      </tr>
      <tr>
         <td colspan="2" height="10"></td>
      </tr>
      <tr>
         <td width="208"><label for="portable">is Portable?</label>&nbsp;</td>
         <td width="292"><select name="siteid" id="siteid">
                         <option value=""></option>
                         <option value="1">Yes</option>
                         <option value="2">No</option>
                         </select>   
         </td>
      </tr>
      <tr>
	<td colspan="2" height="10"></td>
      </tr>
      <tr>
         <td width="208"><label for="status">Status</label>&nbsp;</td>
         <td width="292"><select name="statusid" id="statusid">
                         <option value=""></option>
                         <option value="1">Available</option>
                         <option value="2">Not available</option>
                         </select>   
         </td>
      </tr>
      <tr>
         <td width="208"><label for="comments">Comments</label>&nbsp;</td>
         <td width="292"><textarea name="comments" id="comments" class="textArea"></textarea></td>
      </tr>
      <tr>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
      </tr>
      <tr>
         <td>&nbsp;</td>
         <td><input type="submit" value="ok"></input></td>
      </tr>
      <tr>
         <td>&nbsp;</td>
         <td>&nbsp;</td>
      </tr>
  </table>
                    
</form>
</body>
</html>
    