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
public class Event {
    private static Set<Event> events=new HashSet<Event>();
    private EventType eventType;
    private Date dayHour;
    private Season season;
    private int id;
    private Set<MusicSheet> musicsheets=new HashSet<MusicSheet>();
    
    public Event(){
        events.add(this);
    }

    public Date getDayHour() {
        return dayHour;
    }

    public void setDayHour(Date dayHour) {
        this.dayHour = dayHour;
    }

    public EventType getEventType() {
        return eventType;
    }

    public void setEventType(EventType eventType) {
        this.eventType = eventType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Season getSeason() {
        return season;
    }

    public void setSeason(Season season) {
        this.season = season;
    }

    public static Set<Event> getEvents() {
        return events;
    }

    public Set<MusicSheet> getMusicsheets() {
        return musicsheets;
    }

    public void setMusicsheets(Set<MusicSheet> musicsheets) {
        this.musicsheets = musicsheets;
    }
    
    public void addMusicsheet(MusicSheet musicsheet){
        musicsheets.add(musicsheet);
    }
    
    public void removeMusicsheet(MusicSheet musicsheet){
        musicsheets.remove(musicsheet);
    }
    
}
