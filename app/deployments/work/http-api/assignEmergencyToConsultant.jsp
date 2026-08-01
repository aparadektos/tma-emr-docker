

<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.SettingsBean"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="beans.EmergencyCaseBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="java.util.Date"%>
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
String apiSessionId=request.getParameter("apiSessionId");
String efimeriaId=request.getParameter("efimeriaId");
String erDateTime=request.getParameter("erDateTime");
String patientId=request.getParameter("patientId");
String erReadableId=request.getParameter("erReadableId");
String lang=request.getParameter("lang");

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
        
        if(efimeriaId!=null && efimeriaId.trim().length()>0 && erDateTime!=null && erDateTime.trim().length()>0 && 
           patientId!=null && patientId.trim().length()>0 && erReadableId!=null && erReadableId.trim().length()>0 )
        {
            Date erDateTimeObj = null;
            try
            {
                erDateTimeObj=new Date(Long.parseLong(erDateTime));
                if(erDateTimeObj.before(new Date()))
                {
                    erDateTimeObj=null;
                }
            }
            catch(Exception e)
            {
                erDateTimeObj = null;
            }
            
            if(erDateTimeObj!=null)
            {
                TeleAppointmentBean erTeleAppBean = new TeleAppointmentBean();
                erTeleAppBean.setAccountid(curApiSession.getApiAccount().id);
                erTeleAppBean.setStatus("Pending");
                if(curApiSession.getApiAccount().docBean!=null && curApiSession.getApiAccount().docBean.id!=null &&
                   curApiSession.getApiAccount().docBean.id.length()>0)
                {
                    erTeleAppBean.setSiteDoctorBean(curApiSession.getApiAccount().docBean);
                    erTeleAppBean.setSB(curApiSession.getApiAccount().docBean.SB);
                }
                else if(curApiSession.getApiAccount().getParamedicBean()!=null && curApiSession.getApiAccount().getParamedicBean().getId()!=null &&
                   curApiSession.getApiAccount().getParamedicBean().getId().length()>0)
                {
                    erTeleAppBean.setParamedicBean(curApiSession.getApiAccount().getParamedicBean());
                    erTeleAppBean.setSB(curApiSession.getApiAccount().getParamedicBean().getSB());
                }
                
                erTeleAppBean.setEmergency("true");
                erTeleAppBean.setStartdatetime(new Timestamp(erDateTimeObj.getTime()));
                
                EmergencyCaseBean selectedErCase = DBH.getEmergencyCaseByReadableId(erReadableId);
                if(selectedErCase!=null)
                {
                    erTeleAppBean.setEmergencyCaseId(selectedErCase.id);
                    if(selectedErCase.patientBean.getId().equals(patientId))
                    {
                        erTeleAppBean.setPatientBean(selectedErCase.patientBean);
                        
                        Calendar endCal = Calendar.getInstance();
                        endCal.setTime((Date)erTeleAppBean.getStartdatetime().clone());
                        endCal.add(Calendar.MINUTE, 30);
                        erTeleAppBean.setEnddatetime(new Timestamp(endCal.getTime().getTime()));
                        
                        EfimeriaBean selectedEfimeria = DBH.getEfimeriaById(efimeriaId);
                        if(selectedEfimeria!=null)
                        {
                            erTeleAppBean.setStisBean1(selectedEfimeria.getStisBean());
                            erTeleAppBean.setConsultantBean1(selectedEfimeria.getConsultantBean());
                            erTeleAppBean.setRequestedSpecialtyBean1(selectedEfimeria.getConsultantBean().getSpecialtyBean());
                            
                            if(ApiHelper.checkTeleAppointmentConflict(DBH, erTeleAppBean.getStisBean1().getId(), erTeleAppBean.getStartdatetime(), erTeleAppBean.getEnddatetime())==false)
                            {
                                String newErTeleAppReadableId = DBH.insertNewTeleAppointmentForApi(erTeleAppBean);
                                if(newErTeleAppReadableId!=null && newErTeleAppReadableId.length()>0)
                                {
                                    LanguageBacking langBacking = new LanguageBacking(DBH);
                                    langBacking.loadLiteralsByLanguage(lang);
                                    
                                    String newTeleAppMessage = "";
                                    newTeleAppMessage+=langBacking.getLiteral("patient")+": "+erTeleAppBean.getPatientBean().name+" "+erTeleAppBean.getPatientBean().surname+"\n";
                                    newTeleAppMessage+=langBacking.getLiteral("paramedic")+": "+erTeleAppBean.getParamedicBean().getFullName()+" ("+erTeleAppBean.getParamedicBean().getParamTypeBean().getNameByLang(langBacking.lang)+")"+"\n";
                                    newTeleAppMessage+=langBacking.getLiteral("site")+": "+erTeleAppBean.getSB().name+"\n";
                                    newTeleAppMessage+=langBacking.getLiteral("date_time")+": "+erTeleAppBean.getStartEndDateTimeStr(langBacking.getDateFormat())+"\n";
                                    if(erTeleAppBean.getConsultantBean1()!=null && erTeleAppBean.getConsultantBean1().getId()!=null && erTeleAppBean.getConsultantBean1().getId().length()>0)
                                    {
                                        newTeleAppMessage+=langBacking.getLiteral("consultant")+": "+erTeleAppBean.getConsultantBean1().getFullName()+" ("+erTeleAppBean.getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                                    }
                                    if(erTeleAppBean.getConsultantBean2()!=null && erTeleAppBean.getConsultantBean2().getId()!=null && erTeleAppBean.getConsultantBean2().getId().length()>0)
                                    {
                                        newTeleAppMessage+="\n"+langBacking.getLiteral("consultant")+": "+erTeleAppBean.getConsultantBean2().getFullName()+" ("+erTeleAppBean.getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang)+")";
                                    }
                                    if(ApiHelper.newTeleAppointmentAlert(langBacking.getLiteral("new_emergency_case"),newTeleAppMessage,erTeleAppBean,DBH)==false)
                                    {
                                        //mail sent
                                    }
                                    else
                                    {
                                        //mail wasn't sent
                                    }

                                    responseMessage=newErTeleAppReadableId;
                                }
                                else
                                {
                                    responseMessage="ERROR:ASSIGNMENT_FAILED";
                                }
                            }
                            else
                            {
                                responseMessage="ERROR:APPOINTMENT_CONFLICT";
                            }
                        }
                        else
                        {
                            responseMessage="ERROR:INVALID_EFIMERIA";
                        }
                    }
                    else
                    {
                        responseMessage="ERROR:INVALID_PATIENT";
                    }
                }
                else
                {
                    responseMessage="ERROR:INVALID_EMERGENCY_CASE";
                }
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

