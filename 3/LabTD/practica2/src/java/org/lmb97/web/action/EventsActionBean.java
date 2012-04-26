/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.web.action;

import java.lang.Integer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.integration.spring.SpringBean;
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
import org.lmb97.data.PostsExample;
import org.lmb97.data.PostsMapper;
import org.lmb97.data.RelPostsPeopleExample;
import org.lmb97.data.RelPostsPeopleMapper;
import org.lmb97.data.Seasons;
import org.lmb97.data.SeasonsExample;
import org.lmb97.data.SeasonsMapper;



/**
 *
 * @author javier
 */

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
    private List<People> people;
    private Map<Integer, Integer> totalassistants;
    private Map<Integer, Integer> ontimeassistants;
    private boolean readonly;
    private String view;
    private int following;
    private int previous;
    //At last, all the entity mappers
    @SpringBean
    private AssistancesMapper assistancesMapper;
    @SpringBean
    private EventsMapper eventsMapper;
    @SpringBean
    private EventTypesMapper eventTypesMapper;
    @SpringBean
    private PeopleMapper peopleMapper;
    @SpringBean
    private SeasonsMapper seasonsMapper;
    @SpringBean
    private PostsMapper postsMapper;
    @SpringBean
    private RelPostsPeopleMapper relPostsPeopleMapper;

    
    
    @DefaultHandler
    public Resolution viewGrid() {
        EventsExample eventsExample=new EventsExample();
        EventTypesExample eventTypesExample=new EventTypesExample();
        SeasonsExample seasonsExample=new SeasonsExample();

        this.view="Grid";
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
        EventTypesExample eventTypesExample=new EventTypesExample();
        PeopleExample peopleExample=new PeopleExample();
        SeasonsExample seasonsExample=new SeasonsExample();

        this.readonly=true;
        this.view="Form";
        int id;
        if(null!=context.getRequest().getParameter("id")){
            id=new Integer(context.getRequest().getParameter("id")).intValue();
        }else{
            id=1;
        }

        this.event=eventsMapper.selectByPrimaryKey(id);
        initFollowingAndPrevious(id);

        assistancesExample.createCriteria().andEventEqualTo(id);
        this.assistances=assistancesMapper.selectByExample(assistancesExample);

        peopleExample.createCriteria().andIdIn(getAssistantsIds());
        this.people=peopleMapper.selectByExample(peopleExample);
        
        seasonsExample.createCriteria().andIdEqualTo(this.event.getSeason());
        this.seasons=seasonsMapper.selectByExample(seasonsExample);
        
        eventTypesExample.createCriteria().andIdEqualTo(this.event.getEventType());
        this.eventTypes=eventTypesMapper.selectByExample(eventTypesExample);
        
        return new ForwardResolution(FORM);
    }
    
    public Resolution modifyForm(){
        AssistancesExample assistancesExample=new AssistancesExample();
        EventTypesExample eventTypesExample=new EventTypesExample();
        PeopleExample peopleExample=new PeopleExample();
        SeasonsExample seasonsExample=new SeasonsExample();
        PostsExample postsExample=new PostsExample();
        RelPostsPeopleExample relPostsPeopleExample=new RelPostsPeopleExample();

        
        this.readonly=false;
        this.view="Form";
        int id;
        if(null!=context.getRequest().getParameter("id")){
            id=new Integer(context.getRequest().getParameter("id")).intValue();
        }else{
            id=1;
        }

        this.event=eventsMapper.selectByPrimaryKey(id);
        initFollowingAndPrevious(id);

        assistancesExample.createCriteria().andEventEqualTo(id);
        this.assistances=assistancesMapper.selectByExample(assistancesExample);

        eventTypesExample.createCriteria();
        this.eventTypes=eventTypesMapper.selectByExample(eventTypesExample);
        
        postsExample.createCriteria().andIdEqualTo(this.eventTypes
                .get(this.event.getEventType()).getPost());
        
        
        
        peopleExample.createCriteria();
        this.people=peopleMapper.selectByExample(peopleExample);
        
        seasonsExample.createCriteria();
        this.seasons=seasonsMapper.selectByExample(seasonsExample);
        

        return new ForwardResolution(FORM);
    }
    private void createAssistancesStatistics(){
        AssistancesExample assistancesExample=new AssistancesExample();
        Iterator iterator=this.events.iterator();
        Events theEvent;
        this.ontimeassistants=new TreeMap<Integer,Integer>();
        this.totalassistants=new TreeMap<Integer,Integer>();
        /* FIXME */
        while(iterator.hasNext()){
            theEvent=(Events)iterator.next();
            assistancesExample.createCriteria().andEventEqualTo(theEvent.getId()).andArrivalLessThanOrEqualTo(theEvent.getDate());
            this.ontimeassistants.put(theEvent.getId(),assistancesMapper.countByExample(assistancesExample));
            assistancesExample.createCriteria().andEventEqualTo(theEvent.getId());
            this.totalassistants.put(theEvent.getId(),assistancesMapper.countByExample(assistancesExample));
            System.out.println("Evento "+theEvent.getId()+" tiene en total "+this.totalassistants.get(theEvent.getId())
                    +" assistente(s) y "+ this.ontimeassistants.get(theEvent.getId()) + " de ellos han llegado a tiempo");
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
    
    private void initFollowingAndPrevious(int id){
        EventsExample eventsExample=new EventsExample();
        boolean found=false;
        
        eventsExample.createCriteria();
        this.previous=0;
        this.following=0;
        for(Events item : eventsMapper.selectByExample(eventsExample)){
            if(found){
                this.following=item.getId();
                return;
            }
            if(item.getId()==id)
                found=true;
            if(!found)
                this.previous=item.getId();
        }
    }

    public int getFollowing() {
        return following;
    }

    public void setFollowing(int following) {
        this.following = following;
    }

    public int getPrevious() {
        return previous;
    }

    public void setPrevious(int previous) {
        this.previous = previous;
    }

    
    public String getView() {
        return view;
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

    public List<People> getPeople() {
        return people;
    }

    public void setPeople(List<People> people) {
        this.people = people;
    }

    public List<Seasons> getSeasons() {
        return seasons;
    }

    public void setSeasons(List<Seasons> seasons) {
        this.seasons = seasons;
    }

}
