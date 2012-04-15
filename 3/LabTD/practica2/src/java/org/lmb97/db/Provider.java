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
public class Provider {
    private static Set<Provider> providers=new HashSet<Provider>();
    private String providerSources;
    private int id;
    
    public Provider(){
        providers.add(this);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProviderSources() {
        return providerSources;
    }

    public void setProviderSources(String providerSources) {
        this.providerSources = providerSources;
    }

    public static Set<Provider> getProviders() {
        return providers;
    }
    
}
