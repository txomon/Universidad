package org.lmb97.data;

import java.util.Date;

public class Seasons {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column seasons.id
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    private Integer id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column seasons.year
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    private Date year;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column seasons.spell
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    private Boolean spell;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column seasons.id
     *
     * @return the value of seasons.id
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public Integer getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column seasons.id
     *
     * @param id the value for seasons.id
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column seasons.year
     *
     * @return the value of seasons.year
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public Date getYear() {
        return year;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column seasons.year
     *
     * @param year the value for seasons.year
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void setYear(Date year) {
        this.year = year;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column seasons.spell
     *
     * @return the value of seasons.spell
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public Boolean getSpell() {
        return spell;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column seasons.spell
     *
     * @param spell the value for seasons.spell
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void setSpell(Boolean spell) {
        this.spell = spell;
    }
}