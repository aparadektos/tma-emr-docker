<%@page import="beans.DoctorBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.avPeriod"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.docAvBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
//get new site fields
request.setCharacterEncoding("UTF-8");

String docid=request.getParameter("docid").trim();
String startDate=request.getParameter("startDate").trim();
String endDate=request.getParameter("endDate").trim();
String startTime=request.getParameter("startTime").trim();
String endTime=request.getParameter("endTime").trim();

//replace special chars
//not in this action

//validate fields
if(docid!=null && docid.length()>0 && startDate!=null && startDate.length()>0 &&
        endDate!=null && endDate.length()>0 && startTime!=null && startTime.length()>0 &&
        endTime!=null && endTime.length()>0)
{
    //get doctorBean
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");
    DoctorBean docBean = DBH.getDoctorByID(docid);

    //create 1-item list of doctor's availability period (avPeriod).
    String tmpDate[]=startDate.split("/");
    // 6/11/2012
    //tmpDate[0] => 6
    //tmpDate[1] => 11
    //tmpDate[2] => 2012
    String tmpTime[]=startTime.split(":");
    // 7:00
    //tmpTime[0] => 7
    //tmpTime[1] => 00
    Timestamp startTimestamp=new Timestamp(Integer.parseInt(tmpDate[2])-1900, Integer.parseInt(tmpDate[0]), Integer.parseInt(tmpDate[1]), Integer.parseInt(tmpTime[0]), Integer.parseInt(tmpTime[1]), 0, 0);

    tmpDate=endDate.split("/");
    // 6/11/2012
    //tmpDate[0] => 6
    //tmpDate[1] => 11
    //tmpDate[2] => 2012
    tmpTime=endTime.split(":");
    // 7:00
    //tmpTime[0] => 7
    //tmpTime[1] => 00
    Timestamp endTimestamp=new Timestamp(Integer.parseInt(tmpDate[2])-1900, Integer.parseInt(tmpDate[0]), Integer.parseInt(tmpDate[1]), Integer.parseInt(tmpTime[0]), Integer.parseInt(tmpTime[1]), 0, 0);

    ArrayList<avPeriod> avPeriodList = new ArrayList<avPeriod>();
    avPeriodList.add(new avPeriod("", startTimestamp, endTimestamp));

    //create docAvBean
    docAvBean DAB=new docAvBean(docBean, avPeriodList);

    //insert new docAvBean to DB table
    if(DBH.insertNewDoctorAvailabilty(DAB)==true)
    {
        //if success response OK 
        response.sendRedirect("../doctors.jsp?result=newAvailAdded&view=avDoctor&docid="+docid);
    }
    else
    {
        //if failed response ERROR 
        response.sendRedirect("../doctors.jsp?result=errorAvail&view=avDoctor&docid="+docid);
    }
}
else
{
    response.sendRedirect("../doctors.jsp?result=error");
}
%>