/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package general;

import general.clases.Publicaciones;
import general.interfaces.Prestable;
import general.excepciones.*;

/**
 *
 * @author Javier
 */
public class Gestion
{
    public static int buscarSitioPrestable(Prestable a[]) throws SitioExcepcion
    {
        int i=0;
        boolean e =false;
        while(e==false&&i<a.length)
            if(a[i]==null)
                e=true;
            else
                i++;
        if(i==a.length)
            throw new SitioExcepcion();
        return i;
    }
    public static int buscarObjetoPrestable(Prestable a[],Prestable o,String codigo) throws PrestadoExcepcion
    {
        int i=0;
        boolean e=false;
        while(e==false&&i<a.length)
            if(a[i]==o)
                e=true;
            else
                i++;
        if(i<a.length)
            throw new PrestadoExcepcion(i,codigo);
        return i;
    }
    

}
