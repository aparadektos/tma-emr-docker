<%@page import="backings.LanguageBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
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
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

//get new patient fields
request.setCharacterEncoding("UTF-8");
String patId=request.getParameter("patId").trim();
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
//String patAddress=request.getParameter("patAddress").trim();
String patHomePhone=request.getParameter("patHomePhone").trim();
String patWorkPhone=request.getParameter("patWorkPhone").trim();
String patMobilePhone=request.getParameter("patMobilePhone").trim();
String patSSN=request.getParameter("patSSN").trim();
String patInsuranceName=request.getParameter("patInsuranceName").trim();
String patOtherIdentifier=request.getParameter("patOtherIdentifier").trim();

//replace special chars
//patAddress=patAddress.replaceAll("\r\n", ", ");
patInsuranceName=patInsuranceName.replaceAll("'", "\"");
patHomePhone=patHomePhone.replaceAll("\r\n", ", ");
patWorkPhone=patWorkPhone.replaceAll("'", "\"");
patMobilePhone=patMobilePhone.replaceAll("'", "\"");
patSSN=patSSN.replaceAll("\r\n", ", ");



boolean ssnSubmitted=false;
boolean ssnValid=false;
boolean otherSubmitted=false;

try
{
    if(patSSN!=null && patSSN.length()>0)
    {
        ssnSubmitted=true;
    }
    if(patSSN!=null && patSSN.length()==11)
    {
        String ssn1=patSSN.substring(0,8);
        String ssn2=patSSN.substring(8,patSSN.length());
        Integer.parseInt(ssn1);
        Integer.parseInt(ssn2);
        ssnValid=true;
    }
    else
    {
        ssnValid=false;
        patSSN=null;
    }
}
catch(Exception e)
{
    ssnValid=false;
    patSSN=null;
}

if(patOtherIdentifier!=null && patOtherIdentifier.length()>0)
{
    otherSubmitted=true;
}

boolean shouldProceed=false;
if(ssnSubmitted)
{
    if(ssnValid==false)
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("ssn_format");
        response.sendRedirect("../editPatient.jsp?patId="+patId);
    }
    else
    {
        shouldProceed=true;
    }
}
else
{
    if(otherSubmitted)
    {
        shouldProceed=true;
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("ssn_or_other");
        response.sendRedirect("../editPatient.jsp?patId="+patId);
    }
}

if(shouldProceed)
{
    if(patId!=null && patId.length()>0 && patName!=null && patName.length()>0 && patSurname!=null && patSurname.length()>0 && 
            birthDate!=null && patSurname.length()>0 && patSex!=null && patSex.length()>0 && patFathersName!=null && patFathersName.length()>0)
    {    
        //retrieve old patient bean
        patBean patientBeanToEdit=siteDoctorBacking.getPatientById(patId);
        patientBeanToEdit.name=patName;
        patientBeanToEdit.surname=patSurname;
        patientBeanToEdit.fathersName=patFathersName;
        patientBeanToEdit.birthDate=birthDate;
        patientBeanToEdit.sex=patSex;
//        patientBeanToEdit.address=patAddress;
        patientBeanToEdit.homephone=patHomePhone;
        patientBeanToEdit.workphone=patWorkPhone;
        patientBeanToEdit.mobilephone=patMobilePhone;
        patientBeanToEdit.setSsn(patSSN);
        patientBeanToEdit.insurancename=patInsuranceName;
        patientBeanToEdit.otherIdentifier=patOtherIdentifier;
        patientBeanToEdit.unknown="false";

        if(patSSN!=null && patSSN.length()>0)
        {
            if(siteDoctorBacking.ssnExists(patSSN,patientBeanToEdit.id)==false)
            {
                //update patient to DB table
                if(siteDoctorBacking.updatePatient(patientBeanToEdit)==true)
                {
                    //if success response OK 
                    siteDoctorBacking.okMessage=langBacking.getLiteral("edit_patient_ok");
                    siteDoctorBacking.patientSearchResults=new ArrayList<patBean>(0);
                    siteDoctorBacking.patientSearchResults.add(patientBeanToEdit);
                    response.sendRedirect("../patients.jsp");
                }
                else
                {
                    //if failed response ERROR 
                    siteDoctorBacking.errorMessage=langBacking.getLiteral("edit_patient_failed");
                    response.sendRedirect("../editPatient.jsp?patId="+patId);
                }
            }
            else
            {
                siteDoctorBacking.infoMessage=langBacking.getLiteral("ssn_exists");
                response.sendRedirect("../editPatient.jsp?patId="+patId);
            }
        }
        else
        {
            //update patient to DB table
            if(siteDoctorBacking.updatePatient(patientBeanToEdit)==true)
            {
                //if success response OK 
                siteDoctorBacking.okMessage=langBacking.getLiteral("edit_patient_ok");
                siteDoctorBacking.patientSearchResults=new ArrayList<patBean>(0);
                siteDoctorBacking.patientSearchResults.add(patientBeanToEdit);
                response.sendRedirect("../patients.jsp");
            }
            else
            {
                //if failed response ERROR 
                siteDoctorBacking.errorMessage=langBacking.getLiteral("edit_patient_failed");
                response.sendRedirect("../editPatient.jsp?patId="+patId);
            }
        }
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("edit_patient_required_fields");
        response.sendRedirect("../editPatient.jsp?patId="+patId);
    }
}

%>