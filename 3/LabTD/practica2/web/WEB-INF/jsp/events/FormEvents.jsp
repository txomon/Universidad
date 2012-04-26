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
            <stripes:label name="event.id">${actionBean.previous}Id:${actionBean.following}</stripes:label>
            <stripes:text name="event.id" value="event.id" disabled="true" />
            <stripes:errors field="event.id"/>
            <br/>
            <stripes:label name="event.date">Fecha:</stripes:label>
            <stripes:text name="event.date" value="event.date" formatPattern="yyyy/MM/dd HH:mm" disabled="${actionBean.readonly}" />
            <stripes:errors field="event.date"/>
            <br/>
            <stripes:label name="event.season">Temporada:</stripes:label>
            <stripes:select name="event.season" value="event.season" disabled="${actionBean.readonly}">
                <stripes:options-collection collection="${actionBean.seasons}" value="id" />
            </stripes:select>
            <stripes:errors field="event.season"/>
            <br/>
            <stripes:label name="event.eventType">Event Type:</stripes:label>
            <stripes:select name="event.eventType" value="event.eventType" disabled="${actionBean.readonly}">
                <stripes:options-collection collection="${actionBean.eventTypes}" value="id" label="name" />
            </stripes:select>
            <stripes:errors field="event.eventType"/>
            <br/>
            <table>
                <thead>
                    <tr><th>Id de asistencia</th>
                        <th>Persona</th>
                        <th>Hora de llegada</th>
                        <th>Razón</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="assistance" items="${actionBean.assistances}">
                        <tr>
                            <td>${assistance.id}</td>
                            <td>
                                <stripes:select name="assistance.person" value="${assistance.person}" disabled="${actionBean.readonly}">
                                    <stripes:options-collection collection="${actionBean.people}" value="id"/>
                                </stripes:select>
                            </td>
                            <td><stripes:text name="assistance.arrival" value="${assistance.arrival}" 
                                          formatPattern="HH:mm" disabled="${actionBean.readonly}"/></td>
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
                <stripes:submit name="viewForm" value="Discard changes"/>
            </c:if>
        </stripes:form> 
        <c:if test="${actionBean.readonly}">
            <c:if test="${actionBean.previous!=0}">
                <stripes:link beanclass='org.lmb97.web.action.EventsActionBean' event='viewForm'>
                    <stripes:param name='id' value='${actionBean.previous}'/>
                    <input type="submit" value="Anterior"/>
                </stripes:link>
            </c:if>    
            <c:if test="${actionBean.following!=0}">
                <stripes:link beanclass='org.lmb97.web.action.EventsActionBean' event='viewForm'>
                    <stripes:param name='id' value='${actionBean.following}' />
                    <input type="submit" value="Siguiente"/>
                </stripes:link>
            </c:if>
        </c:if>
    </stripes:layout-component>
</stripes:layout-render>