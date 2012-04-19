/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.web.action;

import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.DefaultHandler;
/**
 *
 * @author javier
 */
public class MainActionBean extends AbstractActionBean {
    private static final String MAIN="/WEB-INF/jsp/main/Main.jsp";

    @DefaultHandler
    public Resolution viewMain(){
        return new ForwardResolution(MAIN);
    }
    
    
}
