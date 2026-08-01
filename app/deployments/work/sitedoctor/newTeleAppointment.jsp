<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Calendar"%>
<%@page import="beans.StisBean"%>
<%@page import="beans.EfimeriaBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="beans.TeleAppointmentBean"%>
<%@page import="beans.ExamTypeBean"%>
<%@page import="backings.SiteDoctorBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="java.util.HashMap"%>
<%@page import="beans.appointmentsBean"%>
<%@page import="beans.ExamroomsBean"%>
<%@page import="beans.timeslotBean"%>
<%@page import="beans.avPeriod"%>
<%@page import="beans.docAvBean"%>
<%@page import="java.util.Date"%>
<%@page import="beans.patBean"%>
<%@page import="beans.siteBean"%>
<%@page import="tools.GlobalHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.accountBean"%>

<%
GlobalHelper GH=(GlobalHelper)session.getAttribute("GH");

LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
SiteDoctorBacking siteDoctorBacking = (SiteDoctorBacking)session.getAttribute("siteDoctorBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title><%= GH.htmlTitle %></title>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../style.css" rel="stylesheet" type="text/css" media="screen"/>
        
        <!--  Table Grid LIBs  -->
        <!--jQuery References-->
        <script src="../wijmotools/external/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../wijmotools/external/jquery-ui-1.8.18.custom.min.js" type="text/javascript"></script>
        <!--Theme-->
        <link href="../wijmotools/themes/aristo/jquery-wijmo.css" rel="stylesheet" type="text/css" title="rocket-jqueryui" />
        <!--Wijmo Widgets CSS-->
        <link href="../wijmotools/Wijmo-Complete/css/jquery.wijmo-complete.all.2.0.5.min.css" rel="stylesheet" type="text/css" />
        <!--Sample Dependencies-->
        <script src="../wijmotools/explore/js/amplify.core.min.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/amplify.store.min.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/jquery.cookie.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/jquery.tmpl.min.js" type="text/javascript"></script>
        <script src="../wijmotools/explore/js/swfobject.js" type="text/javascript"></script>
        <!--Wijmo Widgets JavaScript-->
        <script src="../wijmotools/Wijmo-Complete/js/jquery.wijmo-open.all.2.0.5.min.js" type="text/javascript"></script>
        <script src="../wijmotools/Wijmo-Complete/js/jquery.wijmo-complete.all.2.0.5.min.js" type="text/javascript"></script>
        <script src="../wijmotools/Wijmo-Complete/development-bundle/external/cultures/globalize.cultures.js" type="text/javascript"></script>

    </head>

    <script language="javascript">
        function popupShowConsultant(consId)
        {
            $("#popup").wijdialog({ 
                title: "<%= langBacking.getLiteral("popup_show_consultant_title") %>",
                width: 700, 
                height: 500, 
                modal: false,
                contentUrl: 'popupShowConsultant.jsp?consId='+consId, 
                captionButtons: {
                    pin: { visible: false },
                    refresh: { visible: false },
                    toggle: { visible: false },
                    minimize: { visible: true },
                    maximize: { visible: true }
                },
                autoOpen: true
            });
        }
        
        var totalSelected=0;
        function markEfimeriaAndTime(divObj)
        {
            if(divObj.style.backgroundColor==="orange")
            {
                divObj.style.backgroundColor="transparent";
                totalSelected--;
            }
            else
            {
                if(totalSelected<2)
                {
                    divObj.style.backgroundColor="orange";
                    totalSelected++;
                }
                else
                {
                    goToNextStep();
                }
            }
        }
        
        function goToNextStep()
        {
            var cnt=0;
            for(id=0; id<50; id++)
            {
                var curDivObj = document.getElementById("div#"+id);
                if(curDivObj!==null && curDivObj.style.backgroundColor==="orange")
                {
                    cnt++;
                    
                    var temp=document.getElementById("div#"+id).title.split("##");
                    var efimeriaId=temp[0];
                    var time=temp[1];
                    
                    document.getElementById("selectedEfimeriaId"+cnt).value=efimeriaId;
                    document.getElementById("selectedTime"+cnt).value=time;
                    
                    if(cnt===2)
                    {
                        if(time!==document.getElementById("selectedTime1").value)
                        {
                            alert("Η ώρα του τηλε-ραντεβού θα πρέπει να είναι κοινή.");
                        }
                        else
                        {
                            if(efimeriaId===document.getElementById("selectedEfimeriaId1").value)
                            {
                                alert("Μη έγκυρη επιλογή εφημερίας");
                            }
                            else
                            {
                                document.getElementById("selectedEfimeriesFormId").submit();
                            }
                        }
                    }
                }
            }
            if(cnt===1)
            {
                document.getElementById("selectedEfimeriesFormId").submit();
            }
        }
    </script>
        
    <body>
        
        <div id="popup"></div>
        
    <div id="wrapper">
	<jsp:include page="header.jsp"/>
	<hr><!-- end #logo -->
            <% request.setAttribute("target", "patients"); %>
            <jsp:include page="menu.jsp"/>
	<!-- end #header -->
	<!-- end #header-wrapper -->
        
	<div id="page">
            <div id="page-bgtop">
		<div id="content">
                    <%
                    if(siteDoctorBacking!=null && siteDoctorBacking.errorMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border='0' style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/error.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.errorMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteDoctorBacking!=null && siteDoctorBacking.okMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/check.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.okMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    else if(siteDoctorBacking!=null && siteDoctorBacking.infoMessage.length()>0)
                    {
                        out.println("<div class='post'>");
                        out.println("<table border=0 style='border: 1px solid grey; width:100%;'><tr><td valign='middle' width='70px'>");
                        out.println("<img src='../images/info.png' width='64px'/>");
                        out.println("</td><td valign='middle'>");
                        out.println(siteDoctorBacking.infoMessage);
                        out.println("</td></tr></table>");
                        out.println("</div>");
                    }
                    siteDoctorBacking.resetMessages();
                    %>
                    
                    <%
                    String patId=request.getParameter("patid");
                    if(patId!=null)
                    {
                        patBean PB=siteDoctorBacking.getPatientById(patId);
                        siteDoctorBacking.setNewTeleappointment(new TeleAppointmentBean());
                        siteDoctorBacking.getNewTeleappointment().setPatientBean(PB);
                    }
                    
                    String reqDateStr = request.getParameter("reqDateStr");
                    if(reqDateStr!=null)
                    {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                        siteDoctorBacking.getNewTeleappointment().setStartdatetime(new Timestamp(sdf.parse(reqDateStr).getTime()));
                    }
                    else if(siteDoctorBacking.getNewTeleappointment().getStartdatetime()==null)
                    {
                        siteDoctorBacking.getNewTeleappointment().setStartdatetime(new Timestamp(new Date().getTime()));
                    }
                    %>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("new_tele_appointment") %></a></h2>
                        <div class="entry">
                            <table border="0">
                                <tr>
                                    <td>
                                        <table border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("patient_information") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("name") %>:</td>
                                                <td>
                                                     <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().name %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("surname") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().surname %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("date_of_birth") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().getBirthDateStr(langBacking.getDateFormat()) %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("sex") %>:</td>
                                                <td>
                                                    <%= langBacking.getLiteral(siteDoctorBacking.getNewTeleappointment().getPatientBean().sex.toLowerCase()) %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td>
                                        <table border="0">
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("contact_information") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("address") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().getAddressStr() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("home_phone") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().homephone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("work_phone") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().workphone %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("mobile_phone") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().mobilephone %>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td>
                                        <table>
                                            <tr>
                                                <td colspan="2">
                                                    <b><i><%= langBacking.getLiteral("insurance") %></i></b>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("social_security_number") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().getSsn() %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"><%= langBacking.getLiteral("insurance_name_type") %>:</td>
                                                <td>
                                                    <%= siteDoctorBacking.getNewTeleappointment().getPatientBean().insurancename %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("search_efimeries") %></a></h2>
                        <form method="post" action="actions/search_available_efimeries_action.jsp">
                            <table border="0">
                                <tr>
                                    <td align="right"><%= langBacking.getLiteral("date") %>:</td>
                                    <td>
                                        <input type="text" id="previewDatePicker" name="previewDatePicker" />
                                    </td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td align="right"><%= langBacking.getLiteral("specialty") %>:</td>
                                    <td>
                                        <%
                                        ArrayList<SpecialtyBean> allSpecialties = siteDoctorBacking.getAllSpecialties(langBacking.lang);
                                        out.println("<select id='specialtySelectId1' name='consultantSpecialtyId1'>");
                                        for(SpecialtyBean curSpec : allSpecialties)
                                        {
                                            if(curSpec.id.equals(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean1().getId()))
                                            {
                                                out.println("<option selected value='"+curSpec.id+"'>"+curSpec.getNameByLang(langBacking.lang)+"</option>");
                                            }
                                            else
                                            {
                                                out.println("<option value='"+curSpec.id+"'>"+curSpec.getNameByLang(langBacking.lang)+"</option>");
                                            }
                                        }
                                        out.println("</select>");
                                        %>
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;<%= langBacking.getLiteral("and_or") %>&nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <%
                                        out.println("<select id='specialtySelectId2' name='consultantSpecialtyId2'>");
                                        out.println("<option selected value=''>&nbsp;</option>");
                                        for(SpecialtyBean curSpec : allSpecialties)
                                        {
                                            if(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean2()!=null && curSpec.id.equals(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean2().getId()))
                                            {
                                                out.println("<option selected value='"+curSpec.id+"'>"+curSpec.getNameByLang(langBacking.lang)+"</option>");
                                            }
                                            else
                                            {
                                                out.println("<option value='"+curSpec.id+"'>"+curSpec.getNameByLang(langBacking.lang)+"</option>");
                                            }
                                        }
                                        out.println("</select>");
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="6">
                                        <input type="submit" value="<%= langBacking.getLiteral("search") %>" />
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </div>
                    <%
                    String selectedEfimeriaId1=request.getParameter("selectedEfimeriaId1");
                    String selectedEfimeriaId2=request.getParameter("selectedEfimeriaId2");
                    String selectedTime1=request.getParameter("selectedTime1");
                    String selectedTime2=request.getParameter("selectedTime2");
                    
                    EfimeriaBean selectedEfimeriaBean1 = null;
                    if(selectedEfimeriaId1!=null && selectedTime1!=null)
                    {
                        for(EfimeriaBean curEfimeria : siteDoctorBacking.getAvailableEfimeriesResults())
                        {
                            if(curEfimeria.getId().equals(selectedEfimeriaId1))
                            {
                                selectedEfimeriaBean1=curEfimeria;
                                siteDoctorBacking.getNewTeleappointment().setStisBean1(selectedEfimeriaBean1.getStisBean());
                                siteDoctorBacking.getNewTeleappointment().setConsultantBean1(selectedEfimeriaBean1.getConsultantBean());
                                break;
                            }
                        }
                        Date selectedDateTime = null;
                        try
                        {
                            SimpleDateFormat sdf = new SimpleDateFormat(langBacking.getDateFormat()+" HH:mm");
                            selectedDateTime = sdf.parse(siteDoctorBacking.getNewTeleappointment().getStartDateStr(langBacking.getDateFormat())+" "+selectedTime1);
                            siteDoctorBacking.getNewTeleappointment().setStartdatetime(new Timestamp(selectedDateTime.getTime()));
                        }
                        catch(Exception e)
                        {
                            selectedDateTime = null;
                            siteDoctorBacking.getNewTeleappointment().setStartdatetime(null);
                        }
                    }
                    EfimeriaBean selectedEfimeriaBean2 = null;
                    if(selectedEfimeriaId2!=null && selectedTime2!=null &&
                       selectedEfimeriaId1!=selectedEfimeriaId2 && selectedTime1.equals(selectedTime2))
                    {
                        for(EfimeriaBean curEfimeria : siteDoctorBacking.getAvailableEfimeriesResults())
                        {
                            if(curEfimeria.getId().equals(selectedEfimeriaId2))
                            {
                                selectedEfimeriaBean2=curEfimeria;
                                siteDoctorBacking.getNewTeleappointment().setStisBean2(selectedEfimeriaBean2.getStisBean());
                                siteDoctorBacking.getNewTeleappointment().setConsultantBean2(selectedEfimeriaBean2.getConsultantBean());
                                break;
                            }
                        }
                    }
                    
                    if(siteDoctorBacking.getNewTeleappointment().getStisBean1()!=null && 
                       siteDoctorBacking.getNewTeleappointment().getStisBean1().getId()!=null && 
                       siteDoctorBacking.getNewTeleappointment().getStisBean1().getId().length()>0 && 
                       siteDoctorBacking.getNewTeleappointment().getConsultantBean1()!=null && 
                       siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getId()!=null && 
                       siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getId().length()>0 && 
                       siteDoctorBacking.getNewTeleappointment().getStartdatetime() != null)
                    {
                        //1 consultant for sure
                    %>
                        <div class="post">
                            <h2 class="title"><a href="#"><%= langBacking.getLiteral("selected_efimeria") %></a></h2>
                            <div class="entry">
                                <table border="0">
                                    <tr>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("stis") %>:
                                                    </td>
                                                    <td align="left">
                                                        <%= siteDoctorBacking.getNewTeleappointment().getStisBean1().getTitle()+" ("+siteDoctorBacking.getNewTeleappointment().getStisBean1().getNosokomeio()+")" %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("specialty") %>:
                                                    </td>
                                                    <td align="left">
                                                        <%= siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getSpecialtyBean().getNameByLang(langBacking.lang) %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("consultant") %>:
                                                    </td>
                                                    <td align="left">
                                                        <a href="javascript:popupShowConsultant('<%= siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getId() %>')"><%= siteDoctorBacking.getNewTeleappointment().getConsultantBean1().getFullName() %></a>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right">
                                                        <%= langBacking.getLiteral("date_time") %>:
                                                    </td>
                                                    <td align="left">
                                                        <%= siteDoctorBacking.getNewTeleappointment().getStartDateTimeStr(langBacking.getDateFormat()) %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td align="center" width="100px">
                                            <%
                                            if(siteDoctorBacking.getNewTeleappointment().getStisBean2()!=null && 
                                               siteDoctorBacking.getNewTeleappointment().getConsultantBean2()!=null)
                                            {
                                                out.println(langBacking.getLiteral("and"));
                                            }
                                            %>
                                        </td>
                                        <td>
                                            <%
                                            if(siteDoctorBacking.getNewTeleappointment().getStisBean2()!=null && 
                                               siteDoctorBacking.getNewTeleappointment().getConsultantBean2()!=null)
                                            {
                                            %>
                                                <table>
                                                    <tr>
                                                        <td align="right">
                                                            <%= langBacking.getLiteral("stis") %>:
                                                        </td>
                                                        <td align="left">
                                                            <%= siteDoctorBacking.getNewTeleappointment().getStisBean2().getTitle()+" ("+siteDoctorBacking.getNewTeleappointment().getStisBean2().getNosokomeio()+")" %>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <%= langBacking.getLiteral("specialty") %>:
                                                        </td>
                                                        <td align="left">
                                                            <%= siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getSpecialtyBean().getNameByLang(langBacking.lang) %>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <%= langBacking.getLiteral("consultant") %>:
                                                        </td>
                                                        <td align="left">
                                                            <a href="javascript:popupShowConsultant('<%= siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getId() %>')"><%= siteDoctorBacking.getNewTeleappointment().getConsultantBean2().getFullName() %></a>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <%= langBacking.getLiteral("date_time") %>:
                                                        </td>
                                                        <td align="left">
                                                            <%= siteDoctorBacking.getNewTeleappointment().getStartDateTimeStr(langBacking.getDateFormat()) %>
                                                        </td>
                                                    </tr>
                                                </table>
                                            <%
                                            }
                                            %>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <div class="post">
                            <h2 class="title"><a href="#"><%= langBacking.getLiteral("files") %></a></h2>
                            <div class="entry">
                                <form method="post" action="actions/upload_teleAppointment_file_action.jsp" enctype="multipart/form-data">
                                    <table border="0">
                                        <tr>
                                            <td>
                                                <input type="file" name="teleAppointmentFile"  />
                                            </td>
                                            <td>
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            </td>
                                            <td rowspan="2" valign="bottom">
                                                <input type="submit" value="<%= langBacking.getLiteral("add_file") %>" />
                                            </td>
                                        </tr>
                                    </table>
                                    <table border="0">
                                        <%
                                        for(FileItem curFile : siteDoctorBacking.getNewTeleappointment().getFileItems())
                                        {
                                            out.println("<tr>");
                                                out.println("<td align='right'>");
                                                    out.println("("+Math.round(curFile.getSize()/1024.0)+" KB) "+curFile.getName());
                                                out.println("</td>");
                                                out.println("<td align='left'>");
                                                    out.println("<a href='actions/remove_teleAppointment_file_action.jsp?fileHash="+curFile.hashCode()+"'><img src='../images/trash.png' width='25px'/></a>");
                                                out.println("</td>");
                                            out.println("</tr>");
                                        }
                                        %>
                                    </table>
                                </form>
                            </div>
                        </div>
                        <div class="post">
                            <h2 class="title"><a href="#"><%= langBacking.getLiteral("other_information") %></a></h2>
                            <div class="entry">
                                <form name="saveTeleAppointmnet" method="post" action="actions/add_teleAppointment_action.jsp">
                                    <table border="0">
                                        <tr>
                                            <td>
                                                <textarea name="teleAppointmentComments" rows="4" cols="60"></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <input type="submit" value="<%= langBacking.getLiteral("save") %>"/>
                                            </td>
                                        </tr>
                                    </table>

                                <%
//                                    out.println(langBacking.getLiteral("comment"));
//                                    out.println("<br/>");
//                                    out.println("<br/>");
                                %>
                                </form>
                            </div>
                        </div>
                    <%
                    }
                    else if(siteDoctorBacking.isShowAvailableEfimeriesResults()==true &&
                            siteDoctorBacking.getAvailableEfimeriesResults()!=null && 
                            siteDoctorBacking.getAvailableEfimeriesResults().size()>0)
                    {
                    %>
                    <div class="post">
                        <h2 class="title"><a href="#"><%= langBacking.getLiteral("available_efimeries") %></a></h2>
                        <div class="entry">
                            <script id="scriptInit" type="text/javascript">
                            $(document).ready(function () {
                                $("#efimeriesTable").wijgrid({
                                    allowSorting: true,
                                    allowPaging: true,
                                    pageSize: 50,
                                    allowColSizing: true,
                                    data: [
                                <%
                                ArrayList<StisBean> stisList=new ArrayList<StisBean>(0);
                                ArrayList<String> stisStrList=new ArrayList<String>(0);
                                for(EfimeriaBean curEfimeria : siteDoctorBacking.getAvailableEfimeriesResults())
                                {
                                    if(stisStrList.contains(curEfimeria.getStisBean().getId())==false)
                                    {
                                        stisList.add(curEfimeria.getStisBean());
                                        stisStrList.add(curEfimeria.getStisBean().getId());
                                    }
                                }
                                stisStrList.clear();
                                stisStrList=null;
                                
                                if(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean2()!=null)
                                {
                                    siteDoctorBacking.getAllTeleAppointmentsBySpecialtiesIdsAndDate(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean1().getId(),siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean2().getId(),siteDoctorBacking.getNewTeleappointment().getStartdatetime());
                                }
                                else
                                {
                                    siteDoctorBacking.getAllTeleAppointmentsBySpecialtiesIdsAndDate(siteDoctorBacking.getNewTeleappointment().getRequestedSpecialtyBean1().getId(),"",siteDoctorBacking.getNewTeleappointment().getStartdatetime());
                                }

                                Calendar reqDateCal = Calendar.getInstance();
                                reqDateCal.setTime(siteDoctorBacking.getNewTeleappointment().getStartdatetime());
                                reqDateCal.set(Calendar.HOUR_OF_DAY, 0);
                                reqDateCal.set(Calendar.MINUTE, 0);
                                reqDateCal.set(Calendar.SECOND, 0);
                                reqDateCal.set(Calendar.MILLISECOND, 0);
                                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
                                int divId=0;
                                int curDay = reqDateCal.get(Calendar.DAY_OF_MONTH);
                                while(true)
                                {
                                    String curTime = sdf.format(reqDateCal.getTime());
                                    String row="['"+curTime+"',";
                                    for(StisBean curStis : stisList)
                                    {
//                                        if(curTime.equalsIgnoreCase("13:00") || curTime.equalsIgnoreCase("13:30"))
//                                        {
//                                            row+="'<div style=\"background-color:gray;\"><i>"+langBacking.getLiteral("not_available")+"</i></div>',";
//                                            continue;
//                                        }
                                        
                                        TeleAppointmentBean retrievedTeleAppoint = siteDoctorBacking.findTeleAppointmentByStisAndDateTimeFromResults(curStis.getId(),reqDateCal.getTime());
                                        EfimeriaBean retrievedEfimeria = siteDoctorBacking.findEfimeriaByStisAndDate(curStis.getId(),reqDateCal.getTime());
                                        if(retrievedEfimeria!=null)
                                        {
                                            if(retrievedTeleAppoint!=null)
                                            {
                                                String divColor="#000000";
                                                if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Pending"))
                                                {
                                                    divColor="#FFCCCC";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("Completed"))
                                                {
                                                    divColor="#99FF99";
                                                }
                                                else if(retrievedTeleAppoint.getStatus().equalsIgnoreCase("in_progress"))
                                                {
                                                    divColor="#CC0000";
                                                }
                                                row+="'<div style=\"background-color:"+divColor+";\"><i>"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")</i></div>',";
                                            }
                                            else
                                            {
                                                if(reqDateCal.getTime().after(new Date()))
                                                {
                                                    row+="'<div id=\"div#"+divId+"\" title=\""+retrievedEfimeria.getId()+"##"+curTime+"\" onclick=\"javascript:markEfimeriaAndTime(this);\">"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")</div>"+"',";
                                                    divId++;
                                                }
                                                else
                                                {
                                                    row+="'<i>"+retrievedEfimeria.getConsultantBean().getSpecialtyBean().getNameByLang(langBacking.lang)+"<br/>("+retrievedEfimeria.getConsultantBean().getName()+" "+retrievedEfimeria.getConsultantBean().getSurname()+")"+"</i>',";
                                                }
                                            }
                                        }
                                        else
                                        {
                                            row+="'',";
                                        }
                                    }
                                    
                                    if(row.endsWith(","))
                                    {
                                        row=row.substring(0, row.length()-1);
                                    }
                                    
                                    row+="],";
                                    
                                    if(curDay==reqDateCal.get(Calendar.DAY_OF_MONTH) && reqDateCal.get(Calendar.HOUR_OF_DAY)<23 || 
                                      (reqDateCal.get(Calendar.HOUR_OF_DAY)==23 && reqDateCal.get(Calendar.MINUTE)==00) )
                                    {
                                        out.println(row);
                                        reqDateCal.add(Calendar.MINUTE, 30);
                                    }
                                    else
                                    {
                                        if(row.endsWith(","))
                                        {
                                            row=row.substring(0, row.length()-1);
                                        }
                                        out.println(row);
                                        break;
                                    }
                                }
                            %>
                                    ],
                                    columns: [
                                             { headerText: "<%= langBacking.getLiteral("time") %> " },
                                            <%
                                            String columns="";
                                            for(StisBean curStis : stisList)
                                            {
                                                columns+="{ headerText: '"+curStis.getTitle()+"<br/>("+curStis.getNosokomeio()+")' },";
                                            }
                                            columns=columns.substring(0, columns.length()-1);
                                            out.println(columns);
                                            %>
                                    ],
                                    cellStyleFormatter: function (args) {
                                        args.$cell.css("textAlign", "center");
                                        // args.row.type,   args.$cell[0].cellIndex,    
                                    }
                                });
                            });
                            </script>
                            <table id='efimeriesTable' ></table>
                            <br/>
                            <center>
                                <input type="button" value="<%= langBacking.getLiteral("next") %>" onclick="javascript: goToNextStep();" />
                            </center>
                            
                            <form id="selectedEfimeriesFormId" method="post" action="newTeleAppointment.jsp">
                                <input type="hidden" id="selectedEfimeriaId1" name="selectedEfimeriaId1" value=""/>
                                <input type="hidden" id="selectedEfimeriaId2" name="selectedEfimeriaId2" value=""/>
                                <input type="hidden" id="selectedTime1" name="selectedTime1" value=""/>
                                <input type="hidden" id="selectedTime2" name="selectedTime2" value=""/>
                            </form>
                            
                            <!-- color legend table-->
                            <table border="0">
                                <tr>
                                    <td bgcolor="orange">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("current_new_tele_appointment_selection") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFCCCC">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("pending_tele_appointment") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="#99FF99">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("completed_tele_appointment") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="#CC0000">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("tele_appointment_in_progress") %></td>
                                </tr>
                                <tr>
                                    <td bgcolor="gray">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                    <td>&nbsp;<%= langBacking.getLiteral("not_available") %></td>
                                </tr>
                            </table>
                            
                        </div>
                    </div>
                    <%
                        siteDoctorBacking.setShowAvailableEfimeriesResults(false);
                    }
                    %>
                </div>
                    
		<!-- end #content -->
            <div id="sidebar">
                <ul>
                    <li>
                        <h2><%= langBacking.getLiteral("actions") %></h2>
                        <ul>
                            <li><a href="patients.jsp"><%= langBacking.getLiteral("search_patient") %></a></li>
                            <li><a href="addNewPatient.jsp"><%= langBacking.getLiteral("add_patient") %></a></li>
                            <li><a href="emergency.jsp?patient=unknown"><%= langBacking.getLiteral("unknown_patient_emergency_case") %></a></li>
                        </ul>
                    </li>
                </ul>
            </div>
		<!-- end #sidebar -->
            <div style="clear: both;"> </div>
	</div>
    </div>
	<!-- end #page -->
        <jsp:include page="footer.jsp"/>
    </div>
    
<script type="text/javascript">
$(":input[type='text'],:input[type='password'],textarea").wijtextbox();
$("#select1").wijdropdown();
$(":input[type='radio']").wijradio();
$(":input[type='checkbox']").wijcheckbox();
$(":input[type='button']").button();
$("input[type=submit]").button();

$("#specialtySelectId1").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#specialtySelectId2").wijcombobox({
showingAnimation: { effect: "blind" },
isEditable: false,
autoFilter: true,
autoComplete: true,
highlightMatching: true,
hidingAnimation: { effect: "blind" }
});

$("#previewDatePicker").wijinputdate({
<%
if(langBacking.lang.equalsIgnoreCase("greek"))
{
    out.println("culture: 'el-GR',");
}
%>
dateFormat: '<%= langBacking.getDateFormat() %>',
date: '<%= siteDoctorBacking.getNewTeleappointment().getStartDateStr(langBacking.getDateFormat()) %>',
//date: '12/8/2012',
//dateFormat: 'dddd',
showTrigger: true
});

</script>
    
    </body>
</html>