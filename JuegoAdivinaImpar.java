/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */



/**
 *
 * @author Javier
 */
public class JuegoAdivinaImpar extends JuegoAdivinaNumero
{
    public JuegoAdivinaImpar(int a,int b)
    {
        super(a,b);
    }

    public void Juega()
    {
        System.out.print("Este es el Juego Impar. ");
        super.Juega();
    }

    @Override
    public boolean ValidaNumero(int a)
    {
        if(0==a%2)
            return false;
        else
            return true;
    }

}
