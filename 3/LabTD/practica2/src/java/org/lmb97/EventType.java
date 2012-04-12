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
public class EventType {
    private static Set<EventType> eventTypes=new HashSet<EventType>();
    private int id;
    private Post assistantPost;
    private String eventType;
    
    public EventType(){
        eventTypes.add(this);
    }

    public Post getAssistantPost() {
        return assistantPost;
    }

    public void setAssistantPost(Post assistantPost) {
        this.assistantPost = assistantPost;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public static Set<EventType> getEventTypes() {
        return eventTypes;
    }
    
}
