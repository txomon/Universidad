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
public class MusicFile {
    private static Set<MusicFile> musicFiles=new HashSet<MusicFile>();
    private int id;
    private byte voicesNumber;
    private File file;

    public MusicFile() {
        musicFiles.add(this);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public byte getVoicesNumber() {
        return voicesNumber;
    }

    public void setVoicesNumber(byte voicesNumber) {
        this.voicesNumber = voicesNumber;
    }

    public static Set<MusicFile> getMusicFiles() {
        return musicFiles;
    }
    
    
}
