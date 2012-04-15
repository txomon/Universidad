/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.lmb97.db;

import java.util.Set;
import java.util.HashSet;

/**
 *
 * @author javier
 */
public class Author {
    private static Set<Author> authors=new HashSet<Author>();
    private int id;
    private String author;
    private String style;

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStyle() {
        return style;
    }

    public void setStyle(String style) {
        this.style = style;
    }

    public static Set<Author> getAuthors() {
        return authors;
    }
    
    
}
