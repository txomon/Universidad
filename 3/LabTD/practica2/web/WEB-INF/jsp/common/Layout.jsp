<%-- 
    Document   : Layout
    Created on : 18-abr-2012, 4:26:09
    Author     : javier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<stripes:layout-definition>
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <link href="css/style.css" rel="stylesheet" type="text/css" media="screen" />
            <title>Lmb97 DataBase</title>
            <stripes:layout-component name="htmlhead">
                <stripes:layout-render name="/WEB-INF/jsp/common/HtmlHead.jsp"/>
            </stripes:layout-component>
        </head>
        <body>
            <div id="menu-wrapper">
                <div id="menu">
                    <stripes:layout-component name="topbar">
                        <stripes:layout-render name="/WEB-INF/jsp/common/TopBar.jsp"/>
                    </stripes:layout-component>
                </div>
            </div>
            <div id="header-wrapper">
                <div id="header">
                    <stripes:layout-component name="header">
                        <div id="logo">
                            <h1>
                                <stripes:link 
                                    beanclass="org.lmb97.web.action.MainActionBean">
                                    Leioako<span>Musika Banda 97</span>
                                </stripes:link>
                            </h1>
                        </div>
                    </stripes:layout-component>
                </div>
            </div>
            <div id="wrapper">
                <div id="page">
                    <div id="page-bgtop">
                        <div id="page-bgbtm">
                            <stripes:layout-component name="bodypage">
                                <div id="sidebar">
                                    <stripes:layout-component name="sidebar">
                                        <stripes:layout-render name="/WEB-INF/jsp/common/Sidebar.jsp">
                                            <stripes:param name="page" value="${actionBean['entity']}"/>
                                            <stripes:param name="view" value="${actionBean['view']}"/>
                                        </stripes:layout-render>
                                    </stripes:layout-component>
                                </div>
                                <div style="clear: both;">&nbsp;</div>
                                <div id="content">
                                    <stripes:layout-component name="content"/>
                                </div>
                            </stripes:layout-component>
                        </div>
                    </div>
                </div>
                <!-- end #page -->
            </div>
            <div id="footer">
                <stripes:layout-component name="footer">
                    <p>Copyright (c) 2012 Sitename.com. All rights reserved. Design by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>.</p>
                </stripes:layout-component>
            </div>
        </body>
    </html>
</stripes:layout-definition>