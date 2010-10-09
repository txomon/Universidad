/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package general.clases;

import general.interfaces.Prestable;
import general.Gestion;
import general.excepciones.*;
/**
 *
 * @author Javier
 */

public abstract class Enpapel extends Publicaciones implements Prestable
{
    protected int diasdeprestamo;

    public Enpapel(String prefijo, String pregunta)
    {
		super(prefijo,pregunta);
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
                SitioExcepcion.mensaje();
            }
            a[x]=this;
            System.out.println(this.getTipo("Articulo")+" te ha sido prestad" + this.getTipo("sexo")+" "+diasdeprestamo+" dias");

        }

    }
    @Override

    public void devolver(Prestable a[])
    {

        System.out.println("Has elegido devolver "+getTipo("articulo")+" "+getTitulo());
   
        try
        {
            Gestion.buscarObjetoPrestable(a,this,this.getCodigo());
        }
        catch(PrestadoExcepcion e)
        {
            a[e.getindice()]=null;
            System.out.println("Acabas de devolver "+getTipo("articulo"));
        }
        catch(Exception e)
        {
            System.out.println("Este articulo no figura en la lista de prestados," +
                " comprueba que no está");
        }
    }
}

