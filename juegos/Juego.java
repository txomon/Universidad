/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos;
import profesor.Teclado;
/**
 *
 * @author Javier
 */
public abstract class Juego
{
    private int vidas,vidasiniciales;
    private static int record;


    public Juego(int a)
    {
        vidas=a;
        vidasiniciales=a;
    }
    void MostrarVidasRestantes()
    {
        System.out.println("Te quedan " + vidas + " vidas");
        return;
    }

    public boolean QuitaVida()
    {
        boolean a=true;

        vidas--;
        if(vidas==0)
        {
            System.out.println("Juego Terminado, no quedan mas vidas que malgastar contigo");
            a=false;
        }
        return a;
    }
    public void ReiniciaPartida()
    {
        vidas=vidasiniciales;
    }
    void ActualizaRecord()
    {
        if(vidas>record)
        {
            System.out.println("Has superado el record, pero sigues siendo inutil");
            record=vidas;
        }
        if(vidas==record)
        {
            System.out.println("Has igualado el record, pero como inutil que eres, te has quedado a las puertas");
        }
    }

    public static int CrearAleatorio()
    {
        java.util.Date seed=new java.util.Date();
        java.util.Random ramdom = new java.util.Random(seed.getTime());
        ramdom.setSeed(seed.getTime());
        return ramdom.nextInt();
    }

    public String getVidas()
    {
        return String.valueOf(vidas);
    }



}

