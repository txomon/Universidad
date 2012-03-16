#!/bin/sh

if [ ! $# -eq 2 ] 
then
    echo "No hay suficientes argumentos"
    echo "Primer argumento un fichero de trazas: *.tr"
    echo "Segundo argumento, longitud de la cola"
    exit
fi
rm retardos_finales
for a in `find $1` 
do
    if
        string=$a
        num_char=`echo $string | wc -c`
        final=$(echo $string | cut -c `expr $num_char - 2`-$num_char)
        test $final = "tr"
    then
        retardos=""
        echo $a sale adelante
        retardos=`echo "$a"| awk -F_ '{print $2}'`
        for b in `echo $2| xargs -0 -d,` ; do
            if [ $b -ge 1 ];then
                ns main.tcl $string $b
                salidans=`echo $string | awk -v b=$b -F\/ '{print "paquetes_"b"_"$NF}'`
                awk -f queuedelay.awk $salidans | grep "^1" > delays
                awk -f delaycalc.awk delays
                retardo="$(awk -f delaycalc.awk delays)"
                retardos="$retardos $retardo"
                rm delays
                rm paquetes_*
                rm monitor_*
            else
                echo bad string $b
            fi
        done
        echo $retardos >> retardos_finales
    fi
done
comando="plot "
i=1
for b in `echo $2| xargs -0 -d,`; do
    i=`expr $i + 1`
    comando="$comando 'retardos_finales' using 1:$i with lines title \"$b\","
    echo $comando
done
sort -nk2 -o retardos_finales retardos_finales
comando=`echo $comando| sed -e "s/,$/;/"`
gnuplot -e "$comando" -persist
exit
