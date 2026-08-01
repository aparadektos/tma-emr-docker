<%@page import="beans.SettingsBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="tools.ActiveDirectory"%>
<%@page import="javax.naming.ldap.LdapContext"%>
<%@page import="backings.ManagerBacking"%>
<%@page import="backings.ConsultantBacking"%>
<%@page import="backings.CounterdeskBacking"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.SiteAdminBacking"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="tools.RisLogger"%>
<%@page import="backings.SiteUserBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
    
String clientInfo = "Client Info:\r\n";
clientInfo+="Remote Address: "+request.getRemoteAddr()+"\r\n";
clientInfo+="Remote Host "+request.getRemoteHost()+"\r\n";
clientInfo+="Remote User "+request.getRemoteUser()+"\r\n";
clientInfo+="Server Name: "+request.getServerName()+"\r\n";

//new DB
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


//get credentials
request.setCharacterEncoding("UTF-8");
String username=request.getParameter("username").trim();
String password=request.getParameter("password").trim();

//validate fields
//not necessary since the user wont be logged in

boolean adLoginResult=false;
accountBean AB=null;
accountBean loginAccount = DBH.getAccountByUsername(username);
if(loginAccount!=null && loginAccount.id!=null && loginAccount.id.length()>0)
{
    if(loginAccount.getByPassAd().equalsIgnoreCase("true"))
    {
        //gia na kanei kai elegxo toy password
        AB=DBH.checkLogin(username,password);
    }
    else
    {  
        //====== NEW METHOD =======
        String user = username;
        String pass = password;
        String ldap = "tmaath.local";//gia TMA
        //String ldap = "st.edit.gov.gr";//gia EDIT

        //System.out.println("user = "+user);
        //System.out.println("pass = "+pass);
        //System.out.println("ldap = "+ldap);

        int result=ActiveDirectory.customSearch(user, pass, user, ldap);
        if(result==0)
        {
            adLoginResult=false;
            System.err.println("AD Login failed. Reason: username/password error");
        }
        else if(result==1)
        {
            adLoginResult=false;
            System.err.println("AD Login failed. Reason: user not found");
        }
        else if(result==2)
        {
            adLoginResult=false;
            System.err.println("AD Login failed. Reason: LDAP server not found");
        }
        else if(result==3)
        {
            adLoginResult=true;
            AB=loginAccount;
        }
        else
        {
            adLoginResult=false;
            System.err.println("AD Login failed. Reason: result is "+result);
        }
    }
}
else
{
    AB=null;
}

//adLoginResult=true;//sto deploy tou EDIT prepei h grammi auth na einai PANTA se sxolia!!!!!!!!!!!!!!!!!!!!!alliws tha kanei bypass ton AD
if(AB!=null)
{
    //if OK add DB and User in session, and go to appropriate page based on roleid
    session.setAttribute("DBH",DBH);
    session.setAttribute("AB",AB);
    
    GlobalHelper GH = new GlobalHelper();
    GH.totalSites=allSettings.getParameterInt("totalSites");
    GH.totalStis=allSettings.getParameterInt("totalStis");
    session.setAttribute("GH",GH);
    
    if(AB.RB.roleName.equals("admin"))
    {
        //session.setMaxInactiveInterval(60*10);//in seconds
        //response.sendRedirect("../hqadmin/sites.jsp");
    }
    else if(AB.RB.roleName.equals("hqadmin"))
    {
        HqAdminBacking hqAdminBacking = new HqAdminBacking(DBH,AB);
        session.setAttribute("hqAdminBacking",hqAdminBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        response.sendRedirect("../hqadmin/stis.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as hqadmin, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("siteadmin"))
    {
        SiteAdminBacking siteAdminBacking = new SiteAdminBacking(DBH,AB);
        session.setAttribute("siteAdminBacking",siteAdminBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        //response.sendRedirect("../siteadmin/index.jsp");
        response.sendRedirect("../siteadmin/modalities.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as siteadmin, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("siteuser"))
    {
        SiteUserBacking siteUserBacking = new SiteUserBacking(DBH,AB);
        session.setAttribute("siteUserBacking",siteUserBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        //response.sendRedirect("../siteadmin/index.jsp");
        response.sendRedirect("../siteuser/patients.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as siteuser, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("sitedoctor"))
    {
        SiteDoctorBacking siteDoctorBacking = new SiteDoctorBacking(DBH,AB);
        session.setAttribute("siteDoctorBacking",siteDoctorBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        //response.sendRedirect("../siteadmin/index.jsp");
        response.sendRedirect("../sitedoctor/teleAppointments.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as sitedoctor, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("paramedic"))
    {
        ParamedicBacking paramedicBacking = new ParamedicBacking(DBH,AB);
        session.setAttribute("paramedicBacking",paramedicBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        //response.sendRedirect("../siteadmin/index.jsp");
        response.sendRedirect("../paramedic/teleAppointments.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as paramedic, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("counterdesk"))
    {
        CounterdeskBacking counterdeskBacking = new CounterdeskBacking(DBH,AB);
        session.setAttribute("counterdeskBacking",counterdeskBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        //response.sendRedirect("../siteadmin/index.jsp");
        response.sendRedirect("../counterdesk/efimeries.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as counterdesk, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("consultant"))
    {
        ConsultantBacking consultantBacking = new ConsultantBacking(DBH,AB);
        session.setAttribute("consultantBacking",consultantBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        //response.sendRedirect("../siteadmin/index.jsp");
        response.sendRedirect("../consultant/myEfimeries.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as consultant, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else if(AB.RB.roleName.equals("manager"))
    {
        ManagerBacking managerBacking = new ManagerBacking(DBH,AB);
        session.setAttribute("managerBacking",managerBacking);
        session.setMaxInactiveInterval(60*60*2);//in seconds
        response.sendRedirect("../manager/reporting.jsp");
        RisLogger.addLogRecord("User "+username+" logged in as manager, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
    else
    {
        //unknown role. empty session and go to login again
        session.invalidate();
        response.sendRedirect("../index.jsp?login=failed&lang="+langBacking.lang);
        System.err.println("Unknown role for user "+AB.username);
        RisLogger.addLogRecord("User "+username+" failed to login because role is unknown, to "+GH.deployDate+".\r\n\r\n"+clientInfo,null);
    }
}
else
{
    //else go to login again
    response.sendRedirect("../index.jsp?login=failed&lang="+langBacking.lang);
    System.err.println("Unknown user.");
    RisLogger.addLogRecord("User "+username+" failed to login.\r\n\r\n"+clientInfo,null);
}

%>