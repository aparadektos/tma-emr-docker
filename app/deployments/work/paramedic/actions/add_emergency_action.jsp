<%@page import="beans.siteBean"%>
<%@page import="beans.SpecialtyBean"%>
<%@page import="beans.DoctorBean"%>
<%@page import="java.util.Date"%>
<%@page import="backings.LanguageBacking"%>
<%@page import="backings.ParamedicBacking"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Check login and role -->
<jsp:include page="../checkLogin.jsp"/>

<!-- imports -->
<%@page import="tools.DBHelper"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.cartBean"%>
<%@page import="beans.accountBean"%>

<!-- Initializations -->
<%
LanguageBacking langBacking = (LanguageBacking)session.getAttribute("langBacking");
ParamedicBacking paramedicBacking = (ParamedicBacking)session.getAttribute("paramedicBacking");

//get fields
request.setCharacterEncoding("UTF-8");

String targetUrl="../emergency.jsp";

if(paramedicBacking.newEmergencyCaseBean.patientBean.unknown!=null && 
   paramedicBacking.newEmergencyCaseBean.patientBean.unknown.equalsIgnoreCase("true"))
{
    String patName=request.getParameter("patName");
    String patSurname=request.getParameter("patSurname");
    String patSex=request.getParameter("patSex");
    String patMobilePhone=request.getParameter("patMobilePhone");
    String patOtherIdentifier=request.getParameter("patOtherIdentifier");
    String patHomePhone=request.getParameter("patHomePhone");
    
    paramedicBacking.newEmergencyCaseBean.patientBean.name=patName;
    paramedicBacking.newEmergencyCaseBean.patientBean.surname=patSurname;
    paramedicBacking.newEmergencyCaseBean.patientBean.sex=patSex;
    paramedicBacking.newEmergencyCaseBean.patientBean.mobilephone=patMobilePhone;
    paramedicBacking.newEmergencyCaseBean.patientBean.otherIdentifier=patOtherIdentifier;
    paramedicBacking.newEmergencyCaseBean.patientBean.homephone=patHomePhone;
    
//    paramedicBacking.insertNewUnknownPatient(paramedicBacking.newEmergencyCaseBean.patientBean);
}

if(paramedicBacking.newEmergencyCaseBean.patientBean.sex==null)
{
    paramedicBacking.errorMessage="Invalid patient";
    targetUrl="../emergency.jsp";
}
else
{
    String examRoomId=request.getParameter("examRoomId");
    if(examRoomId!=null && examRoomId.length()>0)
    {
        paramedicBacking.newEmergencyCaseBean.examRoomBean=paramedicBacking.getExamRoomById(examRoomId);
    }
    
    String erDateTime=request.getParameter("erDateTime");
    String erAge=request.getParameter("erAge");
    String erProselefsi=request.getParameter("erProselefsi");
    String erOros=request.getParameter("erOros");
    String erAllo=request.getParameter("erAllo");
    paramedicBacking.newEmergencyCaseBean.erRegForm.erAge=erAge;
    paramedicBacking.newEmergencyCaseBean.erRegForm.erProselefsi=erProselefsi;
    paramedicBacking.newEmergencyCaseBean.erRegForm.erOros=erOros;
    paramedicBacking.newEmergencyCaseBean.erRegForm.erAllo=erAllo;

    String histSymptom=request.getParameter("histSymptom");
    String histSmoker=request.getParameter("histSmoker");
    String histAlergic=request.getParameter("histAlergic");
    String histLoimodi=request.getParameter("histLoimodi");
    paramedicBacking.newEmergencyCaseBean.erRegForm.histSymptom=histSymptom;
    paramedicBacking.newEmergencyCaseBean.erRegForm.histSmoker=histSmoker;
    paramedicBacking.newEmergencyCaseBean.erRegForm.histAlergic=histAlergic;
    paramedicBacking.newEmergencyCaseBean.erRegForm.histLoimodi=histLoimodi;

    String woundAccident=request.getParameter("woundAccident");
    String woundBitten=request.getParameter("woundBitten");
    String woundCar=request.getParameter("woundCar");
    String woundWork=request.getParameter("woundWork");
    String woundFell=request.getParameter("woundFell");
    String woundCommitted=request.getParameter("woundCommitted");
    paramedicBacking.newEmergencyCaseBean.erRegForm.trauma="";
    if(woundAccident!=null && woundAccident.length()>0 && woundAccident.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma+=langBacking.getLiteral("accident")+", ";
    }
    if(woundBitten!=null && woundBitten.length()>0 && woundBitten.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma+=langBacking.getLiteral("beating")+", ";
    }
    if(woundCar!=null && woundCar.length()>0 && woundCar.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma+=langBacking.getLiteral("car_accident")+", ";
    }
    if(woundWork!=null && woundWork.length()>0 && woundWork.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma+=langBacking.getLiteral("industrial_accident")+", ";
    }
    if(woundFell!=null && woundFell.length()>0 && woundFell.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma+=langBacking.getLiteral("fall")+", ";
    }
    if(woundCommitted!=null && woundCommitted.length()>0 && woundCommitted.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma+=langBacking.getLiteral("suicide_attempt")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.trauma.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.trauma=paramedicBacking.newEmergencyCaseBean.erRegForm.trauma.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.trauma.length()-2);
    }

    String vitalTime=request.getParameter("vitalTime");
    String vitalPulses=request.getParameter("vitalPulses");
    String vitalAP=request.getParameter("vitalAP");
    String vitalInhale=request.getParameter("vitalInhale");
    String vitalSpo2=request.getParameter("vitalSpo2");
    String vitalT=request.getParameter("vitalT");
    paramedicBacking.newEmergencyCaseBean.erRegForm.vitalTime=vitalTime;
    paramedicBacking.newEmergencyCaseBean.erRegForm.vitalPulses=vitalPulses;
    paramedicBacking.newEmergencyCaseBean.erRegForm.vitalAP=vitalAP;
    paramedicBacking.newEmergencyCaseBean.erRegForm.vitalInhale=vitalInhale;
    paramedicBacking.newEmergencyCaseBean.erRegForm.vitalSpo2=vitalSpo2;
    paramedicBacking.newEmergencyCaseBean.erRegForm.vitalT=vitalT;

    String skinCold=request.getParameter("skinCold");
    String skinHot=request.getParameter("skinHot");
    String skinDry=request.getParameter("skinDry");
    String skinWet=request.getParameter("skinWet");
    String skinOxro=request.getParameter("skinOxro");
    String skinCyan=request.getParameter("skinCyan");
    String skinIkteros=request.getParameter("skinIkteros");
    paramedicBacking.newEmergencyCaseBean.erRegForm.derma="";
    if(skinCold!=null && skinCold.length()>0 && skinCold.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("cold")+", ";
    }
    if(skinHot!=null && skinHot.length()>0 && skinHot.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("hot")+", ";
    }
    if(skinDry!=null && skinDry.length()>0 && skinDry.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("dry")+", ";
    }
    if(skinWet!=null && skinWet.length()>0 && skinWet.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("wet")+", ";
    }
    if(skinOxro!=null && skinOxro.length()>0 && skinOxro.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("sallow")+", ";
    }
    if(skinCyan!=null && skinCyan.length()>0 && skinCyan.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("cyan")+", ";
    }
    if(skinIkteros!=null && skinIkteros.length()>0 && skinIkteros.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma+=langBacking.getLiteral("jaundiced")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.derma.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.derma=paramedicBacking.newEmergencyCaseBean.erRegForm.derma.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.derma.length()-2);
    }

    String erComments=request.getParameter("erComments");
    paramedicBacking.newEmergencyCaseBean.erRegForm.erComments=erComments;

    String erDocId=request.getParameter("erDocId");
    paramedicBacking.newEmergencyCaseBean.docBean=new DoctorBean("", "", "", new SpecialtyBean(), "", "", "", "", "", paramedicBacking.AB.SB);

    String genFever=request.getParameter("genFever");
    String genRigos=request.getParameter("genRigos");
    String genVixas=request.getParameter("genVixas");
    String genKatavoli=request.getParameter("genKatavoli");
    String genKakouxia=request.getParameter("genKakouxia");
    String genNaftia=request.getParameter("genNaftia");
    String genZali=request.getParameter("genZali");
    String genKsirostomia=request.getParameter("genKsirostomia");
    String genEmetos=request.getParameter("genEmetos");
    String genEriges=request.getParameter("genEriges");
    String genDiskataposia=request.getParameter("genDiskataposia");
    String genDispepsia=request.getParameter("genDispepsia");
    String genAisthimaPlirotitas=request.getParameter("genAisthimaPlirotitas");
    String genAimatemesi=request.getParameter("genAimatemesi");
    String genMelainaKenosi=request.getParameter("genMelainaKenosi");
    String genKoiliakoAlgos=request.getParameter("genKoiliakoAlgos");
    String genDiarroia=request.getParameter("genDiarroia");
    String genDiskoiliotita=request.getParameter("genDiskoiliotita");
    String genMeteorismos=request.getParameter("genMeteorismos");
    String genAskitis=request.getParameter("genAskitis");
    String genEksanthima=request.getParameter("genEksanthima");
    String genKnismos=request.getParameter("genKnismos");
    String genOidima=request.getParameter("genOidima");
    String genMethi=request.getParameter("genMethi");
    String genDilitiriasi=request.getParameter("genDilitiriasi");
    String genYpertasi=request.getParameter("genYpertasi");
    String genGlykaimia=request.getParameter("genGlykaimia");
    String genHlektrDiataraxes=request.getParameter("genHlektrDiataraxes");
    String genOther=request.getParameter("genOther");
    paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia="";
    if(genFever!=null && genFever.length()>0 && genFever.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("fever")+", ";
    }
    if(genRigos!=null && genRigos.length()>0 && genRigos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("shiver")+", ";
    }
    if(genVixas!=null && genVixas.length()>0 && genVixas.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("cough")+", ";
    }
    if(genKatavoli!=null && genKatavoli.length()>0 && genKatavoli.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("debilitation")+", ";
    }
    if(genKakouxia!=null && genKakouxia.length()>0 && genKakouxia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("hardship")+", ";
    }
    if(genNaftia!=null && genNaftia.length()>0 && genNaftia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("nausea")+", ";
    }
    if(genZali!=null && genZali.length()>0 && genZali.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("dizziness")+", ";
    }
    if(genKsirostomia!=null && genKsirostomia.length()>0 && genKsirostomia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("dry_mouth")+", ";
    }
    if(genEmetos!=null && genEmetos.length()>0 && genEmetos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("vommit")+", ";
    }
    if(genEriges!=null && genEriges.length()>0 && genEriges.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("eructation")+", ";
    }
    if(genDiskataposia!=null && genDiskataposia.length()>0 && genDiskataposia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("disingestion")+", ";
    }
    if(genDispepsia!=null && genDispepsia.length()>0 && genDispepsia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("dyspepsia")+", ";
    }
    if(genAisthimaPlirotitas!=null && genAisthimaPlirotitas.length()>0 && genAisthimaPlirotitas.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("feeling_fullness")+", ";
    }
    if(genAimatemesi!=null && genAimatemesi.length()>0 && genAimatemesi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("hematemesis")+", ";
    }
    if(genMelainaKenosi!=null && genMelainaKenosi.length()>0 && genMelainaKenosi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("melaena")+", ";
    }
    if(genKoiliakoAlgos!=null && genKoiliakoAlgos.length()>0 && genKoiliakoAlgos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("abdominal_pain")+", ";
    }
    if(genDiarroia!=null && genDiarroia.length()>0 && genDiarroia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("diarrhea")+", ";
    }
    if(genDiskoiliotita!=null && genDiskoiliotita.length()>0 && genDiskoiliotita.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("constipation")+", ";
    }
    if(genMeteorismos!=null && genMeteorismos.length()>0 && genMeteorismos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("levitation")+", ";
    }
    if(genAskitis!=null && genAskitis.length()>0 && genAskitis.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("ascites")+", ";
    }
    if(genEksanthima!=null && genEksanthima.length()>0 && genEksanthima.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("rash")+", ";
    }
    if(genKnismos!=null && genKnismos.length()>0 && genKnismos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("itch")+", ";
    }
    if(genOidima!=null && genOidima.length()>0 && genOidima.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("edema")+", ";
    }
    if(genMethi!=null && genMethi.length()>0 && genMethi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("intoxication")+", ";
    }
    if(genDilitiriasi!=null && genDilitiriasi.length()>0 && genDilitiriasi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("poisoning")+", ";
    }
    if(genYpertasi!=null && genYpertasi.length()>0 && genYpertasi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("hypertension")+", ";
    }
    if(genGlykaimia!=null && genGlykaimia.length()>0 && genGlykaimia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("glycemia")+", ";
    }
    if(genHlektrDiataraxes!=null && genHlektrDiataraxes.length()>0 && genHlektrDiataraxes.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia+=langBacking.getLiteral("HKF_diataraxes")+", ";
    }
    if(genOther!=null && genOther.length()>0)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genOther=genOther;
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia=paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.genikiSimeiologia.length()-2);
    }

    String surgAlgos=request.getParameter("surgAlgos");
    String surgOidima=request.getParameter("surgOidima");
    String surgKakosi=request.getParameter("surgKakosi");
    String surgDigma=request.getParameter("surgDigma");
    String surgKatagma=request.getParameter("surgKatagma");
    String surgKatakliseis=request.getParameter("surgKatakliseis");
    String surgAnoiktoKatagma=request.getParameter("surgAnoiktoKatagma");
    String surgApostima=request.getParameter("surgApostima");
    String surgSinthlipsi=request.getParameter("surgSinthlipsi");
    String surgDothiinas=request.getParameter("surgDothiinas");
    String surgAkrotiriasmos=request.getParameter("surgAkrotiriasmos");
    String surgAimatoma=request.getParameter("surgAimatoma");
    String surgDiamperes=request.getParameter("surgDiamperes");
    String surgEksanthima=request.getParameter("surgEksanthima");
    String surgDiatitainon=request.getParameter("surgDiatitainon");
    String surgEgkavma=request.getParameter("surgEgkavma");
    String surgKatatemaxismos=request.getParameter("surgKatatemaxismos");
    String surgThlastiko=request.getParameter("surgThlastiko");
    String surgEkdora=request.getParameter("surgEkdora");
    String surgParamorfosi=request.getParameter("surgParamorfosi");
    String surgKinitikotita=request.getParameter("surgKinitikotita");
    String surgSfikseis=request.getParameter("surgSfikseis");
    paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia="";
    if(surgAlgos!=null && surgAlgos.length()>0 && surgAlgos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("pain")+", ";
    }
    if(surgOidima!=null && surgOidima.length()>0 && surgOidima.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("edema")+", ";
    }
    if(surgKakosi!=null && surgKakosi.length()>0 && surgKakosi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("injury")+", ";
    }
    if(surgDigma!=null && surgDigma.length()>0 && surgDigma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("bite")+", ";
    }
    if(surgKatagma!=null && surgKatagma.length()>0 && surgKatagma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("fracture")+", ";
    }
    if(surgKatakliseis!=null && surgKatakliseis.length()>0 && surgKatakliseis.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("sores_ulcer")+", ";
    }
    if(surgAnoiktoKatagma!=null && surgAnoiktoKatagma.length()>0 && surgAnoiktoKatagma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("open_fracture")+", ";
    }
    if(surgApostima!=null && surgApostima.length()>0 && surgApostima.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("abscess")+", ";
    }
    if(surgSinthlipsi!=null && surgSinthlipsi.length()>0 && surgSinthlipsi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("crush")+", ";
    }
    if(surgDothiinas!=null && surgDothiinas.length()>0 && surgDothiinas.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("furuncle")+", ";
    }
    if(surgAkrotiriasmos!=null && surgAkrotiriasmos.length()>0 && surgAkrotiriasmos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("amputation")+", ";
    }
    if(surgAimatoma!=null && surgAimatoma.length()>0 && surgAimatoma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("hematoma")+", ";
    }
    if(surgDiamperes!=null && surgDiamperes.length()>0 && surgDiamperes.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("airy")+", ";
    }
    if(surgEksanthima!=null && surgEksanthima.length()>0 && surgEksanthima.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("rash")+", ";
    }
    if(surgDiatitainon!=null && surgDiatitainon.length()>0 && surgDiatitainon.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("diatitainon")+", ";
    }
    if(surgEgkavma!=null && surgEgkavma.length()>0 && surgEgkavma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("burn")+", ";
    }
    if(surgKatatemaxismos!=null && surgKatatemaxismos.length()>0 && surgKatatemaxismos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("shreding")+", ";
    }
    if(surgThlastiko!=null && surgThlastiko.length()>0 && surgThlastiko.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("receding")+", ";
    }
    if(surgEkdora!=null && surgEkdora.length()>0 && surgEkdora.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("excoriation")+", ";
    }
    if(surgParamorfosi!=null && surgParamorfosi.length()>0 && surgParamorfosi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("deformation")+", ";
    }
    if(surgKinitikotita!=null && surgKinitikotita.length()>0 && surgKinitikotita.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("mobility")+", ";
    }
    if(surgSfikseis!=null && surgSfikseis.length()>0 && surgSfikseis.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia+=langBacking.getLiteral("pulses")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia=paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.xeirourgikiSimeiologia.length()-2);
    }

    String neuroKefalalgia=request.getParameter("neuroKefalalgia");
    String neuroTetrapligia=request.getParameter("neuroTetrapligia");
    String neuroDysarthria=request.getParameter("neuroDysarthria");
    String neuroParapligia=request.getParameter("neuroParapligia");
    String neuroAimodies=request.getParameter("neuroAimodies");
    String neuroSpasmoi=request.getParameter("neuroSpasmoi");
    String neuroOptikiDiataraxi=request.getParameter("neuroOptikiDiataraxi");
    String neuroDiataraxiOmilias=request.getParameter("neuroDiataraxiOmilias");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia="";
    if(neuroKefalalgia!=null && neuroKefalalgia.length()>0 && neuroKefalalgia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("headache")+", ";
    }
    if(neuroTetrapligia!=null && neuroTetrapligia.length()>0 && neuroTetrapligia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("quadriplegia")+", ";
    }
    if(neuroDysarthria!=null && neuroDysarthria.length()>0 && neuroDysarthria.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("dysarthria")+", ";
    }
    if(neuroParapligia!=null && neuroParapligia.length()>0 && neuroParapligia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("paraplegia")+", ";
    }
    if(neuroAimodies!=null && neuroAimodies.length()>0 && neuroAimodies.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("formicary")+", ";
    }
    if(neuroSpasmoi!=null && neuroSpasmoi.length()>0 && neuroSpasmoi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("convulsions")+", ";
    }
    if(neuroOptikiDiataraxi!=null && neuroOptikiDiataraxi.length()>0 && neuroOptikiDiataraxi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("visual_disturbance")+", ";
    }
    if(neuroDiataraxiOmilias!=null && neuroDiataraxiOmilias.length()>0 && neuroDiataraxiOmilias.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia+=langBacking.getLiteral("speech_disorder")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia=paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neurologikiSimeiologia.length()-2);
    }

    String neuroParesiAristera=request.getParameter("neuroParesiAristera");
    String neuroParesiDeksia=request.getParameter("neuroParesiDeksia");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi="";
    if(neuroParesiAristera!=null && neuroParesiAristera.length()>0 && neuroParesiAristera.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi+=langBacking.getLiteral("left")+", ";
    }
    if(neuroParesiDeksia!=null && neuroParesiDeksia.length()>0 && neuroParesiDeksia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi+=langBacking.getLiteral("right")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi=paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neuroParesi.length()-2);
    }

    String neuroHmipligiaAristera=request.getParameter("neuroHmipligiaAristera");
    String neuroHmipligiaDeksia=request.getParameter("neuroHmipligiaDeksia");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia="";
    if(neuroHmipligiaAristera!=null && neuroHmipligiaAristera.length()>0 && neuroHmipligiaAristera.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia+=langBacking.getLiteral("left")+", ";
    }
    if(neuroHmipligiaDeksia!=null && neuroHmipligiaDeksia.length()>0 && neuroHmipligiaDeksia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia+=langBacking.getLiteral("right")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia=paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neuroHmipligia.length()-2);
    }

    String neuroSergParodiki=request.getParameter("neuroSergParodiki");
    String neuroSergLithargos=request.getParameter("neuroSergLithargos");
    String neuroSergLightKoma=request.getParameter("neuroSergLightKoma");
    String neuroSergDeepKoma=request.getParameter("neuroSergDeepKoma");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis="";
    if(neuroSergParodiki!=null && neuroSergParodiki.length()>0 && neuroSergParodiki.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis+=langBacking.getLiteral("transient")+", ";
    }
    if(neuroSergLithargos!=null && neuroSergLithargos.length()>0 && neuroSergLithargos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis+=langBacking.getLiteral("lethargy")+", ";
    }
    if(neuroSergLightKoma!=null && neuroSergLightKoma.length()>0 && neuroSergLightKoma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis+=langBacking.getLiteral("light_coma")+", ";
    }
    if(neuroSergDeepKoma!=null && neuroSergDeepKoma.length()>0 && neuroSergDeepKoma.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis+=langBacking.getLiteral("deep_coma")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis=paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergApoleiaSineidisis.length()-2);
    }

    String neuroSergOpenEyesOuden=request.getParameter("neuroSergOpenEyesOuden");
    String neuroSergAlgos=request.getParameter("neuroSergAlgos");
    String neuroSergProforikoAlgos=request.getParameter("neuroSergProforikoAlgos");
    String neuroSergOpenEyesAuthormita=request.getParameter("neuroSergOpenEyesAuthormita");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi="";
    if(neuroSergOpenEyesOuden!=null && neuroSergOpenEyesOuden.length()>0 && neuroSergOpenEyesOuden.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi+=langBacking.getLiteral("none")+", ";
    }
    if(neuroSergAlgos!=null && neuroSergAlgos.length()>0 && neuroSergAlgos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi+=langBacking.getLiteral("ston_pono")+", ";
    }
    if(neuroSergProforikoAlgos!=null && neuroSergProforikoAlgos.length()>0 && neuroSergProforikoAlgos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi+=langBacking.getLiteral("oral_pain")+", ";
    }
    if(neuroSergOpenEyesAuthormita!=null && neuroSergOpenEyesAuthormita.length()>0 && neuroSergOpenEyesAuthormita.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi+=langBacking.getLiteral("spontaneously")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi=paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergAnoiktoiOfthalmoi.length()-2);
    }

    String neuroSergOralOuden=request.getParameter("neuroSergOralOuden");
    String neuroSergSounds=request.getParameter("neuroSergSounds");
    String neuroSergWords=request.getParameter("neuroSergWords");
    String neuroSergSygxitiki=request.getParameter("neuroSergSygxitiki");
    String neuroSergProsanatolismeni=request.getParameter("neuroSergProsanatolismeni");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi="";
    if(neuroSergOralOuden!=null && neuroSergOralOuden.length()>0 && neuroSergOralOuden.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi+=langBacking.getLiteral("kamia")+", ";
    }
    if(neuroSergSounds!=null && neuroSergSounds.length()>0 && neuroSergSounds.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi+=langBacking.getLiteral("aloof_sounds")+", ";
    }
    if(neuroSergWords!=null && neuroSergWords.length()>0 && neuroSergWords.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi+=langBacking.getLiteral("incongruous_words")+", ";
    }
    if(neuroSergSygxitiki!=null && neuroSergSygxitiki.length()>0 && neuroSergSygxitiki.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi+=langBacking.getLiteral("confounding")+", ";
    }
    if(neuroSergProsanatolismeni!=null && neuroSergProsanatolismeni.length()>0 && neuroSergProsanatolismeni.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi+=langBacking.getLiteral("directed")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi=paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriProforikiApantisi.length()-2);
    }

    String neuroSergCineticOuden=request.getParameter("neuroSergCineticOuden");
    String neuroSergEktasiAlgos=request.getParameter("neuroSergEktasiAlgos");
    String neuroSergKampsiAlgos=request.getParameter("neuroSergKampsiAlgos");
    String neuroSergEntyposiAlgous=request.getParameter("neuroSergEntyposiAlgous");
    String neuroSergYpakoi=request.getParameter("neuroSergYpakoi");
    String neuroSergCineticAfthormita=request.getParameter("neuroSergCineticAfthormita");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi="";
    if(neuroSergCineticOuden!=null && neuroSergCineticOuden.length()>0 && neuroSergCineticOuden.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi+=langBacking.getLiteral("cinetic_none")+", ";
    }
    if(neuroSergEktasiAlgos!=null && neuroSergEktasiAlgos.length()>0 && neuroSergEktasiAlgos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi+=langBacking.getLiteral("extend_in_pain")+", ";
    }
    if(neuroSergKampsiAlgos!=null && neuroSergKampsiAlgos.length()>0 && neuroSergKampsiAlgos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi+=langBacking.getLiteral("bending_in_pain")+", ";
    }
    if(neuroSergEntyposiAlgous!=null && neuroSergEntyposiAlgous.length()>0 && neuroSergEntyposiAlgous.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi+=langBacking.getLiteral("impression_of_pain")+", ";
    }
    if(neuroSergYpakoi!=null && neuroSergYpakoi.length()>0 && neuroSergYpakoi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi+=langBacking.getLiteral("obedience_to_order")+", ";
    }
    if(neuroSergCineticAfthormita!=null && neuroSergCineticAfthormita.length()>0 && neuroSergCineticAfthormita.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi+=langBacking.getLiteral("normal_kampsi")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi=paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKalyteriKinitikiApantisi.length()-2);
    }

    String neuroSergKoresMegethosAristero=request.getParameter("neuroSergKoresMegethosAristero");
    String neuroSergKoresMegethosDeksi=request.getParameter("neuroSergKoresMegethosDeksi");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKoresMegethosAristero=neuroSergKoresMegethosAristero;
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKoresMegethosDeksi=neuroSergKoresMegethosDeksi;

    String neuroSergKoresAntidrasiDeksi=request.getParameter("neuroSergKoresAntidrasiDeksi");
    String neuroSergKoresAntidrasiAristero=request.getParameter("neuroSergKoresAntidrasiAristero");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKoresAntidrasiAristero=neuroSergKoresAntidrasiAristero;
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergKoresAntidrasiDeksi=neuroSergKoresAntidrasiDeksi;

    String neuroSergSynoloVathmwn=request.getParameter("neuroSergSynoloVathmwn");
    paramedicBacking.newEmergencyCaseBean.erRegForm.neuroSergSynoloVathmwn=neuroSergSynoloVathmwn;

    String cardioOpisthosterniko=request.getParameter("cardioOpisthosterniko");
    String cardioEpigastric=request.getParameter("cardioEpigastric");
    String cardioBack=request.getParameter("cardioBack");
    String cardioRuff=request.getParameter("cardioRuff");
    String cardioKatoGnatho=request.getParameter("cardioKatoGnatho");
    String cardioAnoGnatho=request.getParameter("cardioAnoGnatho");
    paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos="";
    if(cardioOpisthosterniko!=null && cardioOpisthosterniko.length()>0 && cardioOpisthosterniko.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos+=langBacking.getLiteral("retrosternal")+", ";
    }
    if(cardioEpigastric!=null && cardioEpigastric.length()>0 && cardioEpigastric.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos+=langBacking.getLiteral("epigastric")+", ";
    }
    if(cardioBack!=null && cardioBack.length()>0 && cardioBack.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos+=langBacking.getLiteral("back")+", ";
    }
    if(cardioRuff!=null && cardioRuff.length()>0 && cardioRuff.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos+=langBacking.getLiteral("ruff")+", ";
    }
    if(cardioKatoGnatho!=null && cardioKatoGnatho.length()>0 && cardioKatoGnatho.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos+=langBacking.getLiteral("mandible")+", ";
    }
    if(cardioAnoGnatho!=null && cardioAnoGnatho.length()>0 && cardioAnoGnatho.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos+=langBacking.getLiteral("maxillary")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos=paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.cardioThorakikoAlgos.length()-2);
    }

    String cardioPiesi=request.getParameter("cardioPiesi");
    String cardioPniksimo=request.getParameter("cardioPniksimo");
    String cardioSfiksimo=request.getParameter("cardioSfiksimo");
    String cardioVaros=request.getParameter("cardioVaros");
    String cardioKafsos=request.getParameter("cardioKafsos");
    paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras="";
    if(cardioPiesi!=null && cardioPiesi.length()>0 && cardioPiesi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras+=langBacking.getLiteral("pressure")+", ";
    }
    if(cardioPniksimo!=null && cardioPniksimo.length()>0 && cardioPniksimo.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras+=langBacking.getLiteral("strangulation")+", ";
    }
    if(cardioSfiksimo!=null && cardioSfiksimo.length()>0 && cardioSfiksimo.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras+=langBacking.getLiteral("tightening")+", ";
    }
    if(cardioVaros!=null && cardioVaros.length()>0 && cardioVaros.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras+=langBacking.getLiteral("weight")+", ";
    }
    if(cardioKafsos!=null && cardioKafsos.length()>0 && cardioKafsos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras+=langBacking.getLiteral("burning")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras=paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.cardioXaraktiras.length()-2);
    }

    String cardioStress=request.getParameter("cardioStress");
    String cardioEating=request.getParameter("cardioEating");
    String cardioHremia=request.getParameter("cardioHremia");
    paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi="";
    if(cardioStress!=null && cardioStress.length()>0 && cardioStress.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi+=langBacking.getLiteral("stress")+", ";
    }
    if(cardioEating!=null && cardioEating.length()>0 && cardioEating.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi+=langBacking.getLiteral("after_eating")+", ";
    }
    if(cardioHremia!=null && cardioHremia.length()>0 && cardioHremia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi+=langBacking.getLiteral("tranquility")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi=paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.cardioEnarxi.length()-2);
    }

    String cardio20_30=request.getParameter("cardio20_30");
    String cardioGreaterOf20=request.getParameter("cardioGreaterOf20");
    String cardioOres=request.getParameter("cardioOres");
    paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia="";
    if(cardio20_30!=null && cardio20_30.length()>0 && cardio20_30.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia+=langBacking.getLiteral("20_to_30_min")+", ";
    }
    if(cardioGreaterOf20!=null && cardioGreaterOf20.length()>0 && cardioGreaterOf20.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia+=langBacking.getLiteral("gt_of_20_min")+", ";
    }
    if(cardioOres!=null && cardioOres.length()>0 && cardioOres.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia+=langBacking.getLiteral("hours")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia=paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.cardioDiarkeia.length()-2);
    }

    String cardioAisthimaPalmwn=request.getParameter("cardioAisthimaPalmwn");
    String cardioOidimaKatwAkrwn=request.getParameter("cardioOidimaKatwAkrwn");
    String cardioDispnoia=request.getParameter("cardioDispnoia");
    String cardioAimoptisi=request.getParameter("cardioAimoptisi");
    String cardioSygkrotikesLipothimia=request.getParameter("cardioSygkrotikesLipothimia");
    String cardioKyanosi=request.getParameter("cardioKyanosi");
    String cardioPleftodynia=request.getParameter("cardioPleftodynia");
    String cardioVixas=request.getParameter("cardioVixas");
    paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia="";
    if(cardioAisthimaPalmwn!=null && cardioAisthimaPalmwn.length()>0 && cardioAisthimaPalmwn.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("palpirations")+", ";
    }
    if(cardioOidimaKatwAkrwn!=null && cardioOidimaKatwAkrwn.length()>0 && cardioOidimaKatwAkrwn.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("leg_swelling")+", ";
    }
    if(cardioDispnoia!=null && cardioDispnoia.length()>0 && cardioDispnoia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("breathlessness")+", ";
    }
    if(cardioAimoptisi!=null && cardioAimoptisi.length()>0 && cardioAimoptisi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("haemoptysis")+", ";
    }
    if(cardioSygkrotikesLipothimia!=null && cardioSygkrotikesLipothimia.length()>0 && cardioSygkrotikesLipothimia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("repeated_crises_fainting")+", ";
    }
    if(cardioKyanosi!=null && cardioKyanosi.length()>0 && cardioKyanosi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("cyanosis")+", ";
    }
    if(cardioPleftodynia!=null && cardioPleftodynia.length()>0 && cardioPleftodynia.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("pleftodynia")+", ";
    }
    if(cardioVixas!=null && cardioVixas.length()>0 && cardioVixas.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia+=langBacking.getLiteral("cough")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia=paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.cardioanapneustikiSimeiologia.length()-2);
    }

    String psychoAgxodeis=request.getParameter("psychoAgxodeis");
    String psychoKatathlipsi=request.getParameter("psychoKatathlipsi");
    paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi="";
    if(psychoAgxodeis!=null && psychoAgxodeis.length()>0 && psychoAgxodeis.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi+=langBacking.getLiteral("anxious")+", ";
    }
    if(psychoKatathlipsi!=null && psychoKatathlipsi.length()>0 && psychoKatathlipsi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi+=langBacking.getLiteral("depression")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi=paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.psychoDiathesi.length()-2);
    }

    String psychoEpithetikos=request.getParameter("psychoEpithetikos");
    String psychoDiegertikos=request.getParameter("psychoDiegertikos");
    paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora="";
    if(psychoEpithetikos!=null && psychoEpithetikos.length()>0 && psychoEpithetikos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora+=langBacking.getLiteral("aggressive")+", ";
    }
    if(psychoDiegertikos!=null && psychoDiegertikos.length()>0 && psychoDiegertikos.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora+=langBacking.getLiteral("stimulating")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora=paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSymperifora.length()-2);
    }

    String psychoParaisthiseis=request.getParameter("psychoParaisthiseis");
    String psychoParalirima=request.getParameter("psychoParalirima");
    String psychoSygxisi=request.getParameter("psychoSygxisi");
    paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis="";
    if(psychoParaisthiseis!=null && psychoParaisthiseis.length()>0 && psychoParaisthiseis.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis+=langBacking.getLiteral("hallucinations")+", ";
    }
    if(psychoParalirima!=null && psychoParalirima.length()>0 && psychoParalirima.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis+=langBacking.getLiteral("delirium")+", ";
    }
    if(psychoSygxisi!=null && psychoSygxisi.length()>0 && psychoSygxisi.equalsIgnoreCase("on"))
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis+=langBacking.getLiteral("confusion")+", ";
    }
    if(paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis.endsWith(", ")==true)
    {
        paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis=paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis.substring(0, paramedicBacking.newEmergencyCaseBean.erRegForm.psychoSkepseis.length()-2);
    }

    paramedicBacking.newEmergencyCaseBean.caseDate=new Date();
    
    if(paramedicBacking.newEmergencyCaseBean.examRoomBean!=null)
    {
        if(paramedicBacking.insertNewEmergencyCase()==true)
        {
            paramedicBacking.okMessage=langBacking.getLiteral("add_emergency_ok");
            paramedicBacking.newEmergencyCaseBean=null;
        }
        else
        {
            paramedicBacking.errorMessage=langBacking.getLiteral("add_emergency_failed");
        }
    }
    else
    {
        paramedicBacking.infoMessage=langBacking.getLiteral("add_emergency_required_fields");
    }
}


response.sendRedirect(targetUrl);

%>