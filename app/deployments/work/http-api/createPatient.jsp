

<%@page import="beans.SettingsBean"%>
<%@page import="beans.ApiSessionBean"%>
<%@page import="beans.CountryBean"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="beans.patBean"%>
<%@page import="tools.ApiHelper"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="beans.MedicalCaseBeanApi"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>
<%@page import="tools.RisLogger"%>
<%@page import="tools.DBHelper"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

String responseMessage="";

request.setCharacterEncoding("UTF-8");

DBHelper DBH=new DBHelper();

//init settings
SettingsBean allSettings = DBH.getAllSettings();

//init Logger
RisLogger.setFromMailAddress(allSettings.getParameter("fromMailAddress"));
RisLogger.setFromMailPassword(allSettings.getParameter("fromMailPassword"));
RisLogger.setHostAddress(allSettings.getParameter("hostAddress"));
RisLogger.setLdap(allSettings.getParameter("ldap"));
RisLogger.setMailActive(allSettings.getParameter("mailActive"));
RisLogger.setMailSubject(allSettings.getParameter("mailSubject"));
RisLogger.setToMailAddresses(allSettings.getParameter("toMailAddresses"));


HashMap<String, String> fieldsMap=new HashMap<String, String>();
HashMap<String, FileItem> filesMap=new HashMap<String, FileItem>();
ServletFileUpload servletFileUpload = new ServletFileUpload(new DiskFileItemFactory());
try
{
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
}
catch(Exception e)
{
    //an h forma den exei photo mesa den tha einai multipart klp. ara tha prepei na ta paroume apo to request.
    //parola ayta, epeidi sto mellon mporei na zitithei na mpei k h foto or kapoio arxeio tha kratisoyme to fieldsMap.
    fieldsMap.put("apiSessionId", request.getParameter("apiSessionId"));
    fieldsMap.put("name", request.getParameter("name"));
    fieldsMap.put("surname", request.getParameter("surname"));
    fieldsMap.put("fathersName", request.getParameter("fathersName"));
    fieldsMap.put("birthDate", request.getParameter("birthDate"));
    fieldsMap.put("gender", request.getParameter("gender"));
    fieldsMap.put("addressStreet", request.getParameter("addressStreet"));
    fieldsMap.put("addressNumber", request.getParameter("addressNumber"));
    fieldsMap.put("addressArea", request.getParameter("addressArea"));
    fieldsMap.put("addressZip", request.getParameter("addressZip"));
    fieldsMap.put("nationalityId", request.getParameter("nationalityId"));
    fieldsMap.put("homePhone", request.getParameter("homePhone"));
    fieldsMap.put("workPhone", request.getParameter("workPhone"));
    fieldsMap.put("mobilePhone", request.getParameter("mobilePhone"));
    fieldsMap.put("ssn", request.getParameter("ssn"));
    fieldsMap.put("insuranceName", request.getParameter("insuranceName"));
    fieldsMap.put("otherIdentifier", request.getParameter("otherIdentifier"));
    fieldsMap.put("lang", request.getParameter("lang"));
}
//get new patient fields
request.setCharacterEncoding("UTF-8");
String apiSessionId=fieldsMap.get("apiSessionId");
String patName=fieldsMap.get("name");//request.getParameter("patName").trim();
String patSurname=fieldsMap.get("surname");//request.getParameter("patSurname").trim();
String patFathersName=fieldsMap.get("fathersName");//request.getParameter("patFathersName").trim();
String birthDate=fieldsMap.get("birthDate");
String patGender=fieldsMap.get("gender");

String patAddressStreet=fieldsMap.get("addressStreet");
String patAddressNumber=fieldsMap.get("addressNumber");
String patAddressArea=fieldsMap.get("addressArea");
String patAddressZip=fieldsMap.get("addressZip");
String patNationalityId=fieldsMap.get("nationalityId");
String patHomePhone=fieldsMap.get("homePhone");//request.getParameter("patHomePhone").trim();
String patWorkPhone=fieldsMap.get("workPhone");//request.getParameter("patWorkPhone").trim();
String patMobilePhone=fieldsMap.get("mobilePhone");//request.getParameter("patMobilePhone").trim();
String patSSN=fieldsMap.get("ssn");//request.getParameter("patSSN").trim();
String patInsuranceName=fieldsMap.get("insuranceName");//request.getParameter("patInsuranceName").trim();
String patOtherIdentifier=fieldsMap.get("otherIdentifier");
String lang=fieldsMap.get("lang");

//patInsuranceName=patInsuranceName.replaceAll("'", "\"");
//patHomePhone=patHomePhone.replaceAll("\r\n", ", ");
//patWorkPhone=patWorkPhone.replaceAll("'", "\"");
//patMobilePhone=patMobilePhone.replaceAll("'", "\"");
//patSSN=patSSN.replaceAll("\r\n", ", ");

//set client info
String clientInfo = "Client Info:\r\n";
clientInfo+="Remote Address: "+request.getRemoteAddr()+"\r\n";
clientInfo+="Remote Host "+request.getRemoteHost()+"\r\n";
clientInfo+="Remote User "+request.getRemoteUser()+"\r\n";
clientInfo+="Server Name: "+request.getServerName()+"\r\n";
//clientInfo+="Request URI: "+request.getRequestURI()+"\r\n";
//clientInfo+="Servlet Path: "+request.getServletPath()+"\r\n";
clientInfo+="Request URL: "+request.getRequestURL()+"?"+request.getQueryString()+"\r\n";
String userInfo = "";

//check parameters
if(apiSessionId!=null && apiSessionId.trim().length()>0)
{
    userInfo += "apiSessionId: "+apiSessionId+"\r\n";
    
    ApiSessionBean curApiSession = ApiHelper.checkApiSessionId(apiSessionId);

    if(curApiSession!=null)
    {
        userInfo += "Username: "+curApiSession.getApiAccount().username+"\r\n";
        userInfo += "User full name: "+curApiSession.getApiAccount().getFullName()+"";
    
        Date birthDateObj = null;
        try
        {
            if(birthDate!=null && birthDate.length()>0)
            {
                birthDateObj=new Date(Long.parseLong(birthDate));
            }
        }
        catch(Exception e)
        {
            birthDateObj = null;
        }

        if(birthDateObj!=null)
        {
            CountryBean patCountryBean = null;
            if(ApiHelper.allCountries==null || ApiHelper.allCountries.size()==0)
            {
                //fill ApiHelper.allCountries
                ApiHelper.allCountries=DBH.getAllCountriesAndNationalities(lang);
            }
            patCountryBean = ApiHelper.getCountryBean(patNationalityId);

            if(patCountryBean!=null)
            {
                if(patGender!=null && (patGender.equalsIgnoreCase("male") || patGender.equalsIgnoreCase("female")))
                {
                    try
                    {
                        if(patSSN!=null && patSSN.length()==11)
                        {
                            String ssn1=patSSN.substring(0,8);
                            String ssn2=patSSN.substring(8,patSSN.length());
                            Integer.parseInt(ssn1);
                            Integer.parseInt(ssn2);
                        }
                        else if(patSSN!=null && patSSN.length()==0)
                        {
                            //to amka apla den to gemise
                        }
                        else if(patSSN==null)
                        {
                            //to amka den to esteile
                            patSSN="";
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

                    if(patSSN!=null)
                    {
                        ArrayList<String> patientIdsWithThisSsn=new ArrayList<String>(0);
                        if(patSSN!=null && patSSN.length()>0)
                        {
                            patientIdsWithThisSsn=DBH.ssnExists(patSSN);
                        }
                        
                        if(patientIdsWithThisSsn!=null && patientIdsWithThisSsn.size()==0)
                        {
                            if(patName!=null && patName.length()>0 && patSurname!=null && patSurname.length()>0 && patFathersName!=null && 
                            patFathersName.length()>0 && birthDateObj!=null && patSurname.length()>0 && patGender!=null && patGender.length()>0 && 
                            patCountryBean!=null )
                            {
                                //get siteid for this patient. SB is included in accountBean.
                                accountBean AB = curApiSession.getApiAccount();

                                //create new patient bean
                                patBean patientBean=new patBean("", patName, patSurname, patFathersName, patGender, patHomePhone, patWorkPhone, patMobilePhone, patSSN, patInsuranceName,AB.SB.id,patOtherIdentifier,"false");
                                patientBean.birthDate=birthDateObj;
                                patientBean.setAddressStreet(patAddressStreet);
                                patientBean.setAddressNumber(patAddressNumber);
                                patientBean.setAddressArea(patAddressArea);
                                patientBean.setAddressZip(patAddressZip);
                                patientBean.setCountryBean(patCountryBean);

                                //insert new patient to DB table
                                String newPatId=DBH.insertNewPatient(patientBean);
                                if(newPatId!=null && newPatId.length()>0)
                                {
                                    //return new patientId
                                    responseMessage=newPatId;
                                }
                                else
                                {
                                    responseMessage="ERROR:NEW_PATIENT_FAILED_TO_BE_SAVED";
                                }
                            }
                            else
                            {
                                responseMessage="ERROR:MISSING_REQUIRED_FIELDS";
                            }
                        }
                        else
                        {
                            responseMessage="ERROR:SSN_EXISTS";
                        }
                    }
                    else
                    {
                        responseMessage="ERROR:INVALID_SSN";
                    }
                }
                else
                {
                    responseMessage="ERROR:INVALID_GENDER";
                }
            }
            else
            {
                responseMessage="ERROR:INVALID_NATIONALITY";
            }
        }
        else
        {
            responseMessage="ERROR:INVALID_BIRTH_DATE";
        }
    }
    else
    {
        responseMessage="ERROR:INVALID_API_SESSION_ID";
    }
}
else
{
    responseMessage="ERROR:MISSING_API_SESSION_ID";
}




out.println(responseMessage);

RisLogger.addLogRecord("HTTP-API\r\n\r\nResponse: "+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);


DBH=null;

%>

