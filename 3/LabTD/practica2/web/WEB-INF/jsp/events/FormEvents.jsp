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
    <c:if test="${!actionBean.readonly}">
        <stripes:layout-component name="scripts">
            <script type="text/javascript" xml:space="preserve">
                function invoke(form, event, container) {
                    if (!form.onsubmit) { form.onsubmit = function() { return false } };
                    var params = Form.serialize(form, {submit:event});
                    new Ajax.Updater(container, form.action, {method:'post', parameters:params});
                }
            </script>
        </stripes:layout-component>
    </c:if>
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
            <stripes:url var="modifying" beanclass="org.lmb97.web.action.EventsActionBean" event="modifyingForm" >
                <stripes:param name="id" value="${actionBean.event.id}"/>
            </stripes:url>
            <stripes:form action="${modifying}" name="form" >
                <stripes:label name="event.id">Id:</stripes:label>
                <stripes:text name="event.id" value="${actionBean.event.id}" disabled="true" />
                <stripes:errors field="event.id"/>
                <br/>
                <stripes:label name="event.date">Fecha:</stripes:label>
                <stripes:text name="event.date" value="${actionBean.event.date}" formatPattern="yyyy/MM/dd HH:mm" disabled="${actionBean.readonly}" />
                <stripes:errors field="event.date"/>
                <br/>
                <stripes:label name="event.season">Temporada:</stripes:label>
                <stripes:select name="event.season" value="event.season" disabled="${actionBean.readonly}">
                    <stripes:options-collection collection="${actionBean.seasons}" value="id" />
                </stripes:select>
                <stripes:errors field="event.season"/>
                <br/>
                <stripes:label name="event.eventType">Tipo de Evento:</stripes:label>
                <stripes:select name="event.eventType" onchange="document.form.submit()" value="event.eventType" disabled="${actionBean.readonly}">
                    <stripes:options-collection collection="${actionBean.eventTypes}" value="id" label="name" />
                </stripes:select>
                <stripes:errors field="event.eventType"/>
                <br/>
                <div class="content-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Id de asistencia</th>
                                <th>Persona</th>
                                <th>Hora de llegada</th>
                                <th>Llegada</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>               
                            <c:forEach items="${actionBean.assistances}" var="assistance">
                                <tr>
                                    <td>${assistance.id}</td>
                                    <td>
                                        <stripes:select name="assistance.person" value="${assistance.person}" disabled="${actionBean.readonly}">
                                            <stripes:options-collection collection="${actionBean.people}" value="id"/>
                                        </stripes:select>
                                    </td>
                                    <td>
                                        <stripes:text name="assistance.arrival" value="${assistance.arrival}" 
                                                      formatPattern="HH:mm" disabled="${actionBean.readonly}"/>
                                    </td>
                                    <td>
                                        <c:set var="arrivalTime">
                                            <fmt:formatDate value="${assistance.arrival}" pattern="HH:mm" />
                                        </c:set>
                                        <c:set var="eventDate">
                                            <fmt:formatDate value="${actionBean.event.date}" pattern="HH:mm" />
                                        </c:set>
                                        <c:if test="${arrivalTime<=eventDate}">
                                            A tiempo
                                        </c:if>
                                        <c:if test="${arrivalTime>eventDate}">
                                            Tarde
                                        </c:if>
                                    </td>
                                    <td>
                                        <stripes:errors field="Assistance.person"/>
                                        <stripes:errors field="Assistance.arrival"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
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