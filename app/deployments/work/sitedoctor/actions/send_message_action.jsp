

<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="beans.MessageBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");

String returnToPage=request.getHeader("Referer");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String newMessage = request.getParameter("newMessage");
if(newMessage!=null && newMessage.length()>0)
{
    MessageBean newMsg = new MessageBean();
    newMsg.setDateAndTime(new Timestamp(new Date().getTime()));
    newMsg.setFromAccountBean(siteDoctorBacking.AB);
    newMsg.setMessage(newMessage);
    //insert new 
    if(siteDoctorBacking.insertNewMessage(newMsg)==true)
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