

<%@page import="beans.SettingsBean"%>
<%@page import="beans.EfimeriaBean"%>
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
        
        ArrayList<EfimeriaBean> efimeriesResults = DBH.findAvailableEfimeriesForEmergency();
        if(efimeriesResults!=null)
        {
            JSONArray jsonEfimeries = new JSONArray();
            for(EfimeriaBean curEfimeria : efimeriesResults)
            {
                JSONObject curEfimeriaJsonObj = new JSONObject();
                curEfimeriaJsonObj.put("efimeriaId",curEfimeria.getId());
                curEfimeriaJsonObj.put("startDateTime",curEfimeria.getStartDateTime().getTime());
                curEfimeriaJsonObj.put("endDateTime",curEfimeria.getEndDateTime().getTime());
                
                JSONObject curConsultantJsonObj = new JSONObject();
                curConsultantJsonObj.put("consultantId",curEfimeria.getConsultantBean().getId());
                curConsultantJsonObj.put("name",curEfimeria.getConsultantBean().getName());
                curConsultantJsonObj.put("surname",curEfimeria.getConsultantBean().getSurname());
                accountBean consultantAcc = DBH.getAccountById(curEfimeria.getConsultantBean().getAccountId());
                curConsultantJsonObj.put("sipConference", consultantAcc.getSipConference());
                curConsultantJsonObj.put("sipMedical", consultantAcc.getSipMedical());
                curConsultantJsonObj.put("jabberAccount", consultantAcc.getJabberAccount());
                
                JSONObject curSpecialtyJsonObj = new JSONObject();
                curSpecialtyJsonObj.put("specialtyId",curEfimeria.getConsultantBean().getSpecialtyBean().getId());
                curSpecialtyJsonObj.put("name",curEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(lang));
                
                JSONObject curStisJsonObj = new JSONObject();
                curStisJsonObj.put("stisId", curEfimeria.getStisBean().getId());
                curStisJsonObj.put("title", curEfimeria.getStisBean().getTitle());
                curStisJsonObj.put("nosokomeio", curEfimeria.getStisBean().getNosokomeio());
                
                curConsultantJsonObj.put("specialty", curSpecialtyJsonObj);
                curEfimeriaJsonObj.put("consultant", curConsultantJsonObj);
                curEfimeriaJsonObj.put("stis", curStisJsonObj);
                
                jsonEfimeries.add(curEfimeriaJsonObj);
            }
            
            JSONObject jsonObjResponse = new JSONObject();
            jsonObjResponse.put("efimeries",jsonEfimeries);
            responseMessage=jsonObjResponse.toString();
        }
        else
        {
            responseMessage="ERROR:UNEXPECTED_ERROR";
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

if(userInfo.contains("User Info: test")==false)
{
    RisLogger.addLogRecord("HTTP-API\r\n\r\n"+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);
}

DBH=null;

%>

