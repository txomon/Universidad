/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.txomon;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

/**
 *
 * @author javier
 */
public class Database {
    private Connection conn;
    private String database;
    private Statement st;
    private ResultSet rs=null;

    private ResultSet executeQuery(String query, String iferror)
    {
        try{
            rs = conn.createStatement().executeQuery(query);
            if (st.execute(query)) {
                rs = st.getResultSet();
            }
        }catch(SQLException ex){
            System.out.println(iferror);
            System.out.println("SQLException: "+ ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }catch(Exception ex){
            System.out.println(iferror);
            System.out.println("Exception: "+ ex.getMessage());
            System.out.println("LocalizedMessage: " + ex.getLocalizedMessage());
        }
        
        return rs;
    }
    public Database()
    {
        try {
            // The newInstance() call is a work around for some
            // broken Java implementations
            Class.forName("com.mysql.jdbc.Driver").newInstance();
        } catch (Exception ex) {
            
        }
        try {
            conn = DriverManager.getConnection("jdbc:mysql://192.168.56.2:3306/example?" +
            "user=user&password=password");
        } catch (SQLException ex) {
            // handle any errors
            System.out.println("SQLException: " + ex.getMessage());
            System.out.println("SQLState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }catch(Exception ex){
            System.out.println("Error stablishing the database connection");
            System.out.println("Exception: "+ ex.getMessage());
            System.out.println("LocalizedMessage: " + ex.getLocalizedMessage());
        }
    }
    
    public ResultSet getTables()
    {
        return executeQuery("SHOW tables","Error adquiring Tables in Database");
    }
    
    public ResultSet getColumns(String table)
    {
        ResultSet rs;
        rs=executeQuery("SHOW COLUMNS FROM "+table, "Error adquiring columns"
                + "from Table "+table+", and Database "+database);
        return rs;
    }
    
    public ResultSet getSelect(String query)
    {
        ResultSet rs;
        rs=executeQuery(query, "Error executing Select query: " + query);
        return rs;
    }
    
    public ResultSet getInsert(String query)
    {
        ResultSet rs;
        rs=executeQuery(query, "Error executing Insert query: "+ query);
        return rs;
    }
    
}
