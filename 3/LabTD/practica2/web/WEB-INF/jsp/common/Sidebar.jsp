<%-- 
    Document   : Sidebar
    Created on : 18-abr-2012, 12:38:13
    Author     : javier
--%>
<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>

<stripes:layout-definition>
    <ul>
        <li>
            <h2>Acciones</h2>
            <ul>
                <li>
                    <stripes:link
                        beanclass="${actionBean['class']}"
                        event="modify${view}">
                        Modificar
                    </stripes:link> 
                </li>
                <li>
                    <stripes:link
                        beanclass="${actionBean['class']}"
                        event="insert${view}">
                        Insertar
                    </stripes:link> 
                </li>
                <li>
                    <stripes:link
                        beanclass="${actionBean['class']}"
                        event="delete${view}">
                        Eliminar
                    </stripes:link> 
                </li>
            </ul>
        </li>
        <li>
            <h2>Vistas</h2>
            <ul>
                <li>
                    <stripes:link
                        beanclass="${actionBean['class']}"
                        event="showGrid">
                        Tabla
                    </stripes:link>
                </li>
                <li>
                    <stripes:link
                        beanclass="${actionBean['class']}"
                        event="showForm">
                        Formulario
                    </stripes:link>
                </li>
            </ul>
        </li>
    </ul>
</stripes:layout-definition>
