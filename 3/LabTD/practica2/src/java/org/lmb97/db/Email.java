/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.db;
import java.util.Set;
import java.util.HashSet;
/**
 *
 * @author javier
 */
public class Email {
    private int id;
    private String email;
    private static Set<Email> emails=new HashSet<Email>();

    public Email(){
        emails.add(this);
    }

    public String getEmail() {
        return email;
    }
    
    public static Set<Email> getEmails() {
        return emails;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

}
