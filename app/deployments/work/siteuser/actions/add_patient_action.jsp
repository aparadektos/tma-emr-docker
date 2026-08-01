<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="beans.UserHistoryBean"%>
<%@page import="java.util.Date"%>
<%@page import="beans.timeslotBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteUserBacking siteUserBacking = (SiteUserBacking)session.getAttribute("siteUserBacking");

//get new patient fields
request.setCharacterEncoding("UTF-8");
String patName=request.getParameter("patName").trim();
String patSurname=request.getParameter("patSurname").trim();
String patFathersName=request.getParameter("patFathersName").trim();
String birthMonth=request.getParameter("monthObPicker").trim();
String birthDay=request.getParameter("dayObPicker").trim();
String birthYear=request.getParameter("yearObPicker").trim();

Date birthDate=null;
String birthDateStr="";
try
{
    birthDate=new Date(Integer.parseInt(birthYear)-1900,Integer.parseInt(birthMonth)-1,Integer.parseInt(birthDay));
    birthDateStr=birthDate.getTime()+"";
}
catch(Exception e)
{
    birthDate=null;
}


String patSex=null;
if(request.getParameter("patSex")!=null)
{
    patSex=request.getParameter("patSex").trim();
}
String patAddress=request.getParameter("patAddress").trim();
String patHomePhone=request.getParameter("patHomePhone").trim();
String patWorkPhone=request.getParameter("patWorkPhone").trim();
String patMobilePhone=request.getParameter("patMobilePhone").trim();
String patSSN=request.getParameter("patSSN").trim();
String patInsuranceName=request.getParameter("patInsuranceName").trim();

String patOtherIdentifier=request.getParameter("patOtherIdentifier").trim();

//replace special chars
patAddress=patAddress.replaceAll("\r\n", ", ");
patInsuranceName=patInsuranceName.replaceAll("'", "\"");
patHomePhone=patHomePhone.replaceAll("\r\n", ", ");
patWorkPhone=patWorkPhone.replaceAll("'", "\"");
patMobilePhone=patMobilePhone.replaceAll("'", "\"");
patSSN=patSSN.replaceAll("\r\n", ", ");

try
{
    if(patSSN!=null && patSSN.length()>=11 && patSSN.length()<=18)
    {
        String ssn1=patSSN.substring(0,8);
        String ssn2=patSSN.substring(8,patSSN.length());
        Integer.parseInt(ssn1);
        Integer.parseInt(ssn2);
    }
    else
    {
        patSSN=null;
    }
}
catch(Exception e)
{
    patSSN=null;
}

//validate ssn
if(patSSN!=null && patSSN.length()>=11 && patSSN.length()<=18)
{
//validate fields
    if(patName!=null && patName.length()>0 && patSurname!=null && patSurname.length()>0 && patFathersName!=null && patFathersName.length()>0 &&
            birthDate!=null && patSurname.length()>0 && patSex!=null && patSex.length()>0)
    {
        //get siteid for this patient. SB is included in accountBean.
        accountBean AB=(accountBean)session.getAttribute("AB");

        //create new patient bean 
        patBean patientBean=new patBean("", patName, patSurname, patFathersName, patSex, patHomePhone, patWorkPhone, patMobilePhone, patSSN, patInsuranceName,AB.SB.id,patOtherIdentifier,"false");
        patientBean.birthDate=birthDate;

        if(patSSN!=null && patSSN.length()>0)
        {
            if(siteUserBacking.ssnExists(patSSN,null)==false)
            {
                //insert new patient to DB table
                if(siteUserBacking.insertNewPatient(patientBean)==true)
                {
                    //if success response OK 
                    siteUserBacking.okMessage=langBacking.getLiteral("new_patient_saved");
                    response.sendRedirect("../patients.jsp");
                }
                else
                {
                    //if failed response ERROR 
                    siteUserBacking.errorMessage=langBacking.getLiteral("add_patient_failed");
                    response.sendRedirect("../addNewPatient.jsp");
                }
            }
            else
            {
                siteUserBacking.infoMessage=langBacking.getLiteral("ssn_exists");
                response.sendRedirect("../addNewPatient.jsp");
            }
        }
        else
        {
            //insert new patient to DB table
            if(siteUserBacking.insertNewPatient(patientBean)==true)
            {
                //if success response OK 
                siteUserBacking.okMessage=langBacking.getLiteral("new_patient_saved");
                response.sendRedirect("../patients.jsp");
            }
            else
            {
                //if failed response ERROR 
                siteUserBacking.errorMessage=langBacking.getLiteral("add_patient_failed");
                response.sendRedirect("../addNewPatient.jsp");
            }
        }
    }
    else
    {
        siteUserBacking.infoMessage=langBacking.getLiteral("add_patient_required_fields");
        response.sendRedirect("../addNewPatient.jsp");
    }
}
else
{
    siteUserBacking.infoMessage=langBacking.getLiteral("ssn_format");
    response.sendRedirect("../addNewPatient.jsp");
}
%>