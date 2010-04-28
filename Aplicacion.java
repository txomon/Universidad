/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



/**
 *
 * @author Javier
 */
public class Aplicacion {
    public static void main(String argv[])
    {
        Juego jugador=new Juego(5);

        jugador.MostrarVidasRestantes();

        jugador.QuitaVida();
        jugador.ActualizaRecord();
        jugador.MostrarVidasRestantes();

        jugador.ReiniciaPartida();
        jugador.MostrarVidasRestantes();
        Juego jugador2=new Juego(5);
        jugador2.ActualizaRecord();

        jugador2.MostrarVidasRestantes();
        jugador.MostrarVidasRestantes();
        return;
    }

}
