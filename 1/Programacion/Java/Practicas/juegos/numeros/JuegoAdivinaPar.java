/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package juegos.numeros;

/**
 *
 * @author Javier
 */
public class JuegoAdivinaPar extends juegos.numeros.JuegoAdivinaNumero
{
    boolean ValidaNumero(int a)
    {
        if(a<0||a>10)
        {
            System.out.println("A ver, cosa fea, especie subdesarrollada, creo" +
                    "que no pillas la idea de UN NÚMERO DEL 0 AL 10!");
        }
        if(0!=a%2)
        {
            System.out.println("Eh! Tu! Proyecto de embrión! Cosa! No has" +
                    " introducido un numero par!");
            return false;
        }
        else
            return true;
    }
    @Override
    public void Juega()
    {
        System.out.print("Este es el Juego Par. ");
        super.Juega();
    }

    public JuegoAdivinaPar(int a)
    {
        super(a);
        AAdivinar=ValidarAleatorio();
    }

    @Override
    public String MuestraNombre()
    {
        return "Adivina un número par!";
    }
    @Override
    public void MuestraInfo()
    {
        System.out.println("Este juego consiste en adivinar un número par, de 0 al " +
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
        while(x%2!=0);

        return x;
    }
}
