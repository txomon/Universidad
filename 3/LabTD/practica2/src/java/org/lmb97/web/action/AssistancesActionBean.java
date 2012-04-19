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
public class AssistancesActionBean extends AbstractActionBean{
    private static final String GRID="/WEB-INF/jsp/assistances/GridAssistances.jsp";
    private static final String FORM="/WEB-INF/jsp/assistances/FormAssistances.jsp";
    
    
    @DefaultHandler
    public Resolution viewGrid(){
        return new ForwardResolution(GRID);
    }
    
    public Resolution viewForm(){
        return new ForwardResolution(FORM);
    }
}
