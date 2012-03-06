# Creamos el objeto de simulación
set simulacion_1 [new Simulator]

# Definimos los colores para cada tipo de tráfico
$simulacion_1 color 1 Blue
$simulacion_1 color 2 Red

# Abrimos un archivo como escritura y lo hacemos salida para los datos de 
# representación
set nf [open out.nam w]
$simulacion_1 namtrace-all $nf

# Creamos la funcion de cierre, en la que se ejecuta el comando nam
proc finish {} {
        global simulacion_1 nf
        $simulacion_1 flush-trace
        close $nf
        exec nam out.nam &
        exit 0
}

# Creamos los nodos
set fuente_1 [$simulacion_1 node]
set fuente_2 [$simulacion_1 node]
set acceso [$simulacion_1 node]
set destino [$simulacion_1 node]

# Enlazamos los nodos entre sí
$simulacion_1 simplex-link $fuente_1 $acceso 100Gb 0s DropTail 
$simulacion_1 simplex-link $fuente_2 $acceso 100Gb 0s DropTail
$simulacion_1 simplex-link $acceso $destino 100Mb 10ms DropTail

# Orientamos los nodos
$simulacion_1 simplex-link-op $fuente_1 $acceso orient right-down
$simulacion_1 simplex-link-op $fuente_2 $acceso orient right-up
$simulacion_1 simplex-link-op $acceso $destino orient right


# Creamos los agentes inyectores
set inyector_1 [new Agent/UDP]
set inyector_2 [new Agent/UDP]
set receptor [new Agent/Null]

# Definimos los tráficos como de diferentes clases, y les asociamos
# diferentes colores
$inyector_1 set class_ 1
$inyector_2 set class_ 2

# Asociamos los agentes a los nodos correspondientes
$simulacion_1 attach-agent $fuente_1 $inyector_1
$simulacion_1 attach-agent $fuente_2 $inyector_2
$simulacion_1 attach-agent $destino $receptor

# Creamos 2 generadores de tráfico CBR y un pozo receptor
set CBR1 [new Application/Traffic/CBR]
set CBR2 [new Application/Traffic/CBR]

# Configuramos el creador de tráfico CBR1 para que inyecte 
# paquetes de 20 bytes a intervalos de 0.016 y lo añadimos al nodo
$CBR1 set packetSize_ 20
$CBR1 set interval_ 0.016
$CBR1 attach-agent $inyector_1

# Configuramos el creador de tráfico CBR1 para que inyecte 
# paquetes de 20 bytes a intervalos de 0.0000016 y lo añadimos al nodo
$CBR2 set packetSize_ 20
$CBR2 set interval_ 0.0000016
$CBR2 attach-agent $inyector_2  

# Creamos las conexiones entre los inyectores y el receptor
$simulacion_1 connect $inyector_1 $receptor
$simulacion_1 connect $inyector_2 $receptor

# Creamos los eventos para que empiezen a transmitir
$simulacion_1 at 0.001 "$CBR1 start"
$simulacion_1 at 0.099 "$CBR1 stop"

$simulacion_1 at 0.01 "$CBR2 start"
$simulacion_1 at 0.099 "$CBR2 stop"

# Creamos el evento de finalización
$simulacion_1 at 0.1 "finish"

# Ejecutamos el programa
$simulacion_1 run
