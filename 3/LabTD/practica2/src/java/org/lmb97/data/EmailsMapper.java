package org.lmb97.data;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.lmb97.data.Emails;
import org.lmb97.data.EmailsExample;

public interface EmailsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int countByExample(EmailsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int deleteByExample(EmailsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int insert(Emails record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int insertSelective(Emails record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    List<Emails> selectByExample(EmailsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    Emails selectByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int updateByExampleSelective(@Param("record") Emails record, @Param("example") EmailsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int updateByExample(@Param("record") Emails record, @Param("example") EmailsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int updateByPrimaryKeySelective(Emails record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table emails
     *
     * @mbggenerated Tue Apr 17 19:12:24 CEST 2012
     */
    int updateByPrimaryKey(Emails record);
}