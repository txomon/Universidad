package org.lmb97.data;

public class Emails {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column emails.id
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    private Integer id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column emails.name
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    private String name;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column emails.active
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    private Boolean active;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column emails.id
     *
     * @return the value of emails.id
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    public Integer getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column emails.id
     *
     * @param id the value for emails.id
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column emails.name
     *
     * @return the value of emails.name
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    public String getName() {
        return name;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column emails.name
     *
     * @param name the value for emails.name
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column emails.active
     *
     * @return the value of emails.active
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    public Boolean getActive() {
        return active;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column emails.active
     *
     * @param active the value for emails.active
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    public void setActive(Boolean active) {
        this.active = active;
    }
}