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
public class Job {
    private static Set<Job> jobs=new HashSet<Job>();
    private int id;
    private Person person;
    private Date joinDate;
    private Date outDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
    }

    public Date getOutDate() {
        return outDate;
    }

    public void setOutDate(Date outDate) {
        this.outDate = outDate;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public static Set<Job> getJobs() {
        return jobs;
    }
    
}
