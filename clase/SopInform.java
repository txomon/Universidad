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
                boolean existe=false,encuentra=false;
                while(elementos.size()>i&&!encuentra)
                {
                    if((elementos.elementAt(i).getTitulo().compareTo(this.getTitulo()))>=0)
                        encuentra=true;
                    else
                        i++;
                }
                if(encuentra)
                
//                    if(elementos.elementAt(i)==null)
//                }
//                if(!existe&&elementos.size()>i)
//                {
                    if((elementos.elementAt(i).getTitulo().compareTo(this.getTitulo()))==0)
                        elementos.setElementAt(this, i);
                    else
                        elementos.insertElementAt(this,i);
                
                else 
                    elementos.add(this);
	}

        abstract String InfoPC();

        static void VisualizarTodo()
        {
            int i=0;
            System.out.println("Codigo\tTitulo\t\tRequisitos Mínimos");
            for(i=0;elementos.size()>i;i++)
            {
                System.out.println(elementos.elementAt(i).getCodigo()+"\t"+elementos.elementAt(i).getTitulo()+"\t\t"+
                        elementos.elementAt(i).InfoPC());
            }
        }
}