/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.mybatis;
import java.io.InputStream;
import org.apache.ibatis.io.Resources;
/**
 *
 * @author javier
 */
public class Lmb97SqlSessionFactory {
    public static org.apache.ibatis.session.SqlSessionFactory builder=null;
    private static String resource="org/lmb97/mybatis/mybatis-config.xml";
    
    public Lmb97SqlSessionFactory() throws java.io.IOException {
        if(builder==null){
            InputStream inputStream=Resources.getResourceAsStream(resource);
            builder=new org.apache.ibatis.session.SqlSessionFactoryBuilder().build(inputStream);
        }
    }
}
