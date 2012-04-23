<%--
    Document   : FormEvents
    Created on : 19-abr-2012, 11:59:52
    Author     : javier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<stripes:layout-render name="/WEB-INF/jsp/common/Layout.jsp"  
                       class="EventsActionBean" view="Form">
    <stripes:layout-component name="content">
        <stripes:form beanclass="org.lmb97.web.action.EventsActionBean" >
            <stripes:text name="event.id" size="20" value="${actionBean.event.id}" disabled="${actionBean.readonly}" />
            <stripes:text name="event.date" size="50" value="${actionBean.event.date}" disabled="${actionBean.readonly}" />
            <stripes:select name="event.season" value="${actionBean.event.season}" disabled="${actionBean.readonly}">
                <stripes:options-collection collection="${actionBean.seasons}" value="id" label="spell" group="year"/>
            </stripes:select>
            <stripes:checkbox name="event.season.spell" value="${actionBean.event.season.spell}" disabled="${actionBean.readonly}"/>
            <stripes:select name="event.eventType" value="${actionBean.event.eventType}" disabled="${actionBean.readonly}">
                <stripes:options-collection collection="${actionBean.eventTypes}"
                                            value="id" label="name" />
            </stripes:select>
            <table>
                <thead>
                    <tr><th>Id de asistencia</th>
                        <th>Nombre</th>
                        <th>Apellidos</th>
                        <th>Hora de llegada</th>
                        <th>Razón</th></tr>
                </thead>
                <!--Se me ha ocurrido que para evitar pegarme con si la abstracción de la base de datos está bien
                o mal, puedo coger y hacerlo como un TreeMap, de tal manera que me vengan en orden los elementos
                y además, pueda refererirme a los elementos como tales.-->
                <tbody>
                    <c:forEach var="assistance" items="${actionBean.assistances}">
                        <tr>
                            <td>${assistance.id}</td>
                            <td>${actionBean.People['${Assistance.person}'].name}</td>
                            <td>${actionBean.People['${Assistance.person}'].surname}</td>
                            <td><fmt:formatDate value="${Assistance.arrival}" pattern="HH:mm" /></td>
                            <td>
                                <c:if test="${assistance.arrival}<=${actionBean.date}">
                                    A tiempo
                                </c:if>
                                <c:if test="${assistance.arrival}>${actionBean.date}">
                                    Tarde
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </stripes:form >
    </stripes:layout-component>
</stripes:layout-render>