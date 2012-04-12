/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97;
import java.util.TreeSet;
/**
 *
 * @author javier
 */
public class Email {
    private int id;
    private String email;
    private static TreeSet<Email> emails;

    public Email(){
        emails.add(this);
    }

    public String getEmail() {
        return email;
    }
    
    public static TreeSet<Email> getEmails() {
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
