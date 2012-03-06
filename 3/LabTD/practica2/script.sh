#!/bin/sh

if [ ! $# -eq 2 ] 
then
    echo "No hay suficientes argumentos"
    echo "Primer argumento un fichero de trazas: *.tr"
    echo "Segundo argumento, longitud de la cola"
    exit
fi

for a in `find $1` 
do
    if
        string=$a
        num_char=`echo $string | wc -c`
        final=$(echo $string | cut -c `expr $num_char - 2`-$num_char)
        test $final = "tr"
    then
        echo $a sale adelante
        for b in `echo $2| xargs -0 -d,` ; do
            if [ $b -ge 1 ];then
                comando="ns main.tcl $string $b"
                echo $comando
                $comando
            else
                echo bad string $b
            fi
        done
    fi
done
exit
