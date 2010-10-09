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
final public class Libro extends Enpapel
{
   
    public Libro()
    {
        super("L","l libro");
        diasdeprestamo=30;
    }

    @Override
    public String getTipo(String a)
    {
        if(a.equals("articulo"))
            return "el libro";
        if(a.equals("sustantivo"))
            return "libro";
        if(a.equals("Articulo"))
            return "El libro";
        if(a.equals("sexo"))
            return "o";
        return "";
    }


    public String getSimpleName()
    {
        return this.getCodigo();
    }


}
