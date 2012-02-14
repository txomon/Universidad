# Creamos el objeto de simulación
set simulacion [new Simulator]

# Resolvemos el Warning de la clase Tracefile
Tracefile set debug_ 0

# Definimos los colores para cada tipo de tráfico
$simulacion color 1 Blue
$simulacion color 2 Red

# Abrimos un archivo como escritura y lo hacemos salida para los datos de 
# representación
set nf [open out.nam w]
$simulacion namtrace-all $nf

# Creamos la funcion de cierre, en la que se ejecuta el comando nam
proc finish {} {
        global simulacion nf
        $simulacion flush-trace
        close $nf
        exec nam out.nam &
        exit 0
}

# Creamos los nodos
set fuente_1 [$simulacion node]
set fuente_2 [$simulacion node]
set acceso [$simulacion node]
set destino [$simulacion node]

# Enlazamos los nodos entre sí
$simulacion simplex-link $fuente_1 $acceso 100Gb 0s DropTail 
$simulacion simplex-link $fuente_2 $acceso 100Gb 0s DropTail
$simulacion simplex-link $acceso $destino 100Mb 10ms DropTail

# Orientamos los nodos
$simulacion simplex-link-op $fuente_1 $acceso orient right-down
$simulacion simplex-link-op $fuente_2 $acceso orient right-up
$simulacion simplex-link-op $acceso $destino orient right

# Creamos los agentes inyectores
set inyector_1 [new Agent/UDP]
set inyector_2 [new Agent/UDP]
set receptor [new Agent/Null]

# Definimos los tráficos como de diferentes clases, y les asociamos
# diferentes colores
$inyector_1 set class_ 1
$inyector_2 set class_ 2

# Asociamos los agentes a los nodos correspondientes
$simulacion attach-agent $fuente_1 $inyector_1
$simulacion attach-agent $fuente_2 $inyector_2
$simulacion attach-agent $destino $receptor

# Creamos 1 generador de tráfico CBR y 1 generador de trazas personales 
set CBR1 [new Application/Traffic/CBR]
set poisson1 [new Application/Traffic/Trace]

# Creamos el contenedor de trazas
set ficherodetrazas [new Tracefile]

# Configuramos el creador de tráfico CBR1 para que inyecte 
# paquetes de 20 bytes a intervalos de 0.016 y lo añadimos al nodo
$CBR1 set packetSize_ 20
$CBR1 set interval_ 0.016
$CBR1 attach-agent $inyector_1

# Configuramos el contenedor de trazas
$ficherodetrazas filename poisson_0.75_100Mbps_350.tr

# Configuramos el creador de tráfico personalizado para que inyecte 
# paquetes del contenedor de trazas y lo añadimos al nodo
$poisson1 attach-tracefile $ficherodetrazas
$poisson1 attach-agent $inyector_2  

# Creamos las conexiones entre los inyectores y el receptor
$simulacion connect $inyector_1 $receptor
$simulacion connect $inyector_2 $receptor

# Creamos los eventos para que empiezen a transmitir
$simulacion at 0.01 "$CBR1 start"
$simulacion at 9.99 "$CBR1 stop"

$simulacion at 0.1 "$poisson1 start"
$simulacion at 9.99 "$poisson1 stop"

# Creamos el evento de finalización
$simulacion at 10 "finish"

# Ejecutamos el programa
$simulacion run
