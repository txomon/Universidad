/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



import juegos.numeros.JuegoAdivinaImpar;
import juegos.numeros.JuegoAdivinaNumero;
import juegos.numeros.JuegoAdivinaPar;
import juegos.letras.JuegoAhorcado;
import juegos.interfaces.Jugable;
import juegos.excepciones.JuegoException;
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
    public static Jugable EligeJuego() throws JuegoException
    {
        Vector<Jugable> array=new Vector<Jugable>(3,2);
        int opcion,x;

        InfoVector(array);
        array.add(new JuegoAdivinaPar(3));
        array.add(new JuegoAdivinaNumero(3));
        array.add(new JuegoAdivinaImpar(3));
        array.add(new JuegoAhorcado(3,"mue3ete"));
        InfoVector(array);

        System.out.print("A que juego deseas jugar?\n\n");
        for(x=0;x<array.size();x++)
            System.out.println("\tAl juego \""+array.elementAt(x).MuestraNombre()
                    +"\"  ("+x+")");
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
        try{
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
        catch(JuegoException e)
        {
            System.out.println("La razón por la que se ha acabado el progarama es porque " + e.getDescripcion());
        }
        finally
        {
            System.out.println("Juego(s) terminado(s), Fin de Partida");
        }

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
