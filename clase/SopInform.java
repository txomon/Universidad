/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


package clase;

import java.util.Vector;
/**
 *
 * @author Javier
 */

abstract class SopInform extends Publicaciones
{//practica de arrays dinamicos...
        private static Vector<SopInform> elementos=new Vector<SopInform>(0,1);
        static SopInform estuche[];
        private static int maximodeestuches=10;

	public SopInform(String prefijo, String pregunta)
	{
		super(prefijo,pregunta);
                int i=0;
                boolean e=false;
                for(i=0;elementos.size()>i&&!e;i++)
                {
                    if((elementos.elementAt(i).getTitulo().compareTo(this.getTitulo()))>=0)
                        e=true;
                }
                if(e)
                {
                    if((elementos.elementAt(i).getTitulo().compareTo(this.getTitulo()))==0)
                        elementos.setElementAt(this, i);
                    else
                        elementos.add(this);
                }
	}

        abstract String InfoPC();

        static void VisualizarTodo()
        {
            int i=0;
            System.out.println("\tNombre\t\tRequisitos Mínimos");
            for(i=0;elementos.size()>i;i++)
            {
                System.out.println("\t"+elementos.elementAt(i).getTitulo()+"\t\t"+
                        elementos.elementAt(i).InfoPC());
            }
        }
}