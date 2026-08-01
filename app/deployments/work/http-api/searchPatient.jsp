

<%@page import="beans.SettingsBean"%>
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

//capture parameters
String apiSessionId=request.getParameter("apiSessionId");
String name=request.getParameter("name");
String surname=request.getParameter("surname");
String ssn=request.getParameter("ssn");
String mobilePhone=request.getParameter("mobilePhone");
String homePhone=request.getParameter("homePhone");
String birthDate=request.getParameter("birthDate");
String fathersName=request.getParameter("fathersName");

//set client info
String clientInfo = "Client Info:\r\n";
clientInfo+="Remote Address: "+request.getRemoteAddr()+"\r\n";
clientInfo+="Remote Host "+request.getRemoteHost()+"\r\n";
clientInfo+="Remote User "+request.getRemoteUser()+"\r\n";
clientInfo+="Server Name: "+request.getServerName()+"\r\n";
//clientInfo+="Request URI: "+request.getRequestURI()+"\r\n";
//clientInfo+="Servlet Path: "+request.getServletPath()+"\r\n";
clientInfo+="Request URL: "+request.getRequestURL()+"?"+request.getQueryString()+"\r\n";

String userInfo = "apiSessionId: ";

//check parameters
if(apiSessionId!=null && apiSessionId.trim().length()>0)
{
    userInfo += apiSessionId+"";
    
    if(ApiHelper.checkApiSessionId(apiSessionId)!=null)
    {
        try
        {
            if( (name!=null && name.length()>2) || (surname!=null && surname.length()>2) || (birthDate!=null && birthDate.length()>0) || 
                (ssn!=null && ssn.length()>0) || (mobilePhone!=null && mobilePhone.length()>0) || (homePhone!=null && homePhone.length()>0) ||
                (fathersName!=null && fathersName.length()>0) )
            {
                patBean patientToSearch=new patBean("", name, surname, fathersName, "", homePhone, "", mobilePhone, ssn, "", "", "", "");
                if(birthDate!=null && birthDate.length()>0)
                {
                    patientToSearch.birthDate=new Date(Long.parseLong(birthDate));
                }
                else
                {
                    patientToSearch.birthDate=null;
                }

                JSONArray jsonPatients = new JSONArray();
                ArrayList<patBean> patientResultsList = DBH.searchPatientsFromAllSites(patientToSearch);
                for(patBean curPatient : patientResultsList)
                {
                    try
                    {
                        JSONObject curPatJsonObj = new JSONObject();
                        curPatJsonObj.put("id",curPatient.getId());
                        curPatJsonObj.put("name",curPatient.name);
                        curPatJsonObj.put("surname",curPatient.surname);
                        curPatJsonObj.put("birthDate",curPatient.getBirthDateLong());
                        curPatJsonObj.put("fathersName",curPatient.getFathersName());
                        curPatJsonObj.put("homephone",curPatient.getHomephone());
                        curPatJsonObj.put("insuranceName",curPatient.getInsurancename());
                        curPatJsonObj.put("mobilePhone",curPatient.getMobilephone());
                        curPatJsonObj.put("otherIdentifier",curPatient.getOtherIdentifier());
                        curPatJsonObj.put("gender",curPatient.getSex());
                        curPatJsonObj.put("workPhone",curPatient.getWorkphone());
                        curPatJsonObj.put("ssn",curPatient.getSsn());
                        curPatJsonObj.put("nationalityId",curPatient.getCountryBean().getId());
                        jsonPatients.add(curPatJsonObj);
                    }
                    catch(Exception e)
                    {
                        e.printStackTrace();
                    }
                }
                JSONObject jsonObjResponse = new JSONObject();
                jsonObjResponse.put("patients",jsonPatients);
                responseMessage=jsonObjResponse.toString();
            }
            else
            {
                responseMessage="ERROR:SEARCH_CRITERIA_MISSING";
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            responseMessage="ERROR:UNEXPECTED_ERROR:"+e.getMessage();
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

RisLogger.addLogRecord("HTTP-API\r\n\r\n"+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);

DBH=null;

%>

