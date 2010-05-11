/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package programas;

import clases_implementables.CD;
import clases_implementables.DVD;
import clases_implementables.Libro;
import general.interfaces.Prestable;
import clases_implementables.Revista;

/**
 *
 * @author Javier
 */
public class Programa
{
    static Prestable array[]=new Prestable [5];

    public static void main(String[] args)
    {

        Libro uno=new Libro(),dos=new Libro();
        Revista tres=new Revista(),cuatro=new Revista();
        CD cinco=new CD(),seis=new CD();
        DVD siete= new DVD(),ocho= new DVD();

        uno.Prestar(array);
        dos.Prestar(array);
        tres.Prestar(array);
        cuatro.Prestar(array);
        cinco.Prestar(array);
        seis.Prestar(array);
//error        siete.Prestar(array);
//error        ocho.Prestar(array);
        array.toString();

        uno.devolver(array);
        dos.devolver(array);
        tres.devolver(array);
        cuatro.devolver(array);
        cinco.devolver(array);
        seis.devolver(array);
//error        siete.devolver(array);
//error        ocho.devolver(array);
        array.toString();

        CD.VisualizarTodo();

    }

}
