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
public class Instrument {
    private int id;
    private String instrument;
    private static Set<Instrument> instruments=new HashSet<Instrument>();

    public Instrument() {
        instruments.add(this);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getInstrument() {
        return instrument;
    }

    public void setInstrument(String instrument) {
        this.instrument = instrument;
    }

    public static Set<Instrument> getInstruments() {
        return instruments;
    }

}
