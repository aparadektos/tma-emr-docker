<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.Date"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

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


//Ylopoihsh apo EDIT.
if( (patSSN!=null && patSSN.length()>0) || (patMobilePhone!=null && patMobilePhone.length()>0) || 
    (patHomePhone!=null && patHomePhone.length()>0) || (birthDate!=null) || 
    ((patName!=null && patName.length()>0) || (patSurname!=null && patSurname.length()>0)) )
{
    //ara kati exei symplirwthei. elegxos an symplirwthike mono to onomateponymo.
    if( (patSSN==null || patSSN.length()==0) && (patMobilePhone==null || patMobilePhone.length()==0) && 
    (patHomePhone==null || patHomePhone.length()==0) && (birthDate==null) )
    {
        //ara symplirwthike mono onomateponymo. Elegxos an einai toulaxiston to ena 2 xaraktires
        if( (patName!=null && patName.length()>2) || (patSurname!=null && patSurname.length()>2) )
        {
            patBean PB=new patBean("", patName, patSurname, patFathersName, "", patHomePhone, "", patMobilePhone, patSSN, "", siteDoctorBacking.AB.SB.id, "", "");
            PB.birthDate=birthDate;

            siteDoctorBacking.searchPatientBySite(PB);

            if(siteDoctorBacking.patientSearchResults!=null && siteDoctorBacking.patientSearchResults.size()>0)
            {
                response.sendRedirect("../patients.jsp");
            }
            else
            {
                siteDoctorBacking.infoMessage=langBacking.getLiteral("search_no_patients");
                response.sendRedirect("../patients.jsp");
            }
        }
        else
        {
            //symplirwthike onomateponymo alla me ligoterous xaraktires
            siteDoctorBacking.infoMessage=langBacking.getLiteral("name_min_search_length");
            siteDoctorBacking.patientSearchResults=null;
            siteDoctorBacking.searchedPatientBean=null;
            response.sendRedirect("../patients.jsp");
        }
    }
    else
    {
        patBean PB=new patBean("", patName, patSurname, patFathersName, "", patHomePhone, "", patMobilePhone, patSSN, "", siteDoctorBacking.AB.SB.id, "", "");
        PB.birthDate=birthDate;

        siteDoctorBacking.searchPatientBySite(PB);

        if(siteDoctorBacking.patientSearchResults!=null && siteDoctorBacking.patientSearchResults.size()>0)
        {
            response.sendRedirect("../patients.jsp");
        }
        else
        {
            siteDoctorBacking.infoMessage=langBacking.getLiteral("search_no_patients");
            response.sendRedirect("../patients.jsp");
        }
    }
}
else
{
    //den symplirwthike tpt or den einai egkyres times
    siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_search");
    siteDoctorBacking.patientSearchResults=null;
    siteDoctorBacking.searchedPatientBean=null;
    response.sendRedirect("../patients.jsp?results=invalidParams");
}



/*
//arxiki ylopoihsh. Apo edit proekypse h parapanw.
if(patName.length()>0 || patSurname.length()>0 || patSSN.length()>0 || patDob.length()>0 || 
        patHomePhone.length()>0 || patMobilePhone.length()>0)
{
    //create new patBean
    patBean PB=new patBean("", patName, patSurname, patFathersName, "", patHomePhone, "", patMobilePhone, patSSN, "", siteDoctorBacking.AB.SB.id, "", "");
    PB.birthDate=birthDate;
    
    
    siteDoctorBacking.searchPatientBySite(PB);
    
    if(siteDoctorBacking.patientSearchResults!=null && siteDoctorBacking.patientSearchResults.size()>0)
    {
        response.sendRedirect("../patients.jsp");
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("search_no_patients");
        response.sendRedirect("../patients.jsp");
    }
}
else
{
    siteDoctorBacking.infoMessage=langBacking.getLiteral("invalid_search");
    siteDoctorBacking.patientSearchResults=null;
    siteDoctorBacking.searchedPatientBean=null;
    response.sendRedirect("../patients.jsp?results=invalidParams");
}
        */
%>