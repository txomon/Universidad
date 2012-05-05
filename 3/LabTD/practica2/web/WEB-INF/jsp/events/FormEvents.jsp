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
                function BuckRocks()
                {
                    inputForm = document.getElementById('input');
                    inputForm.action = "/practica2/Events.action?modifyingForm=";
                    inputForm.submit();
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
            <stripes:form id="input" beanclass="org.lmb97.web.action.EventsActionBean" >
                <stripes:hidden name="event.id" value="${actionBean.event.id}"/>
                <stripes:label name="event.date">Fecha:</stripes:label>
                <stripes:text name="event.date" value="${actionBean.event.date}" formatType="datetime"
                              formatPattern="yyyy/MM/dd HH:mm" disabled="${actionBean.readonly}" />
                <stripes:errors field="event.date"/>
                <br/>
                <stripes:label name="event.season">Temporada:</stripes:label>
                <stripes:select name="event.season" value="${actionBean.event.season}" disabled="${actionBean.readonly}">
                    <stripes:options-collection collection="${actionBean.seasons}" value="id" />
                </stripes:select>
                <stripes:errors field="event.season"/>
                <br/>
                <stripes:label name="event.eventType">Tipo de Evento:</stripes:label>
                <stripes:select id="event.eventType" name="event.eventType" onchange="BuckRocks();"
                                value="${actionBean.event.eventType}" disabled="${actionBean.readonly}">
                    <stripes:options-collection collection="${actionBean.eventTypes}" value="id" label="name" />
                </stripes:select>
                <stripes:errors field="event.eventType"/>
                <br/>
                <div class="content-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Persona</th>
                                <th>Hora de llegada</th>
                                <th>Llegada</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="eventDate">
                                <fmt:formatDate value="${actionBean.event.date}" pattern="HH:mm" />
                            </c:set>
                            <c:forEach items="${actionBean.people}" var="person" varStatus="loop">
                                <tr>
                                    <td>
                                        <stripes:hidden name="assists[${person.id}].event" value="${actionBean.event.id}"/>
                                        <stripes:hidden name="assists[${person.id}].id" value="${actionBean.assists[person.id].id}"/>
                                        <stripes:hidden name="assists[${person.id}].person" value="${person.id}"/>
                                        ${person.name} ${person.surname}
                                    </td>
                                    <td>
                                        <stripes:text name="assists[${person.id}].arrival" value="${actionBean.assists[person.id].arrival}"
                                                      formatPattern="HH:mm" formatType="time" disabled="${actionBean.readonly}"/>
                                    </td>
                                    <td>
                                        <c:set var="arrivalTime">
                                            <fmt:formatDate value="${actionBean.assists[person.id].arrival}" pattern="HH:mm" />
                                        </c:set>
                                        <c:if test="${arrivalTime<=eventDate}">
                                            A tiempo
                                        </c:if>
                                        <c:if test="${arrivalTime>eventDate}">
                                            Tarde
                                        </c:if>
                                    </td>
                                    <td>
                                        <stripes:errors field="assists[${person.id}].arrival"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${!actionBean.readonly}">
                    <stripes:submit name="saveForm" value="Save changes"/>
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