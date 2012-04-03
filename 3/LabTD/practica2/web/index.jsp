<%-- 
    Document   : index
    Created on : 27-mar-2012, 11:45:05
    Author     : javier
--%>

<%@page import="java.rmi.Remote"%>
<%@page import="org.txomon.Database"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

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
                    <li class="current_page_item"><a>Personas</a></li>
                    <li><a>Cargos</a></li>
                    <li><a>Partituras</a></li>
                    <li><a>Temporadas</a></li>
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
                        <div id="content">
                            <div class="post">
                                <h2 class="title"><a href="#">Bienvenido a Leioako Musika Banda</a></h2>
                                <p class="meta"><span class="date">April 1, 2012</span><span class="posted">Posted by <a href="#">Someone</a></span></p>
                                <div style="clear: both;">&nbsp;</div>
                                <div class="entry">
                                    <p>This is <strong>Hand Crafted </strong>, a free, fully standards-compliant CSS template designed by FreeCssTemplates<a href="http://www.nodethirtythree.com/"></a> for <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>.  This free template is released under a <a href="http://creativecommons.org/licenses/by/2.5/">Creative Commons Attributions 2.5</a> license, so you’re pretty much free to do whatever you want with it (even use it commercially) provided you keep the links in the footer intact. Aside from that, have fun with it :)</p>
                                    <p>Sed lacus. Donec lectus. Nullam pretium nibh ut turpis. Nam bibendum. In nulla tortor, elementum ipsum. Proin imperdiet est. Phasellus dapibus semper urna. Pellentesque ornare, orci in felis. Donec ut ante. In id eros. Suspendisse lacus turpis, cursus egestas at sem.</p>
                                    <p class="links"><a href="#">Read More</a>&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<a href="#">Comments</a></p>
                                </div>
                            </div>
                            <div class="post">
                                <h2 class="title"><a href="#">Lorem ipsum sed aliquam</a></h2>
                                <p class="meta"><span class="date">March 25, 2012</span><span class="posted">Posted by <a href="#">Someone</a></span></p>
                                <div style="clear: both;">&nbsp;</div>
                                <div class="entry">
                                    <p>Sed lacus. Donec lectus. Nullam pretium nibh ut turpis. Nam bibendum. In nulla tortor, elementum vel, tempor at, varius non, purus. Mauris vitae nisl nec metus placerat consectetuer. Donec ipsum. Proin imperdiet est. Phasellus <a href="#">dapibus semper urna</a>. Pellentesque ornare, orci in consectetuer hendrerit, urna elit eleifend nunc, ut consectetuer nisl felis ac diam. Etiam non felis. Donec ut ante. In id eros. Suspendisse lacus turpis, cursus egestas at sem.  Mauris quam enim, molestie in, rhoncus ut, lobortis a, est. Suspendisse lacus turpis, cursus egestas at sem. Sed lacus. Donec lectus. </p>
                                    <p class="links"><a href="#">Read More</a>&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<a href="#">Comments</a></p>
                                </div>
                            </div>
                            <div class="post">
                                <h2 class="title"><a href="#">Consecteteur hendrerit </a></h2>
                                <p class="meta"><span class="date">March 15, 2012</span><span class="posted">Posted by <a href="#">Someone</a></span></p>
                                <div style="clear: both;">&nbsp;</div>
                                <div class="entry">
                                    <p>Sed lacus. Donec lectus. Nullam pretium nibh ut turpis. Nam bibendum. In nulla tortor, elementum vel, tempor at, varius non, purus. Mauris vitae nisl nec metus placerat consectetuer. Donec ipsum. Proin imperdiet est. Phasellus <a href="#">dapibus semper urna</a>. Pellentesque ornare, orci in consectetuer hendrerit, urna elit eleifend nunc, ut consectetuer nisl felis ac diam. Etiam non felis. Donec ut ante. In id eros. Suspendisse lacus turpis, cursus egestas at sem.  Mauris quam enim, molestie in, rhoncus ut, lobortis a, est. Sed lacus. Donec lectus. Nullam pretium nibh ut turpis. Nam bibendum. </p>
                                    <p class="links"><a href="#">Read More</a>&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;<a href="#">Comments</a></p>
                                </div>
                            </div>
                            <!--<div style="clear: both;">&nbsp;</div>-->
                        </div>
				<!-- end #content -->
                        <div id="sidebar">
                            <ul>
                                <li>
                                    <h2>Search Here:</h2>
                                    <div id="search" >
                                        <form method="get" action="#">
                                            <div>
                                                <input type="text" name="s" id="search-text" value="" />
                                                <input type="submit" id="search-submit" value="" />
                                            </div>
                                        </form>
                                    </div>
                                    <div style="clear: both;">&nbsp;</div>
                                </li>
                                <li>
                                    <h2>Aliquam tempus</h2>
                                    <p>Mauris vitae nisl nec metus placerat perdiet est. Phasellus dapibus semper consectetuer hendrerit.</p>
                                </li>
                                <li>
                                    <h2>Categories</h2>
                                    <ul>
                                        <li><a href="#">Aliquam libero</a></li>
                                        <li><a href="#">Consectetuer adipiscing elit</a></li>
                                        <li><a href="#">Metus aliquam pellentesque</a></li>
                                        <li><a href="#">Suspendisse iaculis mauris</a></li>
                                        <li><a href="#">Urnanet non molestie semper</a></li>
                                        <li><a href="#">Proin gravida orci porttitor</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <h2>Blogroll</h2>
                                    <ul>
                                        <li><a href="#">Aliquam libero</a></li>
                                        <li><a href="#">Consectetuer adipiscing elit</a></li>
                                        <li><a href="#">Metus aliquam pellentesque</a></li>
                                        <li><a href="#">Suspendisse iaculis mauris</a></li>
                                        <li><a href="#">Urnanet non molestie semper</a></li>
                                        <li><a href="#">Proin gravida orci porttitor</a></li>
                                    </ul>
                                </li>
                                <li>
                                    <h2>Archives</h2>
                                    <ul>
                                        <li><a href="#">Aliquam libero</a></li>
                                        <li><a href="#">Consectetuer adipiscing elit</a></li>
                                        <li><a href="#">Metus aliquam pellentesque</a></li>
                                        <li><a href="#">Suspendisse iaculis mauris</a></li>
                                        <li><a href="#">Urnanet non molestie semper</a></li>
                                        <li><a href="#">Proin gravida orci porttitor</a></li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
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
