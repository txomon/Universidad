package org.lmb97.data;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.lmb97.data.RelPeopleInstruments;
import org.lmb97.data.RelPeopleInstrumentsExample;

public interface RelPeopleInstrumentsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int countByExample(RelPeopleInstrumentsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int deleteByExample(RelPeopleInstrumentsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int insert(RelPeopleInstruments record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int insertSelective(RelPeopleInstruments record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    List<RelPeopleInstruments> selectByExample(RelPeopleInstrumentsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    RelPeopleInstruments selectByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int updateByExampleSelective(@Param("record") RelPeopleInstruments record, @Param("example") RelPeopleInstrumentsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int updateByExample(@Param("record") RelPeopleInstruments record, @Param("example") RelPeopleInstrumentsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int updateByPrimaryKeySelective(RelPeopleInstruments record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table rel_people_instruments
     *
     * @mbggenerated Tue Apr 17 19:12:25 CEST 2012
     */
    int updateByPrimaryKey(RelPeopleInstruments record);
}