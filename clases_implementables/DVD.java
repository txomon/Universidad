/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package clases_implementables;

import general.clases.SopInform;

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
