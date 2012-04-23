<%-- 
    Document   : GridAssistances
    Created on : 19-abr-2012, 12:00:05
    Author     : javier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<stripes:layout-render name="/WEB-INF/jsp/common/Layout.jsp" view="Grid">
    <stripes:layout-component name="content">
        <stripes:form beanclass="org.lmb97.web.action.EventsActionBean">
            <table>
                <thead>
                    <tr>
                        <th>Id de evento</th>
                        <th>Tipo</th>
                        <th>Hora de llegada prevista</th>
                        <th>Asistentes totales</th>
                        <th>Asistentes puntuales</th>
                        <th>Asistentes impuntuales</th>
                    </tr>
                </thead>
                <!--Se me ha ocurrido que para evitar pegarme con si la abstracción de la base de datos está bien
                o mal, puedo coger y hacerlo como un TreeMap, de tal manera que me vengan en orden los elementos
                y además, pueda refererirme a los elementos como tales.-->
                <tbody>
                    <c:forEach var="Event" items="${actionBean.events}">
                        <tr>
                            <td>${Event.id}</td>
                            <td>
                                <stripes:select name="Event.eventType" value="${Event.eventType}" disabled="${actionBean.readonly}">
                                    <stripes:options-collection collection="${actionBean.eventTypes}"
                                                                label="name" id="id"/>
                                </stripes:select>
                            </td>
                            <td><fmt:formatDate value="${Event.date}" pattern="yyyy-MM-dd HH:mm" /></td>
                            <td>${actionBean.totalassistants[Event.id]}</td>
                            <td>${actionBean.ontimeassistants[Event.id]}</td>
                            <td>${actionBean.totalassistants[Event.id] - actionBean.ontimeassistants[Event.id]}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </stripes:form>
    </stripes:layout-component>
</stripes:layout-render>