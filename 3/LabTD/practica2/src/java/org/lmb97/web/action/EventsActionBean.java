/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.web.action;

import java.lang.Integer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.DefaultHandler;
import org.lmb97.data.Assistances;
import org.lmb97.data.AssistancesExample;
import org.lmb97.data.AssistancesMapper;
import org.lmb97.data.EventTypes;
import org.lmb97.data.EventTypesExample;
import org.lmb97.data.EventTypesMapper;
import org.lmb97.data.Events;
import org.lmb97.data.EventsExample;
import org.lmb97.data.EventsMapper;
import org.lmb97.data.People;
import org.lmb97.data.PeopleExample;
import org.lmb97.data.PeopleMapper;
import org.lmb97.data.Seasons;
import org.lmb97.data.SeasonsExample;
import org.lmb97.data.SeasonsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;


/**
 *
 * @author javier
 */

@Component
public class EventsActionBean extends AbstractActionBean {
    //First, the two pages this Action bean is going to use
    private static final String GRID = "/WEB-INF/jsp/events/GridEvents.jsp";
    private static final String FORM = "/WEB-INF/jsp/events/FormEvents.jsp";
    //Then the data the JSP are going to use, correctly adecuated in each case
    private Events event;
    private List<Assistances> assistances;
    private List<Events> events;
    private List<EventTypes> eventTypes;
    private List<Seasons> seasons;
    private Map<Integer, People> people;
    private Map<Integer, Integer> totalassistants;
    private Map<Integer, Integer> ontimeassistants;
    private boolean readonly;
    //At last, all the entity mappers
    @Autowired
    private AssistancesMapper assistancesMapper;
    @Autowired
    private EventsMapper eventsMapper;
    @Autowired
    private EventTypesMapper eventTypesMapper;
    @Autowired
    private PeopleMapper peopleMapper;
    @Autowired
    private SeasonsMapper seasonsMapper;
    
    
    @DefaultHandler
    public Resolution viewGrid() {
        EventsExample eventsExample=new EventsExample();
        EventTypesExample eventTypesExample=new EventTypesExample();
        SeasonsExample seasonsExample=new SeasonsExample();

        this.readonly=true;
        eventsExample.createCriteria();
        this.events=eventsMapper.selectByExample(eventsExample);
        
        seasonsExample.createCriteria();
        this.seasons=seasonsMapper.selectByExample(seasonsExample);

        eventTypesExample.createCriteria();
        this.eventTypes=eventTypesMapper.selectByExample(eventTypesExample);
        
        createAssistancesStatistics();
        
        return new ForwardResolution(GRID);
    }

    public Resolution viewForm() {
        AssistancesExample assistancesExample=new AssistancesExample();
        EventsExample eventsExample=new EventsExample();
        EventTypesExample eventTypesExample=new EventTypesExample();
        PeopleExample peopleExample=new PeopleExample();
        SeasonsExample seasonsExample=new SeasonsExample();

        int id;
        if(null!=context.getRequest().getParameter("id")){
            id=new Integer(context.getRequest().getParameter("id")).intValue();
        }else{
            id=1;
        }
        this.readonly=true;

        eventsExample.createCriteria().andIdEqualTo(id);
        this.event=eventsMapper.selectByExample(eventsExample).get(id);
        
        assistancesExample.createCriteria().andEventEqualTo(id);
        this.assistances=assistancesMapper.selectByExample(assistancesExample);
        
        peopleExample.createCriteria().andIdIn(getAssistantsIds());
        initializeMapOfPeople(peopleMapper.selectByExample(peopleExample));
        
        seasonsExample.createCriteria().andIdEqualTo(this.event.getSeason());
        this.seasons=seasonsMapper.selectByExample(seasonsExample);
        
        eventTypesExample.createCriteria().andIdEqualTo(this.event.getEventType());
        this.eventTypes=eventTypesMapper.selectByExample(eventTypesExample);
        
        return new ForwardResolution(FORM);
    }
    
    private void createAssistancesStatistics(){
        AssistancesExample assistancesExample=new AssistancesExample();
        Iterator iterator=this.events.iterator();
        Events theEvent;
        
        while(iterator.hasNext()){
            theEvent=(Events)iterator.next();
            assistancesExample.createCriteria().andEventEqualTo(theEvent.getId()).andArrivalLessThanOrEqualTo(event.getDate());
            this.ontimeassistants.put(theEvent.getId(),assistancesMapper.countByExample(assistancesExample));
            assistancesExample.createCriteria().andEventEqualTo(theEvent.getId());
            this.ontimeassistants.put(theEvent.getId(),assistancesMapper.countByExample(assistancesExample));
        }
        
    }
    
    private List<Integer> getAssistantsIds(){
        List<Integer> assistantsIds=new ArrayList<Integer>();
        Iterator iterator=this.assistances.iterator();
        Assistances assistance;
        while(iterator.hasNext()){
            assistance=(Assistances)iterator.next();
            assistantsIds.add(assistance.getPerson());
        }
        return assistantsIds;
    }
    
    private void initializeMapOfPeople(List<People> people){
        Iterator iterator=people.iterator();
        People person;
        while(iterator.hasNext()){
            person=(People)iterator.next();
            this.people.put(person.getId(), person);
        }
    }

    public boolean isReadonly() {
        return readonly;
    }

    public Map<Integer, Integer> getOntimeassistants() {
        return ontimeassistants;
    }

    public Map<Integer, Integer> getTotalassistants() {
        return totalassistants;
    }

    public List<EventTypes> getEventTypes() {
        return eventTypes;
    }

    public void setEventTypes(List<EventTypes> eventTypes) {
        this.eventTypes = eventTypes;
    }
    
    public List<Assistances> getAssistances() {
        return assistances;
    }

    public void setAssistances(List<Assistances> assistances) {
        this.assistances = assistances;
    }

    public Events getEvent() {
        return event;
    }

    public void setEvent(Events event) {
        this.event = event;
    }

    public List<Events> getEvents() {
        return events;
    }

    public void setEvents(List<Events> events) {
        this.events = events;
    }

    public Map<Integer, People> getPeople() {
        return people;
    }

    public void setPeople(Map<Integer, People> people) {
        this.people = people;
    }

    public List<Seasons> getSeasons() {
        return seasons;
    }

    public void setSeasons(List<Seasons> seasons) {
        this.seasons = seasons;
    }

}
