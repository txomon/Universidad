/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clase;

/**
 *
 * @author Javier
 */
public class Main
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

        SopInform.VisualizarTodo();

    }

}
