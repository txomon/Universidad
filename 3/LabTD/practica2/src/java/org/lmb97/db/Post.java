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
public class Post {
    private static Set<Post> posts=new HashSet<Post>();
    private int id;
    private String post;
    
    public Post(){
        posts.add(this);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }

    public static Set<Post> getPosts() {
        return posts;
    }

}