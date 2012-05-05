<%--
    Document   : ConfirmEvents
    Created on : 05-may-2012, 14:41:13
    Author     : javier
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" language="java"%>
<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<stripes:layout-render name="/WEB-INF/jsp/common/Layout.jsp">
    <stripes:layout-component name="content">
	<h2>Are you sure you want to delete the event ${actionBean.event.id}?</h2>
	<stripes:form beanclass="org.lmb97.web.action.EventsActionBean">
	    <stripes:hidden name="event.id" value="${actionBean.event.id}"/>
	    <stripes:submit name="confirmDeleteForm" value="Delete"/>
	    <stripes:link beanclass="org.lmb97.web.action.EventsActionBean" event="viewForm">
		<stripes:param name="id" value="${actionBean.event.id}" />
		<stripes:button name="viewForm" value="Not delete"/>
	    </stripes:link>
	</stripes:form>
    </stripes:layout-component>
</stripes:layout-render>
