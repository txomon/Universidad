# Creamos el objeto de simulación
set simulacion [new Simulator]

# Resolvemos el Warning de la clase Tracefile
Tracefile set debug_ 0

# Compruebo que haya argumentos, que si no, da error
if { $argc < 1 } {
    puts "Pon un argumento con la ruta al archivo que se quiere"
    exit 0
} elseif { $argc == 1 } {
    set tam_cola 1000
    set fichero [lindex $argv 0]
    puts "Usando el fichero $fichero como origen de trazas"
} else {
    set tam_cola [lindex $argv 1]
    set fichero [lindex $argv 0]
    puts "Usando el fichero $fichero como origen de trazas"
    puts "Tamaño de cola de $tam_cola"
}

# Definimos los colores para cada tipo de tráfico
$simulacion color 1 Blue
$simulacion color 2 Red

# Trato el nombre del fichero para que no se sobreescriba la salida
set fichero_no_rute [lindex $[split $fichero /] end]
set nombre_generico $fichero_no_rute 

# Abrimos un archivo como escritura y lo hacemos salida para los datos de 
# representación nam
set traza_paquetes [open "paquetes_${tam_cola}_$nombre_generico" w]
set traza_monitor [open "monitor_${tam_cola}_$nombre_generico" w]

# Función que imprime el número total de paquetes tirados y de paquetes enviados
proc sacar_info_final_monitor {} {
    global monitor
    puts "Llegadas\tPerdidas\tSalidas"
    puts "[$monitor set parrivals_]\t\t[$monitor set pdrops_]\t\t[$monitor set pdepartures_]"
    puts "Porcentaje de pérdidas: [ expr 100*double([$monitor set pdrops_])/[$monitor set parrivals_] ]"
}

# Creamos la funcion de cierre, en la que se ejecuta el comando nam
proc finish {} {
    sacar_info_final_monitor
    global simulacion
    global traza_paquetes
    global traza_monitor
    $simulacion flush-trace
    close $traza_paquetes
    close $traza_monitor
    exit 0
}

set pdrop_ant 0
# Función de sacar la información del monitor
proc sacar_info_monitor {} {
    global simulacion
    global monitor
    global pdrop_ant
    global traza_monitor

    set ahora [$simulacion now]
    puts $traza_monitor "$ahora [$monitor set pkts_] [expr [$monitor set pdrops_] - $pdrop_ant]"
    set pdrop_ant [$monitor set pdrops_] 
    $simulacion at [expr $ahora+1] "sacar_info_monitor"
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
 
# Imponemos la limitación de tamaño de cola
$simulacion queue-limit $acceso $destino $tam_cola

# Creamos los agentes inyectores
set inyector_1 [new Agent/UDP]
set inyector_2 [new Agent/UDP]
set receptor [new Agent/Null]

# Creamos el objeto de trazas
$simulacion trace-queue $acceso $destino $traza_paquetes


# Creamos el monitor del enlace
set monitor [ $simulacion monitor-queue $acceso $destino $traza_monitor]

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
$ficherodetrazas filename $fichero

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

# Empezamos a sacar la información del monitor
$simulacion at 0.0 "sacar_info_monitor"

# Creamos el evento de finalización
$simulacion at 10 "finish"

# Ejecutamos el programa
$simulacion run
