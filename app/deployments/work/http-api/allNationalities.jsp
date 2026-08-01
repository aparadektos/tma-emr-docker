

<%@page import="beans.SettingsBean"%>
<%@page import="beans.ApiSessionBean"%>
<%@page import="beans.CountryBean"%>
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
String lang=request.getParameter("lang");
String apiSessionId=request.getParameter("apiSessionId");

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

if(apiSessionId!=null && apiSessionId.trim().length()>0)
{
    userInfo += "apiSessionId: "+apiSessionId+"\r\n";
    ApiSessionBean curApiSession = ApiHelper.checkApiSessionId(apiSessionId);
    if(curApiSession!=null)
    {
        userInfo += "Username: "+curApiSession.getApiAccount().username+"\r\n";
        userInfo += "User full name: "+curApiSession.getApiAccount().getFullName()+"";
        
        ApiHelper.allCountries=DBH.getAllCountriesAndNationalities(lang);

        JSONArray jsonCountries = new JSONArray();
        for(CountryBean curCountry : ApiHelper.allCountries)
        {
            try
            {
                JSONObject curCountryJsonObj = new JSONObject();
                curCountryJsonObj.put("id",curCountry.getId());
                if(lang!=null && lang.equalsIgnoreCase("greek"))
                {
                    curCountryJsonObj.put("country",curCountry.getNameEl());
                    curCountryJsonObj.put("nationality",curCountry.getNationalityEl());
                }
                else
                {
                    curCountryJsonObj.put("country",curCountry.getNameEn());
                    curCountryJsonObj.put("nationality",curCountry.getNationalityEn());
                }
                jsonCountries.add(curCountryJsonObj);
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
        }
        JSONObject jsonObjResponse = new JSONObject();
        jsonObjResponse.put("nationalities",jsonCountries);
        responseMessage=jsonObjResponse.toString();
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

if(userInfo.contains("User Info: test")==false)
{
    RisLogger.addLogRecord("HTTP-API\r\n\r\n"+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);
}

DBH=null;

%>

