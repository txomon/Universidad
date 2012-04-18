<%-- 
    Document   : IncludeTop
    Created on : 18-abr-2012, 1:27:07
    Author     : javier
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

    <head>
        <link rel="StyleSheet" href="../css/jpetstore.css" type="text/css"
              media="screen" />

        <title>Lmb97 DataBase</title>
        <meta content="text/html; charset=windows-1252"
              http-equiv="Content-Type" />
        <meta http-equiv="Cache-Control" content="max-age=0" />
        <meta http-equiv="Cache-Control" content="no-cache" />
        <meta http-equiv="expires" content="0" />
        <meta http-equiv="Expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
        <meta http-equiv="Pragma" content="no-cache" />
    </head>
    <body>
        <div id="menu-wrapper">
            <div id="menu">
                <ul>
                    <li>
                        <stripes:link
                            beanclass="org.lmb97.web.actions.PeopleActionBean"
                            event="viewGrid">
                            Personas
                        </stripes:link> 
                    </li>
                    <li>
                        <stripes:link
                            beanclass="org.lmb97.web.actions.AssistencesActionBean"
                            event="viewGrid">
                            Asistencias
                        </stripes:link> 
                    </li>
                    <li>
                        <stripes:link
                            beanclass="org.lmb97.web.actions.MusicsheetsActionBean"
                            event="viewGrid">
                            Partituras
                        </stripes:link> 
                    </li>
                </ul>
            </div>
        </div>
        <div id="header-wrapper">
            <div id="header">
                <div id="logo">
                    <h1><stripes:link 
                            beanclass="org.lmb97.web.actions.StartActionBean">
                            Leioako<span>Musika Banda 97</span>
                        </stripes:link>
                    </h1>
                </div>
            </div>
        </div>
        <div id="wrapper">
            <div id="page">
                <div id="page-bgtop">
                    <div id="page-bgbtm">
                        <div id="sidebar">
                            <ul>
                                <li>
                                    <h2>Acciones</h2>
                                    <ul>
                                        <li>Modificar</li>
                                        <li>
                                            <stripes:link
                                                beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
                                                event="viewCategory">
                                                <stripes:param name="categoryId" value="FISH" />
                                                <img src="../images/sm_fish.gif" />
                                            </stripes:link> 
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>