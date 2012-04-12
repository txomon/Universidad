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
public class Instrument {
    private int id;
    private String instrument;
    private static TreeSet<Instrument> instruments;

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

    public static TreeSet<Instrument> getInstruments() {
        return instruments;
    }

}
