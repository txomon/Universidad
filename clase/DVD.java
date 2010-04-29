/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clase;

/**
 *
 * @author Javier
 */
final public class DVD extends SopInform
{
    public DVD()
    {
        super("DVD","l DVD");
    }

    @Override
    public String InfoPC()
    {
        return "Requiere un PC de 256 Mbytes";
    }
}
