#!/bin/sh

if [ ! $# -eq 4 ] 
then
    echo "No hay suficientes argumentos"
    echo "Primer argumento un fichero de trazas: *.tr"
    echo "Segundo argumento, longitud de la cola"
    echo "Tercer argumento, numero de nodos"
    echo "Cuarto argumento, numero de simulaciones por nivel"
    exit
fi
rm resultados
for a in `seq $3`
do
    echo "Nodos: $a"
    rm resultados_ronda
    for b in `seq $4` ; do
        echo "Ronda $a:$b"
        resultado=$(ns main.tcl $1 $2 $a | tail -n 1 | cut -d: -f 2 | cut -c 2- )
        echo $resultado >> resultados_ronda
        echo "Resultado de ronda $a:$b $resultado"
    done
    echo "$a $(awk -f calcular_media.awk resultados_ronda)" >> resultados
done
gnuplot -e "plot 'resultados' with lines" -persist
exit
