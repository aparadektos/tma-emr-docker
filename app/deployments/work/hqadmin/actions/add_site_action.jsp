<%@page import="beans.FlagBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.HqAdminBacking"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.DBHelper"%>
<%@page import="beans.accountBean"%>

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<%
HqAdminBacking hqAdminBacking = (HqAdminBacking)session.getAttribute("hqAdminBacking");
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
    
//get new site fields
request.setCharacterEncoding("UTF-8");
String siteName=request.getParameter("siteName").trim();
String siteAddress=request.getParameter("siteAddress").trim();
String siteContact=request.getParameter("siteContact").trim();
String sitePrintTitle=request.getParameter("sitePrintTitle").trim();
String flagId=request.getParameter("flagId");

//replace special chars
siteName=siteName.replaceAll("\r\n", ", ");
siteName=siteName.replaceAll("'", "&#39;");
        
siteAddress=siteAddress.replaceAll("\r\n", ", ");
siteAddress=siteAddress.replaceAll("'", "&#39;");

siteContact=siteContact.replaceAll("\r\n", ", ");
siteContact=siteContact.replaceAll("'", "&#39;");

sitePrintTitle=sitePrintTitle.replaceAll("\r\n", ", ");
sitePrintTitle=sitePrintTitle.replaceAll("'", "&#39;");

String existingSiteIdWithSameName=hqAdminBacking.siteNameExists(siteName);

if(existingSiteIdWithSameName!=null)
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("add_site_same_name");
    response.sendRedirect("../sites.jsp?result=error4new");
}
else
{
    //check number of sites. should be max 39
    DBHelper DBH=(DBHelper)session.getAttribute("DBH");
    if(DBH!=null)
    {
        int siteNum = DBH.getTotalSites();//STIA
        if(siteNum<GlobalHelper.totalSites)
        {
            //validate fields
            if(siteName!=null && siteName.length()>0)
            {
                //get centerid that new site belongs to
        //        accountBean AB=(accountBean)session.getAttribute("AB");
                //prosorina einai AB.centerID alla prepei na to pairnoyme apo to centerBean AB.CB.centerID

                //create new siteBean
                siteBean newSiteBean=new siteBean("", siteName, siteAddress, siteContact);
                newSiteBean.setSitePrintTitle(sitePrintTitle);
                FlagBean curFlagBean = new FlagBean();
                curFlagBean.setId(flagId);
                newSiteBean.setFlagBean(curFlagBean);

                //retrieve DB
                //DBHelper DBH=(DBHelper)session.getAttribute("DBH");

                //insert new site to DB table
                if(DBH.insertNewSite(newSiteBean)==true)
                {
                    //if success response OK to sites.jsp
                    hqAdminBacking.okMessage=langBacking.getLiteral("add_site_ok");
                    response.sendRedirect("../sites.jsp?result=newSiteAdded");
                }
                else
                {
                    //if failed response ERROR to sites.jsp
                    hqAdminBacking.errorMessage=langBacking.getLiteral("add_site_failed");
                    response.sendRedirect("../sites.jsp?result=error4new");
                }
            }
            else
            {
                hqAdminBacking.errorMessage=langBacking.getLiteral("add_site_failed");
                response.sendRedirect("../sites.jsp?result=error");
            }
        }
        else
        {
            hqAdminBacking.infoMessage=langBacking.getLiteral("stia_max_num")+": "+GlobalHelper.totalSites;
            response.sendRedirect("../sites.jsp?result=error4new");
        }
    }
    else
    {
        hqAdminBacking.infoMessage=langBacking.getLiteral("Cannot connect to database");
        response.sendRedirect("../sites.jsp?result=error4new");
    }
    
    
}
%>