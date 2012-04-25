/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.util;

import java.util.Locale;
import net.sourceforge.stripes.format.Formatter;
import org.lmb97.data.People;

/**
 *
 * @author javier
 */
public class PersonFormatter implements Formatter<People>{

    @Override
    public void setFormatType(String formatType) {
    }

    @Override
    public void setFormatPattern(String formatPattern) {
    }

    @Override
    public void setLocale(Locale locale) {
    }

    @Override
    public void init() {
    }

    @Override
    public String format(People person) {
        return person.getName() + " " + person.getSurname();
    }
    
    
}