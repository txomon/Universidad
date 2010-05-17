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
            c=Gestion.buscarObjetoPrestable(a,this,this.getCodigo());
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
            System.out.println(this.getTipo("Articulo")+" te ha sido prestad"+this.getTipo("sexo")+" "+diasdeprestamo+" dias");
        }

    }
    @Override

    public void devolver(Prestable a[])
    {

        System.out.println("Has elegido devolver "+getTipo("articulo")+" "+getTitulo());
        
        try
        {
            Gestion.buscarObjetoPrestable(a,this,this.getCodigo());
            System.out.println("Este articulo no figura en la lista de prestados," +
                " comprueba que no está");

        }
        catch(PrestadoExcepcion e)
        {
            if(a[e.getindice()]!=null)
            {
                a[e.getindice()]=null;
                System.out.println("Acabas de devolver "+getTipo("articulo"));
            }
            else
                System.out.println("Ya habia sido devuelto el "+getTipo("articulo"));

        }

    }
    @Override
    public String getTipo(String a)
    {
        if(a.equals("articulo"))
            return "el CD";
        if(a.equals("sustantivo"))
            return "CD";
        if(a.equals("Articulo"))
            return "El CD";
        if(a.equals("sexo"))
            return "o";
        return "";
    }
    
    public String getSimpleName()
    {
        return this.getCodigo();
    }
}
