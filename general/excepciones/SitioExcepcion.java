/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package general.excepciones;

/**
 *
 * @author Javier
 */
public class SitioExcepcion extends Exception
{
    private static String mensaje="Lo sentimos, la biblioteca no puede prestar más publicaciones";
    public SitioExcepcion(){}

    public static void mensaje()
    {
        System.out.println(mensaje);
    }
    void serialVersionUID(){}
}