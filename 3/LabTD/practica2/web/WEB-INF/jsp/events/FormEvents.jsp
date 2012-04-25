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


<stripes:layout-render name="/WEB-INF/jsp/common/Layout.jsp" view="Form">
    <stripes:layout-component name="content">
        <stripes:form beanclass="org.lmb97.web.action.EventsActionBean" >
            <stripes:label name="event.id">Id:</stripes:label>
            <stripes:text name="event.id" value="event.id" disabled="true" />
            <stripes:errors field="event.id"/>
            <br/>
            <stripes:label name="event.date">Fecha:</stripes:label>
            <stripes:text name="event.date" value="event.date" formatPattern="yyyy/MM/dd HH:mm" disabled="${actionBean.readonly}" />
            <stripes:errors field="event.date"/>
            <br/>
            <stripes:label name="event.season">Temporada:</stripes:label>
            <stripes:select name="event.season" value="event.season" disabled="${actionBean.readonly}">
                <stripes:options-collection collection="${actionBean.seasons}" value="id"/>
            </stripes:select>
            <stripes:errors field="event.season"/>
            <br/>
            Event Type:<stripes:select name="event.eventType" value="event.eventType" disabled="${actionBean.readonly}">
                <stripes:options-collection collection="${actionBean.eventTypes}" value="id" label="name" />
            </stripes:select><br/>
            <table>
                <thead>
                    <tr><th>Id de asistencia</th>
                        <th>Persona</th>
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
                            <td>
                                <stripes:select name="assistance.person" value="${assistance.person}" disabled="${actionBean.readonly}">
                                    <stripes:options-map map="${actionBean.peoplenames}"/>
                                </stripes:select>
                            </td>
                            <td><fmt:formatDate value="${assistance.arrival}" pattern="HH:mm" /></td>
                            <td>
                                <c:if test="${assistance.arrival<=actionBean.event.date}">
                                    A tiempo
                                </c:if>
                                <c:if test="${assistance.arrival>actionBean.event.date}">
                                    Tarde
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${!actionBean.readonly}">
                <stripes:submit name="saveForm" value="Save changes"/>
            </c:if>
        </stripes:form >
    </stripes:layout-component>
</stripes:layout-render>