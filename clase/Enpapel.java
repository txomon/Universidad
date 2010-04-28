/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clase;

/**
 *
 * @author Javier
 */

public class Enpapel extends Publicaciones implements Prestable
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

        if(Gestion.buscarObjetoPrestable(a,this)<a.length)
        {
            int x=Gestion.buscarSitioPrestable(a);
            if(x==a.length)
                System.out.println("Lo siento, pero no se te puede prestar "+getTipo("articulo") +
                        " por que no se pueden hacer mas prestamos");
            else
            {
                System.out.println("Se te ha prestado por "+diasdeprestamo+" dias");
                a[x]=this;
            }

        }
        else
        {
            System.out.print("Lo siento, pero no se puede prestar " + getTipo("articulo"));
            if(Gestion.buscarSitioPrestable(a)==a.length)
            {
                System.out.println(" porque ademas de ya haber sido prestado," +
                        "       no se pueden hacer más préstamos");
                return;
            }
            else
                System.out.println(" porque ya ha sido prestado");
        }
    }

    @Override
    public void devolver(Prestable a[])
    {

        System.out.println("Has elegido devolver "+getTipo("articulo")+" "+getTitulo());
        if(Gestion.buscarObjetoPrestable(a, this)<a.length)
        {
            int x=Gestion.buscarObjetoPrestable(a, this);
            a[x]=null;
            System.out.println("Acabas de devolver "+getTipo("articulo"));
        }
        else
        {
            System.out.println("Este articulo no figura en la lista de prestamos," +
                    " comprueba que no está");

        }
    }
}

