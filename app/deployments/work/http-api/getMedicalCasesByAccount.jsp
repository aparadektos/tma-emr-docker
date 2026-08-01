

<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="beans.MedicalCaseBeanApi"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>
<%@page import="tools.RisLogger"%>
<%@page import="tools.DBHelper"%>
<%

    
    /*
String responseMessage="";

request.setCharacterEncoding("UTF-8");

DBHelper DBH=new DBHelper();

RisLogger.logSettings=DBH.getSettings();

//capture parameters
String username=request.getParameter("username");
String password=request.getParameter("password");

//set client info
String clientInfo = "Client Info:\r\n";
clientInfo+="Remote Address: "+request.getRemoteAddr()+"\r\n";
clientInfo+="Remote Host "+request.getRemoteHost()+"\r\n";
clientInfo+="Remote User "+request.getRemoteUser()+"\r\n";
clientInfo+="Server Name: "+request.getServerName()+"\r\n";
clientInfo+="Request URL: "+request.getRequestURL()+"\r\n";

String userInfo = "User Info: ";

//check parameters
if(username!=null && username.trim().length()>0 && password!=null && password.trim().length()>0)
{
    userInfo += username+"";
    accountBean accountBean=DBH.checkLogin(username.trim(),password.trim());
    if(accountBean!=null)
    {
        if(accountBean.getRoleBean().getRoleName().equalsIgnoreCase("sitedoctor"))
        {
            JSONArray jsonCases = new JSONArray();
            ArrayList<MedicalCaseBeanApi> appointmentsList = DBH.getTeleAppointmentsByAccountForApi(accountBean.id);
            for(MedicalCaseBeanApi curCase : appointmentsList)
            {
                JSONObject jObj = new JSONObject();
                jObj.put("readableId",curCase.getReadableId());
                jObj.put("type",curCase.getType());
                jObj.put("dateTime",curCase.getStartDateTime());
                jsonCases.add(jObj);
            }
            ArrayList<MedicalCaseBeanApi> emergenciesList = DBH.getEmergenciesByAccountForApi(accountBean.id);
            for(MedicalCaseBeanApi curCase : emergenciesList)
            {
                JSONObject jObj = new JSONObject();
                jObj.put("readableId",curCase.getReadableId());
                jObj.put("type",curCase.getType());
                jObj.put("dateTime",curCase.getStartDateTime());
                jsonCases.add(jObj);
            }
            JSONObject jsonObjResponse = new JSONObject();
            jsonObjResponse.put("cases",jsonCases);
            responseMessage=jsonObjResponse.toString();
        }
        else
        {
            responseMessage="ERROR:NO_SITE_DOCTOR_ACCOUNT";
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

RisLogger.addLogRecord("HTTP-API\r\n\r\n"+responseMessage+"\r\n\r\n"+userInfo+"\r\n\r\n"+clientInfo,null);

DBH.closeConnection();
DBH=null;

            
            */
%>

