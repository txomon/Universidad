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
public class File {
    private static Set<File> files=new HashSet<File>();
    private String file;

    public File() {
        files.add(this);
    }

    public String getFile() {
        return file;
    }

    public void setFile(String file) {
        this.file = file;
    }

    public static Set<File> getFiles() {
        return files;
    }
    
}
