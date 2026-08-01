<%@page import="java.util.Date"%>
<div id="footer-bgcontent">
    <div id="footer">
        <p>Copyright <%=new Date().getYear()+1900 %> <a target="_new" href="http://www.telemed.gr">Telematic Medical Applications</a> 
            <br/>
            All rights reserved</p>
    </div>
</div>
<!-- end #footer -->


<script language="javascript">   
var xmlhttp=new XMLHttpRequest();
xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState==4 && xmlhttp.status==200) {
        //document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
        if(xmlhttp.responseText!=null && xmlhttp.responseText.trim().length>0)
        {
            //alert(xmlhttp.responseText);
            alert("New message.......");
        }
    }
}

var minutesInterval=1;//minutes

function checkForNewMessages(minutesInterval)
{
    var url = "actions/checkForNewMessages.jsp?minutesInterval="+minutesInterval;
    xmlhttp.open("POST",url,true);
    xmlhttp.send();
}

setInterval(function () {checkForNewMessages(minutesInterval)}, 1000*60*minutesInterval);//1000m=1sec, 1000*60=1min, 1000*60*5=5min
</script>