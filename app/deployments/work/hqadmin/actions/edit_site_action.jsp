<%@page import="beans.FlagBean"%>
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

String siteID=request.getParameter("siteid").trim();
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

if(existingSiteIdWithSameName!=null && existingSiteIdWithSameName.equals(siteID)==false)
{
    hqAdminBacking.infoMessage=langBacking.getLiteral("add_site_same_name");
    response.sendRedirect("../sites.jsp?result=error4new");
}
else
{
//validate fields
    if(siteID!=null && siteID.length()>0 && siteName!=null && siteName.length()>0 && siteAddress!=null && siteContact!=null )
    {
        //get centerid that new site belongs to
//        accountBean AB=(accountBean)session.getAttribute("AB");
        //prosorina einai AB.centerID alla prepei na to pairnoyme apo to centerBean AB.CB.centerID

        //create new siteBean
        siteBean SB=new siteBean(siteID, siteName, siteAddress, siteContact);
        SB.setSitePrintTitle(sitePrintTitle);
        FlagBean flagBean = new FlagBean();
        flagBean.setId(flagId);
        SB.setFlagBean(flagBean);

        //retrieve DB
        DBHelper DBH=(DBHelper)session.getAttribute("DBH");

        //update site to DB table
        if(DBH.updateSite(SB)==true)
        {
            //if success response OK to sites.jsp
            hqAdminBacking.okMessage=langBacking.getLiteral("edit_site_ok");
            response.sendRedirect("../sites.jsp?result=siteUpdated");
        }
        else
        {
            //if failed response ERROR to sites.jsp
            hqAdminBacking.errorMessage=langBacking.getLiteral("edit_site_failed");
            response.sendRedirect("../sites.jsp?result=error4edit");
        }
    }
    else
    {
        hqAdminBacking.errorMessage=langBacking.getLiteral("edit_site_failed");
        response.sendRedirect("../sites.jsp?result=error");
    }
}
%>