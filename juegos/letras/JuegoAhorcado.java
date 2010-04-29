/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos.letras;
import profesor.Teclado;
/**
 *
 * @author Javier
 */
public class JuegoAhorcado extends juegos.Juego implements juegos.interfaces.Jugable
{
    private String AAdivinar;

    @Override
    public void Juega()
    {
        int x;
        char introducido;
        String Incognita=null;
        for(x=0;x<AAdivinar.length();x++)
            Incognita.concat("-");
        while(!Incognita.contentEquals(AAdivinar))
        {
            System.out.println(Incognita+"\n\t");
            System.out.println("Introduce una letras que creas que este contenida" +
                    " en la palabra");
            introducido=Teclado.LeeCaracter();
            if(Incognita.length()>AAdivinar.indexOf(introducido)&&AAdivinar.indexOf(introducido)>-1)
                while(AAdivinar.indexOf(introducido)>-1)
                {
                    char a[]=Incognita.toCharArray();
                    a[AAdivinar.indexOf(introducido)]=introducido;
                    Incognita=a.toString();
                }
            if(Incognita.contentEquals(AAdivinar))
                System.out.println("Porfin has acabado,... la siguiente vez, pide ayuda");
            else
                QuitaVida();
        }

    }
    public JuegoAhorcado(int Vidas,String Adivinar)
    {
        super(Vidas);
        AAdivinar=Adivinar;
    }

    @Override
    public int ValidarAleatorio()
    {
        return 0;
    }

    @Override
    public void MuestraInfo()
    {
        System.out.println("Este juego consiste en adivinar una palabra, dispon" +
                "iendo de "+getVidas()+" intentos, aunque en tu caso no sea suficiente...");
    }

    @Override
    public void MuestraNombre()
    {
        System.out.println("Este es el juego del ahorcado");
    }

}
