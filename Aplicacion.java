/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



import juegos.numeros.JuegoAdivinaImpar;
import juegos.numeros.JuegoAdivinaNumero;
import juegos.numeros.JuegoAdivinaPar;
import juegos.letras.JuegoAhorcado;
import juegos.interfaces.Jugable;
import profesor.Teclado;
import java.util.Vector;

/**
 *
 * @author Javier
 */
public class Aplicacion
{
    public static void InfoVector(Vector a)
    {
        System.out.println("El tamaño del vector es "+a.size()+" y la capacidad "+a.capacity());
    }
    public static Jugable EligeJuego()
    {
        Vector<Jugable> array=new Vector<Jugable>(3,2);
        int opcion,x;

        InfoVector(array);
        array.add(new JuegoAdivinaPar(3));
        array.add(new JuegoAdivinaNumero(3));
        array.add(new JuegoAdivinaImpar(3));
        array.add(new JuegoAhorcado(3,"muerete"));
        InfoVector(array);

        System.out.print("A que juego deseas jugar?\n\n");
        for(x=0;x<array.size();x++)
            System.out.println("\tAl juego \""+array.elementAt(x).MuestraNombre()
                    +"\"  ("+x+")");
//                "\tAl juego adivina número (0)\n" +
//                "\tAl juego adivina un par (1)\n" +
//                "\tAl juego adivina impar  (2)\n" +
//                "\tAl juego del ahorcado   (3)\n\n\t" +
                System.out.println("\n\tElije:");
        do
        {
            opcion=Teclado.LeeEntero();
        }
        while(opcion<0||opcion>3);

        return array.elementAt(opcion);
    }
    public static void main(String argv[])
    {
        Jugable opcion;
        boolean seguir;
        do
        {
            opcion=EligeJuego();

            System.out.println(opcion.MuestraNombre());
            opcion.MuestraInfo();
            opcion.Juega();

            seguir=Preguntar();
        }
        while(seguir);

    }

    public static boolean Preguntar()
    {
        char marcado;

        System.out.println("\n\nCacho friky quieres probar a perder otra vez?([S]/N)");

        marcado=Teclado.LeeCaracter();
        if(marcado!='n'&&marcado!='N')
            return true;
        return false;

    }


}
