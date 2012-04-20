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
    <stripes:layout-component name="content">
        <stripes:form beanclass="org.lmb97.web.action.EventsActionBean">
            <stripes:text name="id" size="20" value="${actionBean.id}" disabled="${actionBean.modify}" />
            <stripes:text name="date" size="50" value="${actionBean.date}" disabled="${actionBean.modify}" />
            <stripes:select name="event">
                <c:forEach var="eventType" items="${actionBean.eventTypes}">
                    <stripes:option value="${eventType.id}">${eventType.name}</stripes:option> 
                </c:forEach>
            </stripes:select>
        </stripes:form>
    </stripes:layout-component>
</stripes:layout-render>