/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clases_implementables;

import general.excepciones.*;
import general.interfaces.Prestable;
import general.clases.SopInform;
import general.Gestion;

/**
 *
 * @author Javier
 */
final public class CD extends SopInform implements Prestable
{
    private static int diasdeprestamo=1;
    public CD()
    {
        super("CD","l CD"); 
    }

    @Override
    public String InfoPC()
    {
        return "Requiere un PC de 128 Mbytes";
    }

    @Override
    public void Prestar(Prestable a[])
    {
        System.out.println("Has elegido prestar "+ getTipo("articulo")+ " " +
                getTitulo() + " con codigo " + getCodigo());

        int c=0;
        try
        {
            c=Gestion.buscarObjetoPrestable(a,this);
        }
        catch(PrestadoExcepcion e)
        {
            e.mensaje();
        }
        if(c==a.length)
        {
            int x=0;
            try
            {
                x=Gestion.buscarSitioPrestable(a);
            }
            catch(SitioExcepcion e)
            {
                e.mensaje();
            }
            a[x]=this;
                       
        }

    }
    @Override

    public void devolver(Prestable a[])
    {

        System.out.println("Has elegido devolver "+getTipo("articulo")+" "+getTitulo());
        int c;
        try
        {
            c=Gestion.buscarObjetoPrestable(a,this);
        }
        catch(PrestadoExcepcion e)
        {
            a[e.getindice()]=null;
            System.out.println("Acabas de devolver "+getTipo("articulo"));
        }
        System.out.println("Este articulo no figura en la lista de prestamos," +
                " comprueba que no está");
    }
}
