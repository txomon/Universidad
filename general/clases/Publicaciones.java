/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package general.clases;

/**
 *
 * @author Javier
 */
import profesor.Teclado;

public class Publicaciones
{
	private static int numPublicaciones;//Numero de publicaciones que se van dando de alta
	private String titulo;
	private String codigo;


	public Publicaciones(String prefijo, String pregunta)
	{
		
		System.out.println("Por favor introduzca el nombre de" + pregunta);
		titulo=Teclado.LeeCadena();
		++numPublicaciones;
		codigo=prefijo+numPublicaciones;
		mensajeAlta();
        }

	void mensajeAlta()
	{
		System.out.println("Se acaba de dar de alta la publicación de codigo " + codigo + "\n\n");
		return;
	}

	void CambiarTitulo()
	{
		System.out.println("Se acaba de pedir el cambio de nombre de la publicación " + titulo + "\n\tIntroduce nuevo titulo");
		titulo=Teclado.LeeCadena();
		System.out.println("Se acaba de cambiar el nombre a " + titulo );
	}

	static int getNumPublicaciones()
	{
		return numPublicaciones;
	}

        public String getTitulo()
        {
            return titulo;
        }

        public String getCodigo()
        {
            return codigo;
        }


}
