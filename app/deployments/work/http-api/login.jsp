

<%@page import="beans.SettingsBean"%>
<%@page import="tools.ApiHelper"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="beans.MedicalCaseBeanApi"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>
<%@page import="tools.RisLogger"%>
<%@page import="tools.DBHelper"%>
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
String username=request.getParameter("username");
String password=request.getParameter("password");

//set client info
String clientInfo = "Client Info:\r\n";
clientInfo+="Remote Address: "+request.getRemoteAddr()+"\r\n";
clientInfo+="Remote Host "+request.getRemoteHost()+"\r\n";
clientInfo+="Remote User "+request.getRemoteUser()+"\r\n";
clientInfo+="Server Name: "+request.getServerName()+"\r\n";
//clientInfo+="Request URI: "+request.getRequestURI()+"\r\n";
//clientInfo+="Servlet Path: "+request.getServletPath()+"\r\n";
clientInfo+="Request URL: "+request.getRequestURL()+"?"+request.getQueryString()+"\r\n";

String userInfo = "User Info: ";

//check parameters
if(username!=null && username.trim().length()>0 && password!=null && password.trim().length()>0)
{
    userInfo += username+"";
    accountBean apiAccountBean=DBH.checkLogin(username.trim(),password.trim());
    if(apiAccountBean!=null)
    {
        if(apiAccountBean.getRoleBean().getRoleName().equalsIgnoreCase("sitedoctor") || 
           apiAccountBean.getRoleBean().getRoleName().equalsIgnoreCase("paramedic"))
        {
            responseMessage=ApiHelper.getApiSessionId(apiAccountBean);
            
            if(apiAccountBean.getSipConference()!=null && apiAccountBean.getSipConference().length()>0 && 
               apiAccountBean.getSipConference().equalsIgnoreCase("null")==false)
            {
                responseMessage+=";"+apiAccountBean.getSipConference();
            }
            else
            {
                responseMessage+=";";
            }
            
            if(apiAccountBean.getSipMedical()!=null && apiAccountBean.getSipMedical().length()>0 && 
               apiAccountBean.getSipMedical().equalsIgnoreCase("null")==false)
            {
                responseMessage+=";"+apiAccountBean.getSipMedical();
            }
            else
            {
                responseMessage+=";";
            }
            
            if(apiAccountBean.getJabberAccount()!=null && apiAccountBean.getJabberAccount().length()>0 && 
               apiAccountBean.getJabberAccount().equalsIgnoreCase("null")==false)
            {
                responseMessage+=";"+apiAccountBean.getJabberAccount();
            }
            else
            {
                responseMessage+=";";
            }
        }
        else
        {
            responseMessage="ERROR:NO_SITE_DOCTOR_OR_PARAMEDIC_ACCOUNT";
        }
    }
    else
    {
        responseMessage="ERROR:UNKNOWN_ACCOUNT";
    }
}
else
{
    responseMessage="ERROR:NO_ACCOUNT_INFO";
}

out.println(responseMessage);

//if(userInfo.contains("User Info: test")==false)
//{
    RisLogger.addLogRecord("HTTP-API\r\n\r\n"+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);
//}

DBH=null;

%>

