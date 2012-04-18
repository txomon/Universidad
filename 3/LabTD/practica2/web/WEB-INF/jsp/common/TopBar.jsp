<%-- 
    Document   : TopBar
    Created on : 18-abr-2012, 5:15:23
    Author     : javier
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ taglib prefix="stripes"
           uri="http://stripes.sourceforge.net/stripes.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<stripes:layout-definition>
    <stripes:layout-component name="topbar">
                <ul>
                    <li>
                        <stripes:link
                            beanclass="org.lmb97.web.actions.PeopleActionBean"
                            event="viewGrid">
                            Personas
                        </stripes:link> 
                    </li>
                    <li>
                        <stripes:link
                            beanclass="org.lmb97.web.actions.AssistencesActionBean"
                            event="viewGrid">
                            Asistencias
                        </stripes:link> 
                    </li>
                    <li>
                        <stripes:link
                            beanclass="org.lmb97.web.actions.MusicsheetsActionBean"
                            event="viewGrid">
                            Partituras
                        </stripes:link> 
                    </li>
                </ul>
    </stripes:layout-component>
</stripes:layout-definition>