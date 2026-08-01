

<%@page import="beans.SettingsBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="beans.EmergencyCaseBean"%>
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
String teleAppReadableId=request.getParameter("teleAppReadableId");
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

if(apiSessionId!=null && apiSessionId.trim().length()>0 && teleAppReadableId!=null && teleAppReadableId.length()>0)
{
    userInfo += "apiSessionId: "+apiSessionId+"\r\n";
    ApiSessionBean curApiSession = ApiHelper.checkApiSessionId(apiSessionId);
    if(curApiSession!=null)
    {
        userInfo += "Username: "+curApiSession.getApiAccount().username+"\r\n";
        userInfo += "User full name: "+curApiSession.getApiAccount().getFullName()+"";
        
        try
        {
            TeleAppointmentBean erTeleApp = DBH.getTeleAppointmentByReadableId(teleAppReadableId);
            
            if(erTeleApp!=null && erTeleApp.getId()!=null && erTeleApp.getId().length()>0)
            {
                JSONObject curErTeleAppOverviewJsonObj = new JSONObject();
                curErTeleAppOverviewJsonObj.put("teleAppReadableId",erTeleApp.getReadableId());
                curErTeleAppOverviewJsonObj.put("patientId",erTeleApp.getPatientBean().getId());
                curErTeleAppOverviewJsonObj.put("consultantId",erTeleApp.getConsultantBean1().getId());
                curErTeleAppOverviewJsonObj.put("siteId",erTeleApp.getSB().getId());
                curErTeleAppOverviewJsonObj.put("startDateTime",erTeleApp.getStartdatetime().getTime());
                curErTeleAppOverviewJsonObj.put("teleAdvice",erTeleApp.getTeleAdvice());

                responseMessage=curErTeleAppOverviewJsonObj.toString();
            }
            else
            {
                responseMessage="ERROR:INVALID_EMERGENCY_CASE";
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
    responseMessage="ERROR:MISSING_REQUIRED_FIELDS";
}

out.println(responseMessage);

RisLogger.addLogRecord("HTTP-API\r\n\r\n"+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);

DBH=null;

%>

