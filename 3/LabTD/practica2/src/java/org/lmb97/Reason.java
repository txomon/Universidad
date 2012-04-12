/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97;

import java.util.Set;
import java.util.HashSet;

/**
 *
 * @author javier
 */
public class Reason {
    private static Set<Reason> reasons=new HashSet<Reason>();
    private int id;
    private String reason;

    public Reason() {
        reasons.add(this);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public static Set<Reason> getReasons() {
        return reasons;
    }
    
}
