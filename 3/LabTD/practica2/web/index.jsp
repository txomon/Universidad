<%-- 
    Document   : index
    Created on : 27-mar-2012, 11:45:05
    Author     : javier
--%>

<%@ taglib prefix="stripes" uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@page import="javax.print.attribute.standard.PagesPerMinute"%>
<%@page import="java.util.*"%>
<%@page import="java.rmi.Remote"%>
<%@page import="org.txomon.Database"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>

<%!
    Map<String,String> pages=new LinkedHashMap<String,String>();
    Map<String,String> actions=new LinkedHashMap<String,String>();
%>
<%
    // Initializing the pages map   
    pages.put("home","Inicio");
    pages.put("people","Personas");
    pages.put("assists","Asistencias");
    pages.put("musicsheets","Partituras");

    // Initialize the states map
    actions.put("insert","Insertar");
    actions.put("modify","Modificar");
    actions.put("delete","Eliminar");

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>LMB Inicio</title>
        <link href="css/style.css" rel="stylesheet" type="text/css" media="screen" />
    </head>
    <body>
        <div id="menu-wrapper">
            <div id="menu">
                <ul>
                    <%
                        Map.Entry<String,String> n;
                        Iterator it;
                        try{ 
                            it=pages.entrySet().iterator();
                            while(it.hasNext()){
                                n=(Map.Entry<String,String>)it.next();
                                out.print("<li");
                                System.out.println("The requested page is "+request.getParameter("page"));
                                System.out.println("The actual menu creation point is "+n.getKey());
                                if(((request.getParameter("page")!=null) && (n.getKey().equals(request.getParameter("page"))))
                                        ||(request.getParameter("page")==null&&n.getKey().equals("home"))){
                                    System.out.println("Requested page equals to the current menu creation");
                                    out.print(" class=\"current_page_item\"");
                                }
                                out.print("><a href=\""+request.getRequestURL()+"?page="+
                                        n.getKey()+"\">"+n.getValue()+"</a></li>\n");
                            }
                        }catch(java.util.NoSuchElementException ex){ }
                    %>
                </ul>
            </div>
        </div>
        <div id="header-wrapper">
            <div id="header">
                <div id="logo">
                    <h1><a>Leioako<span>Musika Banda 97</span></a></h1>
                </div>
            </div>
        </div>
        <div id="wrapper">
            <div id="page">
                <div id="page-bgtop">
                    <div id="page-bgbtm">
                        <% if("home".equals(request.getParameter("page"))||request.getParameter("page")==null){%>
                            <div class="post">
                                <h2 class="title">Bienvenido a Leioako Musika Banda</h2>
                                <div style="clear: both;">&nbsp;</div>
                                <div class="entry">
                                    <p>Esta es la interfaz web hacia la base de datos de la banda, que aunque de momento está en desarrollo, esperamos esté preparada para la nueva temporada</p>
                                    <p>Lorem ipsum ad his scripta blandit partiendo, eum fastidii accumsan euripidis in, eum liber hendrerit an. Qui ut wisi vocibus suscipiantur, quo dicit ridens inciderint id. Quo mundi lobortis reformidans eu, legimus senserit definiebas an eos. Eu sit tincidunt incorrupte definitionem, vis mutat affert percipit cu, eirmod consectetuer signiferumque eu per. In usu latine equidem dolores. Quo no falli viris intellegam, ut fugit veritus placerat per. Ius id vidit volumus mandamus, vide veritus democritum te nec, ei eos debet libris consulatu. No mei ferri graeco dicunt, ad cum veri accommodare. Sed at malis omnesque delicata, usu et iusto zzril meliore. Dicunt maiorum eloquentiam cum cu, sit summo dolor essent te. Ne quodsi nusquam legendos has, ea dicit voluptua eloquentiam pro, ad sit quas qualisque. Eos vocibus deserunt quaestio ei. Blandit incorrupte quaerendum in quo, nibh impedit id vis, vel no nullam semper audiam. Ei populo graeci consulatu mei, has ea stet modus phaedrum. Inani oblique ne has, duo et veritus detraxit. Tota ludus oratio ea mel, offendit persequeris ei vim. Eos dicat oratio partem ut, id cum ignota senserit intellegat. Sit inani ubique graecis ad, quando graecis liberavisse et cum, dicit option eruditi at duo. Homero salutatus suscipiantur eum id, tamquam voluptaria expetendis ad sed, nobis feugiat similique usu ex. Eum hinc argumentum te, no sit percipit adversarium, ne qui feugiat persecuti. Odio omnes scripserit ad est, ut vidit lorem maiestatis his, putent mandamus gloriatur ne pro. Oratio iriure rationibus ne his, ad est corrumpit splendide. Ad duo appareat moderatius, ei falli tollit denique eos. Dicant evertitur mei in, ne his deserunt perpetua sententiae, ea sea omnes similique vituperatoribus. Ex mel errem intellegebat comprehensam, vel ad tantas antiopam delicatissimi, tota ferri affert eu nec. Legere expetenda pertinacia ne pro, et pro impetus persius assueverit. Ea mei nullam facete, omnis oratio offendit ius cu. Doming takimata repudiandae usu an, mei dicant takimata id, pri eleifend inimicus euripidis at. His vero singulis ea, quem euripidis abhorreant mei ut, et populo iriure vix. Usu ludus affert voluptaria ei, vix ea error definitiones, movet fastidii signiferumque in qui. Vis prodesset adolescens adipiscing te, usu mazim perfecto recteque at, assum putant erroribus mea in. Vel facete imperdiet id, cum an libris luptatum perfecto, vel fabellas inciderint ut. Veri facete debitis ea vis, ut eos oratio erroribus. Sint facete perfecto no vel, vim id omnium insolens. Vel dolores perfecto pertinacia ut, te mel meis ullum dicam, eos assum facilis corpora in. Mea te unum viderer dolores, nostrum detracto nec in, vis no partem definiebas constituam. Dicant utinam philosophia has cu, hendrerit prodesset at nam, eos an bonorum dissentiet. Has ad placerat intellegam consectetuer, no adipisci mandamus senserit pro, torquatos similique percipitur est ex. Pro ex putant deleniti repudiare, vel an aperiam sensibus suavitate. Ad vel epicurei convenire, ea soluta aliquid deserunt ius, pri in errem putant feugiat. Sed iusto nihil populo an, ex pro novum homero cotidieque. Te utamur civibus eleifend qui, nam ei brute doming concludaturque, modo aliquam facilisi nec no. Vidisse maiestatis constituam eu his, esse pertinacia intellegam ius cu. Eos ei odio veniam, eu sumo altera adipisci eam, mea audiam prodesset persequeris ea. Ad vitae dictas vituperata sed, eum posse labore postulant id. Te eligendi principes dignissim sit, te vel dicant officiis repudiandae. Id vel sensibus honestatis omittantur, vel cu nobis commune patrioque. In accusata definiebas qui, id tale malorum dolorem sed, solum clita phaedrum ne his. Eos mutat ullum forensibus ex, wisi perfecto urbanitas cu eam, no vis dicunt impetus. Assum novum in pri, vix an suavitate moderatius, id has reformidans referrentur. Elit inciderint omittantur duo ut, dicit democritum signiferumque eu est, ad suscipit delectus mandamus duo. An harum equidem maiestatis nec. At has veri feugait placerat, in semper offendit praesent his. Omnium impetus facilis sed at, ex viris tincidunt ius. Unum eirmod dignissim id quo. Sit te atomorum quaerendum neglegentur, his primis tamquam et. Eu quo quot veri alienum, ea eos nullam luptatum accusamus. Ea mel causae phaedrum reprimique, at vidisse dolores ocurreret nam.
                                    </p>
                                </div>
                            </div>
                            <!--<div style="clear: both;">&nbsp;</div>-->
                        <% }else{ %>
                        <div id="content">
                        <%
                             
                        %>
                        </div>
                        <div id="sidebar">
                            <ul>
                                <li>
                                    <h2>Acciones</h2>
                                    <ul>
                                        <%
                                        try{
                                            it=actions.entrySet().iterator();
                                            while(it.hasNext()){
                                                n=(Map.Entry<String,String>)it.next();
                                                out.print("<li>");
                                                System.out.println("The requested action is "+request.getParameter("action"));
                                                System.out.println("The actual action menu creation point is "+n.getKey());
                                                if(request.getParameter("action")==null || !n.getKey().equals(request.getParameter("action"))){
                                                    System.out.println("Requested page equals to the current menu creation");
                                                    out.print("<a href=\"" + request.getRequestURL()+"?page="+request.getParameter("page")
                                                    +"&action="+n.getKey()+"\">"+n.getValue()+"</a></li>\n");
                                                }else{
                                                    out.print(n.getValue()+"</li>");
                                                }
                                                
                                            }
                                        }catch(java.util.NoSuchElementException ex){ }
                                        %>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <% } %>
                        <!-- end #sidebar -->
                        <div style="clear: both;">&nbsp;</div>
                    </div>
                </div>
            </div>
            <!-- end #page -->
        </div>
        <div id="footer">
            <p>Copyright (c) 2012 Sitename.com. All rights reserved. Design by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>.</p>
        </div>
    </body>
</html>
