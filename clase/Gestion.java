/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clase;

/**
 *
 * @author Javier
 */
public class Gestion
{
    static int buscarSitioPrestable(Prestable a[])
    {
        int i=0;
        boolean e =false;
        while(e==false&&i<a.length)
            if(a[i]==null)
                e=true;
            else
                i++;
        return i;
    }
    static int buscarObjetoPrestable(Prestable a[],Prestable o)
    {
        int i=0;
        boolean e=false;
        while(e==false&&i<a.length)
            if(a[i]==null)
                e=true;
            else
                i++;
        return i;
    }
    

}
