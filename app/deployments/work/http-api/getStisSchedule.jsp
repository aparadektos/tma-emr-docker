

<%@page import="beans.SettingsBean"%>
<%@page import="beans.TeleAppointmentBean"%>
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
String stisId=request.getParameter("stisId");
String startDateTime=request.getParameter("startDateTime");
String endDateTime=request.getParameter("endDateTime");

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
            if(stisId!=null && stisId.length()>0 && startDateTime!=null && startDateTime.length()>0 && 
               endDateTime!=null && endDateTime.length()>0)
            {
                Date startDate = null;
                Date endDate = null;
                try
                {
                    startDate=new Date(Long.parseLong(startDateTime));
                    endDate=new Date(Long.parseLong(endDateTime));
                }
                catch(Exception e)
                {
                    e.printStackTrace();
                }
                
                if(startDate!=null && endDate!=null)
                {
                    ArrayList<TeleAppointmentBean> scheduledTeleApps = DBH.getStisSchedule(stisId, startDate, endDate);
                    JSONArray jsonStisSchedule = new JSONArray();
                    for(TeleAppointmentBean curTeleApp : scheduledTeleApps)
                    {
                        JSONObject curTeleAppJsonObj = new JSONObject();
                        curTeleAppJsonObj.put("startDateTime",curTeleApp.getStartdatetime().getTime());
                        curTeleAppJsonObj.put("endDateTime",curTeleApp.getEnddatetime().getTime());
                        curTeleAppJsonObj.put("status",curTeleApp.getStatus());
                        curTeleAppJsonObj.put("emergency",curTeleApp.getEmergency());
                        curTeleAppJsonObj.put("stisId1",curTeleApp.getStisBean1().getId());
                        curTeleAppJsonObj.put("stisId2",curTeleApp.getStisBean2().getId());
                        jsonStisSchedule.add(curTeleAppJsonObj);
                    }
                    JSONObject jsonObjResponse = new JSONObject();
                    jsonObjResponse.put("stisSchedule",jsonStisSchedule);
                    responseMessage=jsonObjResponse.toString();
                }
                else
                {
                    responseMessage="ERROR:INVALID_DATE_TIME";
                }
            }
            else
            {
                responseMessage="ERROR:MISSING_REQUIRED_FIELDS";
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

