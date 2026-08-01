<%@page import="beans.CountryBean"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="backings.SiteDoctorBacking"%>
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
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");

HashMap<String, String> fieldsMap=new HashMap<String, String>();
HashMap<String, FileItem> filesMap=new HashMap<String, FileItem>();

ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
servletFileUpload.setHeaderEncoding("UTF-8");
List<FileItem> items = servletFileUpload.parseRequest(request);
for (FileItem item : items) 
{
    if (item.isFormField()) 
    {
        // Process regular form field (input type="text|radio|checkbox|etc", select, etc).
        String fieldname = item.getFieldName();
        String fieldvalue = item.getString("UTF-8");
        fieldsMap.put(fieldname, fieldvalue);
    } 
    else 
    {
        // Process form file field (input type="file").
        String fieldname = item.getFieldName();
        String filename = FilenameUtils.getName(item.getName());
        filesMap.put(fieldname,item);
    }
}

//get new patient fields
request.setCharacterEncoding("UTF-8");
String patName=fieldsMap.get("patName");//request.getParameter("patName").trim();
String patSurname=fieldsMap.get("patSurname");//request.getParameter("patSurname").trim();
String patFathersName=fieldsMap.get("patFathersName");//request.getParameter("patFathersName").trim();
String birthMonth=fieldsMap.get("monthObPicker");//request.getParameter("monthObPicker").trim();
String birthDay=fieldsMap.get("dayObPicker");//request.getParameter("dayObPicker").trim();
String birthYear=fieldsMap.get("yearObPicker");//request.getParameter("yearObPicker").trim();
byte[] patDeclarationFileBytes = filesMap.get("patDeclarationFile").get();
String declarationFileName=filesMap.get("patDeclarationFile").getName();
byte[] patPhotoFileBytes = filesMap.get("patPhotoFile").get();
String patPhotoFileName=filesMap.get("patPhotoFile").getName();
String patDocDeclaration=fieldsMap.get("patDocDeclaration");
String patAddressStreet=fieldsMap.get("patAddressStreet");
String patAddressNumber=fieldsMap.get("patAddressNumber");
String patAddressArea=fieldsMap.get("patAddressArea");
String patAddressZip=fieldsMap.get("patAddressZip");
String patNationalityId=fieldsMap.get("patNationalityId");

CountryBean selectedCountryBean=null;
if(patNationalityId!=null && patNationalityId.length()>0)
{
    for(CountryBean curCountryBean : siteDoctorBacking.getAllCountriesAndNationalitiesList())
    {
        if(curCountryBean.getId().equals(patNationalityId))
        {
            selectedCountryBean=curCountryBean;
            break;
        }
    }
}


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
if(fieldsMap.get("patSex")!=null)
{
    patSex=fieldsMap.get("patSex").trim();
}
//String patAddress=fieldsMap.get("patAddress");//request.getParameter("patAddress").trim();
String patHomePhone=fieldsMap.get("patHomePhone");//request.getParameter("patHomePhone").trim();
String patWorkPhone=fieldsMap.get("patWorkPhone");//request.getParameter("patWorkPhone").trim();
String patMobilePhone=fieldsMap.get("patMobilePhone");//request.getParameter("patMobilePhone").trim();
String patSSN=fieldsMap.get("patSSN");//request.getParameter("patSSN").trim();
String patInsuranceName=fieldsMap.get("patInsuranceName");//request.getParameter("patInsuranceName").trim();

String patOtherIdentifier=fieldsMap.get("patOtherIdentifier");//request.getParameter("patOtherIdentifier").trim();

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
        response.sendRedirect("../addNewPatient.jsp");
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
        siteDoctorBacking.infoMessage=langBacking.getLiteral("SSN or OTHER");
        response.sendRedirect("../addNewPatient.jsp");
    }
}

if(shouldProceed)
{
    if(patName!=null && patName.length()>0 && patSurname!=null && patSurname.length()>0 && patFathersName!=null && patFathersName.length()>0 &&
       birthDate!=null && patSurname.length()>0 && patSex!=null && patSex.length()>0 && selectedCountryBean!=null && 
       ((patDeclarationFileBytes!=null && patDeclarationFileBytes.length>0) || 
       (patDocDeclaration!=null && patDocDeclaration.equalsIgnoreCase("on"))) )
    {
        //get siteid for this patient. SB is included in accountBean.
        accountBean AB=(accountBean)session.getAttribute("AB");

        //create new patient bean
        patBean patientBean=new patBean("", patName, patSurname, patFathersName, patSex, patHomePhone, patWorkPhone, patMobilePhone, patSSN, patInsuranceName,AB.SB.id,patOtherIdentifier,"false");
        patientBean.birthDate=birthDate;
        patientBean.setDeclarationFileBytes(patDeclarationFileBytes);
        patientBean.setDeclarationFileName(declarationFileName);
        patientBean.setPhotoFileBytes(patPhotoFileBytes);
        patientBean.setPhotoFileName(patPhotoFileName);
        patientBean.setAddressStreet(patAddressStreet);
        patientBean.setAddressNumber(patAddressNumber);
        patientBean.setAddressArea(patAddressArea);
        patientBean.setAddressZip(patAddressZip);
        patientBean.setCountryBean(selectedCountryBean);
        
        if(ssnSubmitted && ssnValid)
        {
            if(siteDoctorBacking.ssnExists(patSSN,null)==false)
            {
                //insert new patient to DB table
                if(siteDoctorBacking.insertNewPatient(patientBean)==true)
                {
                    //if success response OK 
                    siteDoctorBacking.okMessage=langBacking.getLiteral("new_patient_saved");
                    response.sendRedirect("../patients.jsp");
                }
                else
                {
                    //if failed response ERROR 
                    siteDoctorBacking.errorMessage=langBacking.getLiteral("add_patient_failed");
                    response.sendRedirect("../addNewPatient.jsp");
                }
            }
            else
            {
                siteDoctorBacking.infoMessage=langBacking.getLiteral("ssn_exists");
                response.sendRedirect("../addNewPatient.jsp");
            }
        }
        else
        {
            //insert new patient to DB table
            if(siteDoctorBacking.insertNewPatient(patientBean)==true)
            {
                //if success response OK 
                siteDoctorBacking.okMessage=langBacking.getLiteral("new_patient_saved");
                response.sendRedirect("../patients.jsp");
            }
            else
            {
                //if failed response ERROR 
                siteDoctorBacking.errorMessage=langBacking.getLiteral("add_patient_failed");
                response.sendRedirect("../addNewPatient.jsp");
            }
        }
    }
    else
    {
        siteDoctorBacking.infoMessage=langBacking.getLiteral("edit_patient_required_fields");
        response.sendRedirect("../addNewPatient.jsp");
    }
}
%>