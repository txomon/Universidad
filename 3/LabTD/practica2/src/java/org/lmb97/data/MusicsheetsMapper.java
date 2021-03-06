package org.lmb97.data;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.lmb97.data.Musicsheets;
import org.lmb97.data.MusicsheetsExample;

public interface MusicsheetsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int countByExample(MusicsheetsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int deleteByExample(MusicsheetsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int deleteByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int insert(Musicsheets record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int insertSelective(Musicsheets record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    List<Musicsheets> selectByExample(MusicsheetsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    Musicsheets selectByPrimaryKey(Integer id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int updateByExampleSelective(@Param("record") Musicsheets record, @Param("example") MusicsheetsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int updateByExample(@Param("record") Musicsheets record, @Param("example") MusicsheetsExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int updateByPrimaryKeySelective(Musicsheets record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table musicsheets
     *
     * @mbggenerated Tue May 15 11:58:16 CEST 2012
     */
    int updateByPrimaryKey(Musicsheets record);
}