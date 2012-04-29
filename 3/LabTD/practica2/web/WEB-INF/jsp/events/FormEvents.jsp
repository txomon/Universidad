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


<stripes:layout-render name="/WEB-INF/jsp/common/Layout.jsp">
    <stripes:layout-component name="sidebar">
        <ul>
            <li>
                <h2>Acciones</h2>
                <ul>
                    <li>
                        <stripes:link
                            beanclass="${actionBean['class']}"
                            event="modifyForm">
                            <stripes:param name="id" value="${actionBean.event.id}"/>
                            Modificar
                        </stripes:link> 
                    </li>
                    <li>
                        <stripes:link
                            beanclass="${actionBean['class']}"
                            event="insertForm">
                            <stripes:param name="id" value="${actionBean.event.id}"/>
                            Insertar
                        </stripes:link> 
                    </li>
                    <li>
                        <stripes:link
                            beanclass="${actionBean['class']}"
                            event="deleteForm">
                            <stripes:param name="id" value="${actionBean.event.id}"/>
                            Eliminar
                        </stripes:link> 
                    </li>
                </ul>
            </li>
            <c:if test="${actionBean.readonly}">
                <li>
                    <h2>Entradas</h2>
                    <ul>

                        <c:if test="${actionBean.previous!=0}">
                            <li>
                                <stripes:link beanclass='org.lmb97.web.action.EventsActionBean' event='viewForm'>
                                    <stripes:param name='id' value='${actionBean.previous}'/>
                                    Anterior
                                </stripes:link>
                            </li>
                        </c:if>    
                        <c:if test="${actionBean.following!=0}">
                            <li>
                                <stripes:link beanclass='org.lmb97.web.action.EventsActionBean' event='viewForm'>
                                    <stripes:param name='id' value='${actionBean.following}' />
                                    Siguiente
                                </stripes:link>
                            </li>
                        </c:if>
                    </ul>
                </li>
            </c:if>
        </ul>
    </stripes:layout-component>
    <stripes:layout-component name="content">
        <c:if test="${actionBean.event==null}" >
            <h2>
                Error: No existe el evento especificado.
            </h2>
        </c:if>
        <c:if test="${actionBean.event!=null}" >
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
                            <th>Llegada</th></tr>
                    </thead>
                    <tbody>
                        <!-- FIXME: This repeats for each foreach
                        06:43:31,271  INFO DefaultPopulationStrategy:176 - 
                        Could not find property [Assistance.person] on 
                        ActionBean.net.sourceforge.stripes.util.bean.NoSuchPropertyException: 
                        Bean class org.lmb97.web.action.EventsActionBean does not contain a 
                        property called 'Assistance'. As a result the following expression could
                        not be evaluated: Assistance.person -->
                        <c:forEach items="${actionBean.assistances}" var="Assistance">
                            <tr>
                                <td>${Assistance.id}</td>
                                <td>
                                    <stripes:select name="Assistance.person" value="${Assistance.person}" disabled="${actionBean.readonly}">
                                        <stripes:options-collection collection="${actionBean.people}" value="id"/>
                                    </stripes:select>
                                </td>
                                <td><stripes:text name="Assistance.arrival" value="${Assistance.arrival}" 
                                              formatPattern="HH:mm" disabled="${actionBean.readonly}"/></td>
                                <td>
                                    <c:if test="${Assistance.arrival<=actionBean.event.date}">
                                        A tiempo
                                    </c:if>
                                    <c:if test="${Assistance.arrival>actionBean.event.date}">
                                        Tarde
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${!actionBean.readonly}">
                    <stripes:link beanclass="org.lmb97.web.action.EventsActionBean" event="saveForm">
                        <stripes:param name="id" value="${actionBean.event.id}" />
                        <stripes:button name="saveForm" value="Save changes"/>
                    </stripes:link>
                    <stripes:link beanclass="org.lmb97.web.action.EventsActionBean" event="viewForm">
                        <stripes:param name="id" value="${actionBean.event.id}" />
                        <stripes:button name="viewForm" value="Discard changes"/>
                    </stripes:link>
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
        </c:if>
    </stripes:layout-component>
</stripes:layout-render>