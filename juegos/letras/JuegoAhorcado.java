/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos.letras;
import java.io.*;

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
        int i,x=-1;
        char intro,aj[]=new char[AAdivinar.length()];
        String Incognita="";
        for(i=0;i<AAdivinar.length();i++)
            aj[i]='-';
        Incognita=Incognita.copyValueOf(aj);
        while(!Incognita.contentEquals(AAdivinar))
        {
            x=-1;
            System.out.println(Incognita+"\n\t");
            System.out.print("Introduce una letra que creas que este contenida" +
                    " en la palabra:");
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            try{intro=br.readLine().toUpperCase().toLowerCase().charAt(0);}catch (Exception e) { intro=0;}
            if(Incognita.length()>AAdivinar.indexOf(intro)&&AAdivinar.indexOf(intro)>-1)
                while(AAdivinar.indexOf(intro,x)!=-1&&x!=(AAdivinar.length()-1))
                {
                    char a[]=Incognita.toCharArray();
                    x=AAdivinar.indexOf(intro,x+1);
                    a[AAdivinar.indexOf(intro,x)]=intro;
                    Incognita=Incognita.copyValueOf(a);
                }
            if(Incognita.contentEquals(AAdivinar))
                System.out.println("Porfin has acabado,... la siguiente vez, pide ayuda");
            else if(Incognita.indexOf(intro)==-1)
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
