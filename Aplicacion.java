/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



import juegos.numeros.JuegoAdivinaImpar;
import juegos.numeros.JuegoAdivinaNumero;
import juegos.numeros.JuegoAdivinaPar;
import juegos.interfaces.Jugable;
import profesor.Teclado;

/**
 *
 * @author Javier
 */
public class Aplicacion
{
    public static Jugable EligeJuego()
    {

        int opcion;
        Jugable juegos[]=new Jugable[3];

        juegos[0]=new JuegoAdivinaNumero(3);
        juegos[1]=new JuegoAdivinaPar(3);
        juegos[2]=new JuegoAdivinaImpar(3);

        System.out.print("A que juego deseas jugar?\n\n" +
                "\tAl juego adivina número (0)\n" +
                "\tAl juego adivina un par (1)\n" +
                "\tAl juego adivina impar  (2)\n\n\t" +
                "Elije:");
        do
            opcion=Teclado.LeeEntero();
        while(opcion<0||opcion>2);

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
