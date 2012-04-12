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
public class Season {
    private static Set<Season> seasons=new HashSet<Season>();
    private int id;
    private Date year;
    private java.lang.Boolean spell;
    
    public Season(){
        seasons.add(this);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Boolean getSpell() {
        return spell;
    }

    public void setSpell(Boolean spell) {
        this.spell = spell;
    }

    public Date getYear() {
        return year;
    }

    public void setYear(Date year) {
        this.year = year;
    }

    public static Set<Season> getSeasons() {
        return seasons;
    }
    
    
}
