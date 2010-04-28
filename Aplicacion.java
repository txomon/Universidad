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


        JuegoAdivinaNumero jugadornumerico=new JuegoAdivinaNumero(3,7);
        JuegoAdivinaPar jugadorpar=new JuegoAdivinaPar(3,4);
        JuegoAdivinaImpar jugadorimpar=new JuegoAdivinaImpar(3,9);

        jugadornumerico.Juega();
        jugadorpar.Juega();
        jugadorimpar.Juega();

        return;
    }

}
