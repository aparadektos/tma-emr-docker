

<%@page import="beans.SettingsBean"%>
<%@page import="beans.ApiSessionBean"%>
<%@page import="beans.EmergencyRegistrationFormBean"%>
<%@page import="beans.EmergencyCaseBean"%>
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
String patientId=request.getParameter("patientId");
String name=request.getParameter("name");
String surname=request.getParameter("surname");
String gender=request.getParameter("gender");
String fathersName=request.getParameter("fathersName");
String otherIdentifier=request.getParameter("otherIdentifier");

String erAge=request.getParameter("erAge");
String erProselefsi=request.getParameter("erProselefsi");
String erOros=request.getParameter("erOros");
String erAllo=request.getParameter("erAllo");
    
String histSymptom=request.getParameter("histSymptom");
String histSmoker=request.getParameter("histSmoker");
String histAlergic=request.getParameter("histAlergic");
String histLoimodi=request.getParameter("histLoimodi");

String trauma=request.getParameter("trauma");
    
String vitalTime=request.getParameter("vitalTime");
String vitalPulses=request.getParameter("vitalPulses");
String vitalAP=request.getParameter("vitalAP");
String vitalInhale=request.getParameter("vitalInhale");
String vitalSpo2=request.getParameter("vitalSpo2");
String vitalT=request.getParameter("vitalT");

String derma=request.getParameter("derma");

String erComments=request.getParameter("erComments");

String genikiSimeiologia=request.getParameter("genikiSimeiologia");
String genOther=request.getParameter("genOther");

String xeirourgikiSimeiologia=request.getParameter("xeirourgikiSimeiologia");

String neurologikiSimeiologia=request.getParameter("neurologikiSimeiologia");

String neuroParesi=request.getParameter("neuroParesi");

String neuroHmipligia=request.getParameter("neuroHmipligia");

String neuroSergApoleiaSineidisis=request.getParameter("neuroSergApoleiaSineidisis");
String neuroSergAnoiktoiOfthalmoi=request.getParameter("neuroSergAnoiktoiOfthalmoi");
String neuroSergKalyteriProforikiApantisi=request.getParameter("neuroSergKalyteriProforikiApantisi");
String neuroSergKalyteriKinitikiApantisi=request.getParameter("neuroSergKalyteriKinitikiApantisi");
String neuroSergKoresMegethosAristero=request.getParameter("neuroSergKoresMegethosAristero");
String neuroSergKoresMegethosDeksi=request.getParameter("neuroSergKoresMegethosDeksi");
String neuroSergKoresAntidrasiDeksi=request.getParameter("neuroSergKoresAntidrasiDeksi");
String neuroSergKoresAntidrasiAristero=request.getParameter("neuroSergKoresAntidrasiAristero");
String neuroSergSynoloVathmwn=request.getParameter("neuroSergSynoloVathmwn");

String cardioThorakikoAlgos=request.getParameter("cardioThorakikoAlgos");
String cardioXaraktiras=request.getParameter("cardioXaraktiras");
String cardioEnarxi=request.getParameter("cardioEnarxi");
String cardioDiarkeia=request.getParameter("cardioDiarkeia");
String cardioanapneustikiSimeiologia=request.getParameter("cardioanapneustikiSimeiologia");

String psychoDiathesi=request.getParameter("psychoDiathesi");
String psychoSymperifora=request.getParameter("psychoSymperifora");
String psychoSkepseis=request.getParameter("psychoSkepseis");

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
    
    ApiSessionBean curApiSession = ApiHelper.checkApiSessionId(apiSessionId);
    if(curApiSession!=null)
    {
        try
        {
            patBean erPatient = null;
            if(patientId!=null && patientId.trim().length()>0)
            {
                erPatient=DBH.getPatientById(patientId);
                erPatient.unknown="false";
            }
            else
            {
                if(name!=null && name.length()>0 && surname!=null && surname.length()>0 && gender!=null && gender.length()>0)
                {
                    erPatient=new patBean("", name, surname, fathersName, gender, "", "", "", "", "", "", otherIdentifier, "true");
                    erPatient.setBirthDate(null);
                }
                else
                {
                    erPatient = null;
                }
            }
            
            if(erPatient!=null)
            {
                EmergencyCaseBean newEmergencyCaseBean = new EmergencyCaseBean();
                newEmergencyCaseBean.patientBean=erPatient;
                newEmergencyCaseBean.erRegForm=new EmergencyRegistrationFormBean();
                
                newEmergencyCaseBean.erRegForm.erAge=erAge;
                newEmergencyCaseBean.erRegForm.erProselefsi=erProselefsi;
                newEmergencyCaseBean.erRegForm.erOros=erOros;
                newEmergencyCaseBean.erRegForm.erAllo=erAllo;
                
                newEmergencyCaseBean.erRegForm.histSymptom=histSymptom;
                newEmergencyCaseBean.erRegForm.histSmoker=histSmoker;
                newEmergencyCaseBean.erRegForm.histAlergic=histAlergic;
                newEmergencyCaseBean.erRegForm.histLoimodi=histLoimodi;
                
                newEmergencyCaseBean.erRegForm.trauma=trauma;
                
                newEmergencyCaseBean.erRegForm.vitalTime=vitalTime;
                newEmergencyCaseBean.erRegForm.vitalPulses=vitalPulses;
                newEmergencyCaseBean.erRegForm.vitalAP=vitalAP;
                newEmergencyCaseBean.erRegForm.vitalInhale=vitalInhale;
                newEmergencyCaseBean.erRegForm.vitalSpo2=vitalSpo2;
                newEmergencyCaseBean.erRegForm.vitalT=vitalT;
                
                newEmergencyCaseBean.erRegForm.derma=derma;
                
                newEmergencyCaseBean.erRegForm.erComments=erComments;
                
                newEmergencyCaseBean.erRegForm.genikiSimeiologia=genikiSimeiologia;
                
                newEmergencyCaseBean.erRegForm.genOther=genOther;
                
                newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia=xeirourgikiSimeiologia;
                
                newEmergencyCaseBean.erRegForm.neurologikiSimeiologia=neurologikiSimeiologia;
                
                newEmergencyCaseBean.erRegForm.neuroParesi=neuroParesi;
                newEmergencyCaseBean.erRegForm.neuroHmipligia=neuroHmipligia;
                
                newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis=neuroSergApoleiaSineidisis;

                newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi=neuroSergAnoiktoiOfthalmoi;

                newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi=neuroSergKalyteriProforikiApantisi;
                
                newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi=neuroSergKalyteriKinitikiApantisi;
                
                newEmergencyCaseBean.erRegForm.neuroSergKoresMegethosDeksi=neuroSergKoresMegethosDeksi;
                newEmergencyCaseBean.erRegForm.neuroSergKoresMegethosAristero=neuroSergKoresMegethosAristero;
                
                newEmergencyCaseBean.erRegForm.neuroSergKoresAntidrasiDeksi=neuroSergKoresAntidrasiDeksi;
                newEmergencyCaseBean.erRegForm.neuroSergKoresAntidrasiAristero=neuroSergKoresAntidrasiAristero;
                
                newEmergencyCaseBean.erRegForm.neuroSergSynoloVathmwn=neuroSergSynoloVathmwn;

                newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos=cardioThorakikoAlgos;
                newEmergencyCaseBean.erRegForm.cardioXaraktiras=cardioXaraktiras;
                newEmergencyCaseBean.erRegForm.cardioEnarxi=cardioEnarxi;
                newEmergencyCaseBean.erRegForm.cardioDiarkeia=cardioDiarkeia;
                newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia=cardioanapneustikiSimeiologia;
                
                newEmergencyCaseBean.erRegForm.psychoDiathesi=psychoDiathesi;
                newEmergencyCaseBean.erRegForm.psychoSymperifora=psychoSymperifora;
                newEmergencyCaseBean.erRegForm.psychoSkepseis=psychoSkepseis;
                
                newEmergencyCaseBean.caseDate=new Date();
                
                newEmergencyCaseBean.SB=curApiSession.getApiAccount().SB;
                newEmergencyCaseBean.AB=curApiSession.getApiAccount();
                
                String newEmergencyCaseReadableId = DBH.insertNewEmergencyCaseForApi(newEmergencyCaseBean);
                
                if(newEmergencyCaseReadableId!=null && newEmergencyCaseReadableId.length()>0)
                {
                    responseMessage=newEmergencyCaseReadableId;
                }
                else
                {
                    responseMessage="ERROR:FAILED_TO_SAVE_NEW_EMERGENCY_CASE";
                }
            }
            else
            {
                responseMessage="ERROR:INVALID_PATIENT";
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

