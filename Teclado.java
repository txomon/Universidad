/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


import java.io.*;
public class Teclado {
public static char LeeCaracter() {
char ch;
try {
ch = LeeCadena().charAt(0);
} catch( Exception e ) {
ch = 0;
}
return ch;
}
public static String LeeCadena() {
BufferedReader br =
new BufferedReader(new InputStreamReader(System.in));
String str;
try {
str = br.readLine();
} catch( Exception e ) {
str = "";
}
return str;
}
public static int LeeEntero() {
int num;
try {
num = Integer.parseInt( LeeCadena().trim() );
} catch( Exception e ) {
num = 0;
}
return num;
}
}