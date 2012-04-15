/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.db;

import java.util.HashSet;
import java.util.Date;
import java.util.Set;

/**
 *
 * @author javier
 */
public class Person {

    private int id;
    private String name, surname;
    private Date birth;
    private int phoneMobile, phoneHouse;
    private int dniNumber;
    private char dniLetter;
    private String address;
    private int postalCode;
    private Person joinRef;
    private String password;
    private String nick;
    private Set<Email> emails=new HashSet<Email>();
    private static Set<Person> people=new HashSet<Person>();

    public Person() {
        people.add(this);
    }

    public static Set<Person> getPeople() {
        return people;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public char getDniLetter() {
        return dniLetter;
    }

    public void setDniLetter(char dniLetter) {
        this.dniLetter = dniLetter;
    }

    public int getDniNumber() {
        return dniNumber;
    }

    public void setDniNumber(int dniNumber) {
        this.dniNumber = dniNumber;
    }

    public Set<Email> getEmails() {
        return emails;
    }

    public void setEmails(Set<Email> emails) {
        this.emails = emails;
    }

    public void addEmail(Email email) {
        this.emails.add(email);
    }

    public void removeEmail(Email email) {
        this.emails.remove(email);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Person getJoinRef() {
        return joinRef;
    }

    public void setJoinRef(Person joinRef) {
        this.joinRef = joinRef;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNick() {
        return nick;
    }

    public void setNick(String nick) {
        this.nick = nick;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getPhoneHouse() {
        return phoneHouse;
    }

    public void setPhoneHouse(int phoneHouse) {
        this.phoneHouse = phoneHouse;
    }

    public int getPhoneMobile() {
        return phoneMobile;
    }

    public void setPhoneMobile(int phoneMobile) {
        this.phoneMobile = phoneMobile;
    }

    public int getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(int postalCode) {
        this.postalCode = postalCode;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }
}
