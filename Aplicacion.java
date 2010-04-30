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
    public static void InfoVector()
    {

    }
    public static Jugable EligeJuego()
    {
        Vector<Jugable> array=new Vector<Jugable>(3,2);
        int opcion;
        Jugable juegos[]=new Jugable[4];

        juegos[0]=new JuegoAdivinaNumero(3);
        juegos[1]=new JuegoAdivinaPar(3);
        juegos[2]=new JuegoAdivinaImpar(3);
        juegos[3]=new JuegoAhorcado(3,"muerete");

        System.out.print("A que juego deseas jugar?\n\n" +
                "\tAl juego adivina número (0)\n" +
                "\tAl juego adivina un par (1)\n" +
                "\tAl juego adivina impar  (2)\n" +
                "\tAl juego del ahorcado   (3)\n\n\t" +
                "Elije:");
        do
            opcion=Teclado.LeeEntero();
        while(opcion<0||opcion>3);

        return juegos[opcion];
    }
    public static void main(String argv[])
    {
        Jugable opcion;
        boolean seguir;
        do
        {
            opcion=EligeJuego();

            opcion.MuestraNombre();
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
