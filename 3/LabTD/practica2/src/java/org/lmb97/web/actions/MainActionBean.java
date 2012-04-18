/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.web.actions;

import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.ForwardResolution;
/**
 *
 * @author javier
 */
public class MainActionBean extends AbstractActionBean {
    private static final String MAIN="/WEB-INF/jsp/main/Main.jsp";
    public Resolution showMain(){
        return new ForwardResolution(MAIN);
    }
}
