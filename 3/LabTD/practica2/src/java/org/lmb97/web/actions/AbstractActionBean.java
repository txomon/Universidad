/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.web.actions;

/**
 *
 * @author mybatis
 */
import java.io.Serializable;

import net.sourceforge.stripes.action.ActionBean;
import net.sourceforge.stripes.action.ActionBeanContext;
import net.sourceforge.stripes.action.SimpleMessage;

abstract class AbstractActionBean implements ActionBean, Serializable {
    
    protected static final String ERROR = "/WEB-INF/jsp/common/Error.jsp";
    protected transient ActionBeanContext context;

    protected void setMessage(String value) {
        context.getMessages().add(new SimpleMessage(value));
    }

    public ActionBeanContext getContext() {
        return context;
    }

    public void setContext(ActionBeanContext context) {
        this.context = context;
    }
}