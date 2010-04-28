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
        if(0==a%2)
            return true;
        else
            return false;
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

}
