package org.lmb97.data;

import java.util.ArrayList;
import java.util.List;

public class RelRelPeopleInstrumentsSeasonsExample {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    protected String orderByClause;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    protected boolean distinct;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    protected List<Criteria> oredCriteria;

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public RelRelPeopleInstrumentsSeasonsExample() {
        oredCriteria = new ArrayList<Criteria>();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void setOrderByClause(String orderByClause) {
        this.orderByClause = orderByClause;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public String getOrderByClause() {
        return orderByClause;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void setDistinct(boolean distinct) {
        this.distinct = distinct;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public boolean isDistinct() {
        return distinct;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public List<Criteria> getOredCriteria() {
        return oredCriteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void or(Criteria criteria) {
        oredCriteria.add(criteria);
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public Criteria or() {
        Criteria criteria = createCriteriaInternal();
        oredCriteria.add(criteria);
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public Criteria createCriteria() {
        Criteria criteria = createCriteriaInternal();
        if (oredCriteria.size() == 0) {
            oredCriteria.add(criteria);
        }
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    protected Criteria createCriteriaInternal() {
        Criteria criteria = new Criteria();
        return criteria;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public void clear() {
        oredCriteria.clear();
        orderByClause = null;
        distinct = false;
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    protected abstract static class GeneratedCriteria {
        protected List<Criterion> criteria;

        protected GeneratedCriteria() {
            super();
            criteria = new ArrayList<Criterion>();
        }

        public boolean isValid() {
            return criteria.size() > 0;
        }

        public List<Criterion> getAllCriteria() {
            return criteria;
        }

        public List<Criterion> getCriteria() {
            return criteria;
        }

        protected void addCriterion(String condition) {
            if (condition == null) {
                throw new RuntimeException("Value for condition cannot be null");
            }
            criteria.add(new Criterion(condition));
        }

        protected void addCriterion(String condition, Object value, String property) {
            if (value == null) {
                throw new RuntimeException("Value for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value));
        }

        protected void addCriterion(String condition, Object value1, Object value2, String property) {
            if (value1 == null || value2 == null) {
                throw new RuntimeException("Between values for " + property + " cannot be null");
            }
            criteria.add(new Criterion(condition, value1, value2));
        }

        public Criteria andPersonInstrumentIsNull() {
            addCriterion("person_instrument is null");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentIsNotNull() {
            addCriterion("person_instrument is not null");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentEqualTo(Integer value) {
            addCriterion("person_instrument =", value, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentNotEqualTo(Integer value) {
            addCriterion("person_instrument <>", value, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentGreaterThan(Integer value) {
            addCriterion("person_instrument >", value, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentGreaterThanOrEqualTo(Integer value) {
            addCriterion("person_instrument >=", value, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentLessThan(Integer value) {
            addCriterion("person_instrument <", value, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentLessThanOrEqualTo(Integer value) {
            addCriterion("person_instrument <=", value, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentIn(List<Integer> values) {
            addCriterion("person_instrument in", values, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentNotIn(List<Integer> values) {
            addCriterion("person_instrument not in", values, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentBetween(Integer value1, Integer value2) {
            addCriterion("person_instrument between", value1, value2, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andPersonInstrumentNotBetween(Integer value1, Integer value2) {
            addCriterion("person_instrument not between", value1, value2, "personInstrument");
            return (Criteria) this;
        }

        public Criteria andSeasonIsNull() {
            addCriterion("season is null");
            return (Criteria) this;
        }

        public Criteria andSeasonIsNotNull() {
            addCriterion("season is not null");
            return (Criteria) this;
        }

        public Criteria andSeasonEqualTo(Integer value) {
            addCriterion("season =", value, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonNotEqualTo(Integer value) {
            addCriterion("season <>", value, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonGreaterThan(Integer value) {
            addCriterion("season >", value, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonGreaterThanOrEqualTo(Integer value) {
            addCriterion("season >=", value, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonLessThan(Integer value) {
            addCriterion("season <", value, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonLessThanOrEqualTo(Integer value) {
            addCriterion("season <=", value, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonIn(List<Integer> values) {
            addCriterion("season in", values, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonNotIn(List<Integer> values) {
            addCriterion("season not in", values, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonBetween(Integer value1, Integer value2) {
            addCriterion("season between", value1, value2, "season");
            return (Criteria) this;
        }

        public Criteria andSeasonNotBetween(Integer value1, Integer value2) {
            addCriterion("season not between", value1, value2, "season");
            return (Criteria) this;
        }
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated do_not_delete_during_merge Tue Apr 17 19:12:25 CEST 2012
     */
    public static class Criteria extends GeneratedCriteria {

        protected Criteria() {
            super();
        }
    }

    /**
     * This class was generated by MyBatis Generator.
     * This class corresponds to the database table rel__rel_people_instruments__seasons
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    public static class Criterion {
        private String condition;

        private Object value;

        private Object secondValue;

        private boolean noValue;

        private boolean singleValue;

        private boolean betweenValue;

        private boolean listValue;

        private String typeHandler;

        public String getCondition() {
            return condition;
        }

        public Object getValue() {
            return value;
        }

        public Object getSecondValue() {
            return secondValue;
        }

        public boolean isNoValue() {
            return noValue;
        }

        public boolean isSingleValue() {
            return singleValue;
        }

        public boolean isBetweenValue() {
            return betweenValue;
        }

        public boolean isListValue() {
            return listValue;
        }

        public String getTypeHandler() {
            return typeHandler;
        }

        protected Criterion(String condition) {
            super();
            this.condition = condition;
            this.typeHandler = null;
            this.noValue = true;
        }

        protected Criterion(String condition, Object value, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.typeHandler = typeHandler;
            if (value instanceof List<?>) {
                this.listValue = true;
            } else {
                this.singleValue = true;
            }
        }

        protected Criterion(String condition, Object value) {
            this(condition, value, null);
        }

        protected Criterion(String condition, Object value, Object secondValue, String typeHandler) {
            super();
            this.condition = condition;
            this.value = value;
            this.secondValue = secondValue;
            this.typeHandler = typeHandler;
            this.betweenValue = true;
        }

        protected Criterion(String condition, Object value, Object secondValue) {
            this(condition, value, secondValue, null);
        }
    }
}