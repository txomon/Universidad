/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97;
import java.util.Set;
import java.util.HashSet;
import java.util.Date;

/**
 *
 * @author javier
 */
public class MusicSheet {
    private static Set<MusicSheet> musicSheets=new HashSet<MusicSheet>();
    private int id;
    private String title;
    private Author author;
    private Person adquisitor;
    private Date adquisitionDate;
    private Provider provider;
    
    public MusicSheet(){
        musicSheets.add(this);
    }

    public Date getAdquisitionDate() {
        return adquisitionDate;
    }

    public void setAdquisitionDate(Date adquisitionDate) {
        this.adquisitionDate = adquisitionDate;
    }

    public Person getAdquisitor() {
        return adquisitor;
    }

    public void setAdquisitor(Person adquisitor) {
        this.adquisitor = adquisitor;
    }

    public Author getAuthor() {
        return author;
    }

    public void setAuthor(Author author) {
        this.author = author;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Provider getProvider() {
        return provider;
    }

    public void setProvider(Provider provider) {
        this.provider = provider;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public static Set<MusicSheet> getMusicSheets() {
        return musicSheets;
    }
    
    
}
