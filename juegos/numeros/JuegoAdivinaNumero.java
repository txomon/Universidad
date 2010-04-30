/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos.numeros;

import profesor.Teclado;

/**
 *
 * @author Javier
 */
public class JuegoAdivinaNumero  extends juegos.Juego implements juegos.interfaces.Jugable
{
    int AAdivinar,intentos;


    public void Juega()
    {
        boolean vivito=true;
        ReiniciaPartida();

        do
        {
            System.out.print("Adivina un numerico del 0 al 10:");
            int introducido=Teclado.LeeEntero();
            if(ValidaNumero(introducido))
            {
                if(introducido==AAdivinar)
                {
                    System.out.println("\nPero si lo has acertaooo!!!");
                    return;
                }
                else
                {
                    vivito=QuitaVida();
                    if(vivito)
                        System.out.println("\nIntentalo otra vez pringao!");
                    else
                        System.out.println("\nYa no tengo mas tiempo para perder contigo idiota!");
                }
            }
        }
        while(vivito);
        return;
    }
    public boolean ValidaNumero(int a)
    {
        if(0<a&&a<10)
            return true;
        else
        {
            System.out.println("El numero que has introducido, fracasado, no está entre" +
                " 0 y 10");
            return false;
        }
    }
    public JuegoAdivinaNumero(int a)
    {
        super(a);
        intentos=a;

    }
    public String MuestraNombre()
    {
        return "Adivina un número!";
    }
    public void MuestraInfo()
    {
        System.out.println("Este juego consiste en adivinar un número, de 0 al " +
                "10, disponiendo de "+intentos+" intentos");
    }



    public int ValidarAleatorio()
    {
        int x=CrearAleatorio();
        x%=11;
        return x;
    }
}
