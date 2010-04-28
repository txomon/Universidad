/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


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

    public abstract void Juega();
    boolean QuitaVida()
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
    void ReiniciaPartida()
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
}

