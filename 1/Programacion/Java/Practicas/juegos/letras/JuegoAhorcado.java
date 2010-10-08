/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos.letras;
import java.io.*;
import juegos.excepciones.JuegoException;
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
        boolean vidillas=true;
        int i,x=0;
        char intro,aj[]=new char[AAdivinar.length()];
        String Incognita="";
        for(i=0;i<AAdivinar.length();i++)
            aj[i]='-';
        Incognita=Incognita.copyValueOf(aj);
        while(!Incognita.contentEquals(AAdivinar)&&vidillas)
        {
            x=-1;
            System.out.println(Incognita+"\n\t");
            System.out.print("Introduce una letra que creas que este contenida" +
                    " en la palabra:");

            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            do
            {
                try
                {
                    intro=br.readLine().toUpperCase().toLowerCase().charAt(0);
                    if(java.lang.Character.isDigit(intro))
                        System.err.println("Introduce una letra!");
                }
                catch (Exception e)
                {
                    intro=0;
                }
            }
            while(!java.lang.Character.isLetter(intro));
            if(AAdivinar.indexOf(intro)>-1)
                while(AAdivinar.indexOf(intro,x)!=-1)
                {
                    char a[]=Incognita.toCharArray();
                    x=AAdivinar.indexOf(intro,x);
                    a[x]=intro;
                    x++;
                    Incognita=Incognita.copyValueOf(a);
                }
            if(Incognita.contentEquals(AAdivinar))
                System.out.println(AAdivinar+"\nPorfin has acabado,... la siguie" +
                        "nte vez, pide ayuda, que veo que te cuesta");
            else if(Incognita.indexOf(intro)==-1)
                vidillas=QuitaVida();
        }

    }
    public JuegoAhorcado(int Vidas,String Adivinar) throws JuegoException
    {
        super(Vidas);
        int x;
        Character y;
        for(x=0;x<Adivinar.length();x++)
            if(((Character)Adivinar.charAt(x)).isDigit(Adivinar.charAt(x)))
            {
                throw new JuegoException("Se esta intentando hacer adivinar u" +
                        "n numero... eso es trampa");
            }
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
    public String MuestraNombre()
    {
        return "Adivina una palabra!";
    }

}
