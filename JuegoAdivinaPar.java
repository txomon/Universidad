/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



/**
 *
 * @author Javier
 */
public class JuegoAdivinaPar extends JuegoAdivinaNumero
{
    @Override
    public boolean ValidaNumero(int a)
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

    public JuegoAdivinaPar(int a, int b)
    {
        super(a,b);
    }

    @Override
    public void MuestraNombre()
    {
        System.out.println("Adivina un número par!");
    }
    @Override
    public void MuestraInfo()
    {
        System.out.println("Este juego consiste en adivinar un número par, de 0 al " +
                "10, disponiendo de "+intentos+" intentos.");
    }
}
