/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clases_implementables;

import general.clases.Enpapel;

/**
 *
 * @author Javier
 */
final public class Revista extends Enpapel
{
    
    public Revista()
    {
        super("R"," la revista");
        diasdeprestamo=15;
    }
    @Override
    public String getTipo(String a)
    {
        if(a.equals("articulo"))
            return "la revista";
        if(a.equals("sustantivo"))
            return "revista";
        if(a.equals("Articulo"))
            return "La revista";
        if(a.equals("sexo"))
            return "a";
        return "";
    }
    
    public String getSimpleName()
    {
        return this.getCodigo();
    }

}
