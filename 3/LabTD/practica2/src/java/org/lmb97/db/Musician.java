/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.db;

import java.util.HashSet;
import java.util.Set;
/**
 *
 * @author javier
 */
public class Musician {
    private static Set<Musician> musicians=new HashSet<Musician>();
    private int id;
    private Person person;
    private Instrument instrument;
    private Set<Season> season=new HashSet<Season>();

    public Musician(){
        musicians.add(this);
    }
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Instrument getInstrument() {
        return instrument;
    }

    public void setInstrument(Instrument instrument) {
        this.instrument = instrument;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
    
    public static Set<Musician> getMusicians(){
        return musicians;
    }

    public Set<Season> getSeason() {
        return season;
    }

    public void setSeason(Set<Season> season) {
        this.season = season;
    }
    
    public void addSeason(Season season){
        this.season.add(season);
    }
    
    public void removeSeason(Season season){
        this.season.remove(season);
    }
}
