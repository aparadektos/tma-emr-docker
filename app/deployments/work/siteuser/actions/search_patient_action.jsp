<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>
01.


<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

//get new site fields
request.setCharacterEncoding("UTF-8");
String patName=request.getParameter("patName").trim();
String patSurname=request.getParameter("patSurname").trim();
String patFathersName=request.getParameter("patFathersName").trim();
String patSSN=request.getParameter("patSSN").trim();
String monthOb="";
if(request.getParameter("monthObPicker")!=null && request.getParameter("monthObPicker").trim().length()>0)
{
    monthOb=request.getParameter("monthObPicker").trim();
}
String dayOb="";
if(request.getParameter("dayObPicker")!=null && request.getParameter("dayObPicker").trim().length()>0)
{
    dayOb=request.getParameter("dayObPicker").trim();
}

String yearOb="";
if(request.getParameter("yearObPicker")!=null && request.getParameter("yearObPicker").trim().length()>0)
{
    yearOb=request.getParameter("yearObPicker").trim();
}

String patMobilePhone=request.getParameter("patMobilePhone").trim();
String patHomePhone=request.getParameter("patHomePhone").trim();

//replace special chars
//not necessary for this action

//validate fields
if(patName==null || patName.length()==0)
{
    patName="";
}
if(patSurname==null || patSurname.length()==0)
{
    patSurname="";
}
if(patSSN==null || patSSN.length()==0)
{
    patSSN="";
}
Date birthDate=null;
String patDob="";
if(monthOb.length()>0 && dayOb.length()>0 && yearOb.length()>0)
{
    try
    {
        birthDate=new Date(Integer.parseInt(yearOb)-1900,Integer.parseInt(monthOb)-1,Integer.parseInt(dayOb));
        patDob=birthDate.getTime()+"";
    }
    catch(Exception e)
    {
        birthDate=null;
    }
    
}

if(patName.length()>0 || patSurname.length()>0 || patSSN.length()>0 || patDob.length()>0 || 
        patHomePhone.length()>0 || patMobilePhone.length()>0)
{
    //create new patBean
    
    patBean PB=new patBean("", patName, patSurname, patFathersName, "", patHomePhone, "", patMobilePhone, patSSN, "", siteUserBacking.AB.SB.id, "", "");
    PB.birthDate=birthDate;
    
    siteUserBacking.searchPatientBySite(PB);
    
    if(siteUserBacking.patientSearchResults!=null && siteUserBacking.patientSearchResults.size()>0)
    {
        response.sendRedirect("../patients.jsp");
    }
    else
    {
        siteUserBacking.infoMessage=langBacking.getLiteral("search_no_patients");
        response.sendRedirect("../patients.jsp");
    }
    
    /*
    //necessary to get siteid
    accountBean AB=(accountBean)session.getAttribute("AB");
    
    //create new patBean
    patBean PB=new patBean("", patName, patSurname, patFathersName, patDob, "", "", patHomePhone, "", patMobilePhone, patSSN, "", AB.SB.id, "", "");

    //retrieve DB
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");

    //search in tcos and tconsult DBs. Not necessary in standalone version
    ArrayList<patBean> patList=DBH.searchPatientBySite(PB);
    
    if(PB.name!=null && PB.name.length()>0 && PB.surname!=null && PB.surname.length()>0)
    {
        siteUserBacking.searchedPatientBean=PB;
    }
    else
    {
        siteUserBacking.searchedPatientBean=null;
    }

    //store patList temporary
    session.setAttribute("patList", patList);

    response.sendRedirect("../patients.jsp?results=true");
 */
}
else
{
    siteUserBacking.infoMessage=langBacking.getLiteral("invalid_search");
    siteUserBacking.patientSearchResults=null;
    siteUserBacking.searchedPatientBean=null;
    response.sendRedirect("../patients.jsp?results=invalidParams");
}
%>