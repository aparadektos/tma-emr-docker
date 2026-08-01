

<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.WebinarBean"%>
<%@page import="beans.siteBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.StisBean"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.CounterdeskBacking"%>
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
CounterdeskBacking counterdeskBacking = (CounterdeskBacking)session.getAttribute("counterdeskBacking");

String returnToPage=request.getHeader("Referer");
    
//get new fields
request.setCharacterEncoding("UTF-8");
String webinarType=request.getParameter("webinarType");
String webinarStartDateStr=request.getParameter("previewDatePicker");
String webinarStartTimeStr=request.getParameter("webinarStartTime");
String webinarEndTimeStr=request.getParameter("webinarEndTime");
String webinarSubject=request.getParameter("webinarSubject");
String webinarOrganizer=request.getParameter("webinarOrganizer");
String webinarDescription=request.getParameter("webinarDescription");

webinarSubject=webinarSubject.replaceAll("'", "&quot;");
webinarSubject=webinarSubject.replaceAll("\"", "&quot;");
webinarOrganizer=webinarOrganizer.replaceAll("'", "&quot;");
webinarOrganizer=webinarOrganizer.replaceAll("\"", "&quot;");
webinarDescription=webinarDescription.replaceAll("'", "&quot;");
webinarDescription=webinarDescription.replaceAll("\"", "&quot;");

ArrayList<StisBean> selectedStisList = new ArrayList<StisBean>(0);
ArrayList<StisBean> allStisList=counterdeskBacking.getAllStis();
for(StisBean curStis : allStisList)
{
    String curStisSelected = request.getParameter("stis#"+curStis.getId());
    if(curStisSelected!=null && curStisSelected.length()>0)
    {
        selectedStisList.add(curStis);
    }
}

ArrayList<siteBean> selectedSiteList = new ArrayList<siteBean>(0);
ArrayList<siteBean> allSitesList=counterdeskBacking.getAllSites();
for(siteBean curSite : allSitesList)
{
    String curSiteSelected = request.getParameter("site#"+curSite.id);
    if(curSiteSelected!=null && curSiteSelected.length()>0)
    {
        selectedSiteList.add(curSite);
    }
}

//set values to backing
counterdeskBacking.getSelectedWebinarBeanToEdit().setType(webinarType);
counterdeskBacking.getSelectedWebinarBeanToEdit().setSubject(webinarSubject);
counterdeskBacking.getSelectedWebinarBeanToEdit().setOrganizer(webinarOrganizer);
counterdeskBacking.getSelectedWebinarBeanToEdit().setDescription(webinarDescription);
counterdeskBacking.getSelectedWebinarBeanToEdit().setStisList(selectedStisList);
counterdeskBacking.getSelectedWebinarBeanToEdit().setSitesList(selectedSiteList);
counterdeskBacking.getSelectedWebinarBeanToEdit().setDeleted("false");

try
{
    SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
    counterdeskBacking.getSelectedWebinarBeanToEdit().setStartDateAndTime(new Timestamp( (sdf.parse(webinarStartDateStr+" "+webinarStartTimeStr)).getTime() ));
    counterdeskBacking.getSelectedWebinarBeanToEdit().setEndDateAndTime(new Timestamp( (sdf.parse(webinarStartDateStr+" "+webinarEndTimeStr)).getTime() ));
    
    if(webinarStartDateStr!=null && webinarStartDateStr.length()>0 && webinarStartTimeStr!=null && webinarStartTimeStr.length()>0 &&
       webinarEndTimeStr!=null && webinarEndTimeStr.length()>0 && webinarSubject!=null && webinarSubject.length()>0 &&
       selectedStisList!=null && selectedStisList.size()>0)
    {
        if(counterdeskBacking.getSelectedWebinarBeanToEdit().getStartDateAndTime().after(counterdeskBacking.getSelectedWebinarBeanToEdit().getEndDateAndTime()) ||
           counterdeskBacking.getSelectedWebinarBeanToEdit().getStartDateAndTime().equals(counterdeskBacking.getSelectedWebinarBeanToEdit().getEndDateAndTime()))
        {
            counterdeskBacking.setInfoMessage(langBacking.getLiteral("add_webinar_invalid_time"));
        }
        else
        {
            //elegxos mi yparksis dilwmenis efimerias stis epilegmenes STIS kata to epilegmeno xroniko diastima.
            if(counterdeskBacking.checkWebinarConflicts(counterdeskBacking.getSelectedWebinarBeanToEdit())==false)
            {
                if(counterdeskBacking.updateWebinar(counterdeskBacking.getSelectedWebinarBeanToEdit()))
                {
                    counterdeskBacking.setOkMessage(langBacking.getLiteral("edit_webinar_ok"));
                    counterdeskBacking.setSelectedWebinarBeanToEdit(new WebinarBean());
                    returnToPage="../webinars.jsp";
                }
                else
                {
                    counterdeskBacking.setErrorMessage(langBacking.getLiteral("edit_webinar_failed"));
                }
            }
            else
            {
                counterdeskBacking.setInfoMessage(langBacking.getLiteral("webinar_conflict"));
            }
        }
    }
    else
    {
        counterdeskBacking.setInfoMessage(langBacking.getLiteral("add_webinar_required_fields"));
    }
}
catch(Exception e)
{
    e.printStackTrace();
    counterdeskBacking.setErrorMessage(langBacking.getLiteral("edit_webinar_failed"));
}

response.sendRedirect(returnToPage);

%>