/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.web.action;

import java.lang.Integer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;
import net.sourceforge.stripes.action.DontValidate;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.integration.spring.SpringBean;
import net.sourceforge.stripes.validation.SimpleError;
import net.sourceforge.stripes.validation.Validate;
import net.sourceforge.stripes.validation.ValidateNestedProperties;
import net.sourceforge.stripes.validation.ValidationError;
import net.sourceforge.stripes.validation.ValidationErrorHandler;
import net.sourceforge.stripes.validation.ValidationErrors;
import net.sourceforge.stripes.validation.ValidationMethod;
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
import org.lmb97.data.Posts;
import org.lmb97.data.PostsMapper;
import org.lmb97.data.RelPostsPeople;
import org.lmb97.data.RelPostsPeopleExample;
import org.lmb97.data.RelPostsPeopleMapper;
import org.lmb97.data.Seasons;
import org.lmb97.data.SeasonsExample;
import org.lmb97.data.SeasonsMapper;
import org.lmb97.util.NormalDateTimeTypeConverter;

/**
 *
 * @author javier
 */
public class EventsActionBean extends AbstractActionBean implements ValidationErrorHandler {
    //First, the two pages this Action bean is going to use

    private static final String GRID = "/WEB-INF/jsp/events/GridEvents.jsp";
    private static final String FORM = "/WEB-INF/jsp/events/FormEvents.jsp";
    //Then the data the JSP are going to use, correctly adecuated in each case
    @ValidateNestedProperties({
        @Validate(field = "eventType", required = true),
        @Validate(field = "date", converter = NormalDateTimeTypeConverter.class, required = true),
        @Validate(field = "season", required = true)
    })
    private Events event;
    private Posts post;
    private List<Assistances> assistances;
    private List<Events> events;
    private List<EventTypes> eventTypes;
    private List<Seasons> seasons;
    private List<People> people;
    private List<RelPostsPeople> relPostsPeople;
    private Map<Integer, Integer> totalassistants;
    private Map<Integer, Integer> ontimeassistants;
    @ValidateNestedProperties({
        @Validate(field = "arrival", converter = NormalDateTimeTypeConverter.class)
    })
    private Map<Integer, Assistances> assists;
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
    @DontValidate
    public Resolution viewGrid() {
        EventsExample eventsExample = new EventsExample();
        EventTypesExample eventTypesExample = new EventTypesExample();
        SeasonsExample seasonsExample = new SeasonsExample();

        this.view = "Grid";
        this.readonly = true;
        eventsExample.createCriteria();
        this.events = eventsMapper.selectByExample(eventsExample);

        seasonsExample.createCriteria();
        this.seasons = seasonsMapper.selectByExample(seasonsExample);

        eventTypesExample.createCriteria();
        this.eventTypes = eventTypesMapper.selectByExample(eventTypesExample);

        createAssistancesStatistics();

        return new ForwardResolution(GRID);
    }

    @DontValidate
    public Resolution viewForm() {
        AssistancesExample assistancesExample = new AssistancesExample();
        EventTypesExample eventTypesExample = new EventTypesExample();
        PeopleExample peopleExample = new PeopleExample();
        SeasonsExample seasonsExample = new SeasonsExample();
        RelPostsPeopleExample relPostsPeopleExample = new RelPostsPeopleExample();

        this.readonly = true;
        this.view = "Form";
        int id;
        if (null != context.getRequest().getParameter("id")) {
            id = new Integer(context.getRequest().getParameter("id")).intValue();
        } else {
            id = 1;
        }

        // We check if the event has been mapped by the form, if not, we define it
        this.event = eventsMapper.selectByPrimaryKey(id);

        //We init the following and previous parameters.
        initFollowingAndPrevious(id);

        //We take the EventTypes
        eventTypesExample.createCriteria().andIdEqualTo(this.event.getEventType());
        this.eventTypes = eventTypesMapper.selectByExample(eventTypesExample);

        //We take the post related to this event, related to this evenType
        this.post = postsMapper.selectByPrimaryKey(eventTypesMapper.selectByPrimaryKey(event.getEventType()).getPost());

        //We take all the RelPostsPeople that should be assisting to that event
        relPostsPeopleExample.or().
                andPostEqualTo(this.post.getId()).
                andJoinDateLessThanOrEqualTo(this.event.getDate()).
                andOutDateGreaterThan(this.event.getDate());
        relPostsPeopleExample.or().
                andPostEqualTo(this.post.getId()).
                andJoinDateLessThanOrEqualTo(this.event.getDate()).
                andOutDateIsNull();

        this.relPostsPeople = relPostsPeopleMapper.selectByExample(relPostsPeopleExample);

        //We take this season
        seasonsExample.createCriteria().andIdEqualTo(this.event.getSeason());
        this.seasons = seasonsMapper.selectByExample(seasonsExample);

        //We take now all the people that should be going to that event
        List<Integer> posiblePeopleIds = getPeopleIds();

        peopleExample.createCriteria().andIdIn(posiblePeopleIds);
        this.people = peopleMapper.selectByExample(peopleExample);

        //We take all the assistances related to that event
        assistancesExample.createCriteria().andEventEqualTo(id);
        this.assistances = assistancesMapper.selectByExample(assistancesExample);

        createAssistancesMap();
        //We create a map to be able to be able to access those vars
        return new ForwardResolution(FORM);
    }

    @DontValidate
    public Resolution modifyForm() {
        AssistancesExample assistancesExample = new AssistancesExample();
        EventTypesExample eventTypesExample = new EventTypesExample();
        PeopleExample peopleExample = new PeopleExample();
        SeasonsExample seasonsExample = new SeasonsExample();
        RelPostsPeopleExample relPostsPeopleExample = new RelPostsPeopleExample();


        this.readonly = false;
        this.view = "Form";
        int id;

        // If the id is in the parameters, we take it, if not, defaults to 1
        if (null != context.getRequest().getParameter("id")) {
            id = new Integer(context.getRequest().getParameter("id")).intValue();
        } else {
            id = 1;
        }

        // We check if the event has been mapped by the form, if not, we define it
        if (this.event == null) {
            this.event = eventsMapper.selectByPrimaryKey(id);
        }
        //We init the following and previous parameters.
        initFollowingAndPrevious(id);

        //We take all the posible EventTypes
        eventTypesExample.createCriteria();
        this.eventTypes = eventTypesMapper.selectByExample(eventTypesExample);

        //We take the post related to this event, related to this evenType
        this.post = postsMapper.selectByPrimaryKey(eventTypesMapper.selectByPrimaryKey(event.getEventType()).getPost());

        //We take all the people that should be assisting to that event
        relPostsPeopleExample.or().
                andPostEqualTo(this.post.getId()).
                andJoinDateLessThanOrEqualTo(this.event.getDate()).
                andOutDateGreaterThan(this.event.getDate());
        relPostsPeopleExample.or().
                andPostEqualTo(this.post.getId()).
                andJoinDateLessThanOrEqualTo(this.event.getDate()).
                andOutDateIsNull();

        this.relPostsPeople = relPostsPeopleMapper.selectByExample(relPostsPeopleExample);

        //We take all the seasons it could belong to
        seasonsExample.createCriteria();
        this.seasons = seasonsMapper.selectByExample(seasonsExample);

        //We take now all the people that should be going to that event
        List<Integer> posiblePeopleIds = getPeopleIds();

        peopleExample.createCriteria().andIdIn(posiblePeopleIds);
        this.people = peopleMapper.selectByExample(peopleExample);

        //We take all the assistances related to that event
        assistancesExample.createCriteria().andEventEqualTo(id);
        this.assistances = assistancesMapper.selectByExample(assistancesExample);

        if (assists == null || assists.isEmpty()) {
            createAssistancesMap();
        }

        return new ForwardResolution(FORM);
    }

    public Resolution modifyingForm() {
        return modifyForm();
    }

    public Resolution saveForm() {

        for (Assistances item : this.assists.values()) {
            /*
             * If the arrival is specified in it, then we can be able to insert
             * it. If the arrival is not specified, it can be that we have to
             * delete it.
             */
            if (item.getArrival() != null) {
                /*
                 * If the id of the assistance is put, that means it already
                 * exists, so we just have to update it. If not, we insert it.
                 */
                if (item.getId() == null || item.getId() == 0) {
                    this.assistancesMapper.insert(item);
                } else {
                    this.assistancesMapper.updateByPrimaryKey(item);
                }
            } else {
                /*
                 * We check if the id is set. As we dont specify the id of the
                 * assistances (they are auto_increment fields), if it is set,
                 * means that has been taken from the DB.
                 */
                if (item.getId() != null && item.getId() != 0) {
                    this.assistancesMapper.deleteByPrimaryKey(item.getId());
                }
            }
        }
        return new RedirectResolution("/Events.action?viewForm=&id="+this.event.getId());
    }

    private void createAssistancesStatistics() {
        AssistancesExample assistancesExample = new AssistancesExample();
        this.ontimeassistants = new TreeMap<Integer, Integer>();
        this.totalassistants = new TreeMap<Integer, Integer>();

        for (Events item : this.events) {
            assistancesExample.createCriteria().
                    andEventEqualTo(item.getId()).
                    andArrivalLessThanOrEqualTo(item.getDate());

            this.ontimeassistants.put(
                    item.getId(),
                    assistancesMapper.countByExample(assistancesExample));

            assistancesExample.clear();

            assistancesExample.createCriteria().
                    andEventEqualTo(item.getId());

            this.totalassistants.put(
                    item.getId(),
                    assistancesMapper.countByExample(assistancesExample));

            assistancesExample.clear();
        }
    }


    /*
     * Here I have to check wether if the ones in the assists array can go to
     * the event or not. And put error for all those
     */
    @ValidationMethod
    public void validateAssistancesAndPeople(ValidationErrors errors) {
        RelPostsPeopleExample relPostsPeopleExample = new RelPostsPeopleExample();
        EventTypes eventType;
        Posts thepost;
        List<RelPostsPeople> expectedPeople;
        boolean iserror = false;

        eventType = this.eventTypesMapper.selectByPrimaryKey(this.event.getEventType());

        thepost = this.postsMapper.selectByPrimaryKey(eventType.getPost());
        //We take all the RelPostsPeople that should be assisting to that event
        relPostsPeopleExample.or().
                andPostEqualTo(thepost.getId()).
                andJoinDateLessThanOrEqualTo(this.event.getDate()).
                andOutDateGreaterThan(this.event.getDate());
        relPostsPeopleExample.or().
                andPostEqualTo(thepost.getId()).
                andJoinDateLessThanOrEqualTo(this.event.getDate()).
                andOutDateIsNull();

        expectedPeople = relPostsPeopleMapper.selectByExample(relPostsPeopleExample);

        List<Integer> expectedPeopleIds = new ArrayList<Integer>();
        for (RelPostsPeople item : expectedPeople) {
            expectedPeopleIds.add(item.getPerson());
        }
        for (Entry<Integer, Assistances> item : assists.entrySet()) {
            if (!expectedPeopleIds.contains(item.getKey()) && item.getValue().getArrival() != null) {
                iserror = true;
                People person = this.peopleMapper.selectByPrimaryKey(item.getKey());
                ValidationError error;
                error = new SimpleError("El campo de hora de llegada de " + person.getName() + " "
                        + person.getSurname() + " ({1}) impide el cambio al evento {2}"
                        + " por que no puede asistir a ese evento", eventType.getName());
                errors.add("assists[" + item.getKey() + "].arrival", error);
            }
        }
        if (iserror) {
            this.event.setEventType(eventsMapper.selectByPrimaryKey(this.event.getId()).getEventType());
            modifyForm();
        }
    }

    @Override
    public Resolution handleValidationErrors(ValidationErrors errors) throws Exception {
        return null;
    }

    private List<Integer> getPeopleIds() {
        List<Integer> peopleIds = new ArrayList<Integer>();
        for (RelPostsPeople item : this.relPostsPeople) {
            peopleIds.add(item.getPerson());
        }
        return peopleIds;
    }

    private void createAssistancesMap() {
        this.assists = new TreeMap<Integer, Assistances>();
        for (Assistances item : this.assistances) {
            assists.put(item.getPerson(), item);
        }
    }

    private void initFollowingAndPrevious(int id) {
        EventsExample eventsExample = new EventsExample();
        boolean found = false;

        eventsExample.createCriteria();
        this.previous = 0;
        this.following = 0;
        for (Events item : eventsMapper.selectByExample(eventsExample)) {
            if (found) {
                this.following = item.getId();
                return;
            }
            if (item.getId() == id) {
                found = true;
            }
            if (!found) {
                this.previous = item.getId();
            }
        }
    }

    public Map<Integer, Assistances> getAssists() {
        return assists;
    }

    public void setAssists(Map<Integer, Assistances> assists) {
        this.assists = assists;
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
