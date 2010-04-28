/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



/**
 *
 * @author Javier
 */
public class JuegoAdivinaNumero  extends Juego
{
    int AAdivinar;

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
        return true;
    }

    public JuegoAdivinaNumero(int a,int b)
    {
        super(a);
        AAdivinar=b;
        
    }





}
