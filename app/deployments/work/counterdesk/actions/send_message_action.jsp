

<%@page import="beans.accountBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="beans.MessageBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");

String returnToPage=request.getHeader("Referer");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String toAccountId = request.getParameter("toAccountId");
String newMessage = request.getParameter("newMessage");

//replace special chars
newMessage=newMessage.replaceAll("\n", "  ");

if(newMessage!=null && newMessage.length()>0)
{
    MessageBean newMsg = new MessageBean();
    newMsg.setDateAndTime(new Timestamp(new Date().getTime()));
    newMsg.setFromAccountBean(counterdeskBacking.getAB());
    newMsg.setMessage(newMessage);
    accountBean accB = new accountBean();
    accB.id=toAccountId;
    newMsg.setToAccountBean(accB);
    //insert new 
    if(counterdeskBacking.insertNewMessage(newMsg)==true)
    {
        
    }
    else
    {

    }
}
else
{
    
}
response.sendRedirect(returnToPage);
%>