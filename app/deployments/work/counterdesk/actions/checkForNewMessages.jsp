<%@page import="beans.accountBean"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Date"%>
<%@page import="beans.MessageBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");

//retrieve form data
String minutesInterval = request.getParameter("minutesInterval");

//replace special chars


if(minutesInterval!=null && minutesInterval.length()>0)
{
    double mathRandom=Math.random();
    if(mathRandom>0.8)
    {
        System.out.println("["+new Date().toGMTString()+"] "+mathRandom);
//        out.print(mathRandom);
    }
    
    /*
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
    */
}
%>