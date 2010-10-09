/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package general.excepciones;

/**
 *
 * @author Javier
 */
public class PrestadoExcepcion extends Exception
{
    void serialVersionUID(){}

    private int indice;
    private String prestable;

    public PrestadoExcepcion(int i,String p)
    {
        indice=i;
        prestable=p;
    }

    public void mensaje()
    {
        System.out.println("La publicación de código " + prestable + " ya ha sido prestada ");
    }

    public int getindice()
    {
        return indice;
    }
}
