/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.db;

import java.util.Set;
import java.util.HashSet;
import java.util.Date;

/**
 *
 * @author javier
 */
public class Asistence {
    private static Set<Asistence> asistences=new HashSet<Asistence>();
    private int id;
    private Person person;
    private Date arrival;
    private Event foreseenEvent;
    private Reason reason;

    public Asistence() {
        asistences.add(this);
    }

    public Date getArrival() {
        return arrival;
    }

    public void setArrival(Date arrival) {
        this.arrival = arrival;
    }

    public Event getForeseenEvent() {
        return foreseenEvent;
    }

    public void setForeseenEvent(Event foreseenEvent) {
        this.foreseenEvent = foreseenEvent;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public Reason getReason() {
        return reason;
    }

    public void setReason(Reason reason) {
        this.reason = reason;
    }

    public static Set<Asistence> getAsistences() {
        return asistences;
    }
    
    
    
}
