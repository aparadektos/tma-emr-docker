

<%@page import="beans.ConsultantBean"%>
<%@page import="backings.ParamedicBacking"%>
<%@page import="backings.LanguageBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");
%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="keywords" content=""/>
        <meta name="description" content=""/>
        <link href="../popupStyle.css" rel="stylesheet" type="text/css" media="screen"/>
        
        
    </head>

<!-- Javascript functions  -->
<script language="javascript">
    
</script>
    
    <body >

    <div id="wrapper">
	
	<div id="page">
            <div id="page-bgtop">
                <div id="content">
                    <div class="post">
                        <div class="entry">
                            <%
                            String selectedConsId=request.getParameter("consId");
                            String consHash=request.getParameter("consHash");
                            ConsultantBean selectedConsultant = null;
                            if(selectedConsId!=null && selectedConsId.length()>0)
                            {
                                selectedConsultant=paramedicBacking.DBH.getConsultantById(selectedConsId);
                            }
                            else if(consHash!=null && consHash.length()>0)
                            {
                                selectedConsultant=paramedicBacking.getConsultantFromTeleAppointmentsResults(consHash);
                            }
                            
                            if(selectedConsultant!=null && selectedConsultant.getId()!=null && selectedConsultant.getId().length()>0)
                            {
                                if(selectedConsultant.getPhotoBytes()==null)
                                {
                                    selectedConsultant.setPhotoBytes(paramedicBacking.DBH.getPhotoBytesByConsultantId(selectedConsultant.getId()));
                                }
                                out.println("<table border='0' width='100%'>");
                                    out.println("<tr>");
                                        out.println("<td width='50px' valign='top'>");
                                            if(selectedConsultant.getPhotoBytes()!=null && selectedConsultant.getPhotoBytes().length>0)
                                            {
                                                out.println("<img src='data:image/jpg;base64,"+selectedConsultant.getPhotoByteArrayString()+"' style='max-width:400px; max-height: 250px;float:left;' />");
                                            }
                                            else
                                            {
                                                out.println("<img src='../images/doc.jpg' style='max-width:200px; max-height: 80px;float:left;'/>");
                                            }
                                            out.println("<br/>");
                                            out.println("<b>"+langBacking.getLiteral("name_surname")+"</b>: "+selectedConsultant.getFullName());
                                            out.println("<br/>");
                                            out.println("<br/>");
                                            out.println("<b>"+langBacking.getLiteral("specialty")+"</b>: "+selectedConsultant.getSpecialtyBean().getNameByLang(langBacking.lang));
                                            out.println("<br/>");
                                            out.println("<br/>");
                                            out.println("<b>"+langBacking.getLiteral("work_phone")+"</b>: "+selectedConsultant.getWorkphone());
                                            out.println("<br/>");
                                            out.println("<br/>");
                                            out.println("<b>"+langBacking.getLiteral("email")+"</b>: "+selectedConsultant.getEmail());
                                        out.println("</td>");
                                        out.println("<td>");
                                            out.println("<textarea readonly style='width:100%;' rows='23'>"+selectedConsultant.getShortCv()+"</textarea>");
                                        out.println("</td>");
                                    out.println("</tr>");
                                out.println("</table>");
                            }
                            else
                            {
                                out.println(langBacking.getLiteral("invalid_consultant"));
                            }
                            %>
                            
                            
                        </div>
                    </div>

                </div>
		<!-- end #content -->

		<div style="clear: both;"> </div>
                
            </div>
        </div>
            
    </div>
    
    </body>

</html>