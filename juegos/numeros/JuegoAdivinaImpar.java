/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos.numeros;

/**
 *
 * @author Javier
 */
public class JuegoAdivinaImpar extends juegos.numeros.JuegoAdivinaNumero
{
    public JuegoAdivinaImpar(int a)
    {
        super(a);
        AAdivinar=ValidarAleatorio();
    }

    @Override
    public void Juega()
    {
        System.out.print("Este es el Juego Impar. ");
        super.Juega();
    }

    @Override
    public boolean ValidaNumero(int a)
    {
        if(a<0||a>10)
        {
            System.out.println("A ver inteligencia superior, el número introducido" +
                    " no esta entre 0 y 10");
            return false;
        }

        if(0==a%2)
        {
            System.out.println("Eh! Tu! Eslabon perdido, tu familia de paletos te " +
                    "está bucando! Como hay que decirte que esto es el juego de" +
                    " adivinar impares?");
            return false;
        }
        else
            return true;
    }
    @Override
    public String MuestraNombre()
    {
        return"Adivina un número impar!";
    }
    @Override
    public void MuestraInfo()
    {
        System.out.println("Este juego consiste en adivinar un número impar, de 0 al " +
                "10, disponiendo de "+intentos+" intentos.");
    }
    @Override
    public int ValidarAleatorio()
    {
        int x;
        do{
            x=CrearAleatorio();
            x%=11;
        }
        while(x%2==0);

        return x;
    }
}
