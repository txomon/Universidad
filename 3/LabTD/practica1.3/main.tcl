# Creamos el objeto de simulación
set simulacion [new Simulator]

# Resolvemos el Warning de la clase Tracefile
Tracefile set debug_ 0

# Compruebo que haya argumentos, que si no, da error
    set num_fuentes 4
    set tam_cola 100
if { $argc < 1 } {
    puts "Pon un argumento con la ruta al archivo que se quiere"
    exit 0
} elseif { $argc == 1 } {
    set fichero [lindex $argv 0]
} elseif { $argc == 2 } {
    set tam_cola [lindex $argv 1]
    set fichero [lindex $argv 0]
} else {
    set num_fuentes [lindex $argv 2]
    set tam_cola [lindex $argv 1]
    set fichero [lindex $argv 0]
}
set ficheros [glob -directory $fichero * ]
puts "Usando el fichero $fichero como origen de trazas"
puts "Estos son los ficheros a usar de verdad a partir del argumento"
puts $ficheros

puts "Tamaño de cola de $tam_cola"
set HQsi 0
set LQsi 0
foreach archivo $ficheros {
    if { -1 != [string first "HQ" $archivo ]} {
        set HQs($HQsi) $archivo
        incr HQsi
    } elseif { -1 != [ string first "LQ" $archivo ]} {
        set LQs($LQsi) $archivo
        incr LQsi
    }
}
for { set i 0 } { $i < $HQsi } { incr i } {
    puts $HQs($i)
}

# Definimos los colores para cada tipo de tráfico
$simulacion color 1 Blue
$simulacion color 2 Red

# Trato el nombre del fichero para que no se sobreescriba la salida
set nombre_generico "trazas.tr" 

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
for { set i 0 } { $i < $num_fuentes} { incr i } {
    set fuentes($i) [$simulacion node]
}
set acceso [$simulacion node]
set destino [$simulacion node]

# Enlazamos los nodos entre sí
for { set i 0 } { $i < $num_fuentes} { incr i }  {
    $simulacion simplex-link $fuentes($i) $acceso 100Gb 0s DropTail
}
$simulacion simplex-link $acceso $destino 1Mb 10ms DropTail

# Orientamos los nodos
$simulacion simplex-link-op $acceso $destino orient right
 
# Imponemos la limitación de tamaño de cola
$simulacion queue-limit $acceso $destino $tam_cola

# Creamos los agentes inyectores
for { set i 0 } { $i < $num_fuentes} { incr i } {
    set inyectores($i) [new Agent/UDP]
}
set receptor [new Agent/Null]

# Creamos el objeto de trazas
$simulacion trace-queue $acceso $destino $traza_paquetes


# Creamos el monitor del enlace
set monitor [ $simulacion monitor-queue $acceso $destino $traza_monitor]

# Definimos los tráficos como de diferentes clases, y les asociamos
# diferentes colores

for { set i 0 } { $i < $num_fuentes} { incr i } {
    if { 0 == [ expr { $i / 2 } ] } {
        $inyectores($i) set class_ 1
    } else {
        $inyectores($i) set class_ 2
    }
}
# Asociamos los agentes a los nodos correspondientes
for { set i 0 } { $i < $num_fuentes} { incr i } {
    $simulacion attach-agent $fuentes($i) $inyectores($i)
}
$simulacion attach-agent $destino $receptor

# Creamos 1 generador de tráfico CBR y 1 generador de trazas personales 
for { set i 0 } { $i < $num_fuentes} { incr i } {
    set generadores($i) [new Application/Traffic/Trace]
}

# Creamos el contenedor de trazas
for { set i 0 } { $i < $num_fuentes} { incr i } {
    set ficherosdetrazas($i) [new Tracefile]
}

# Configuramos el contenedor de trazas
for { set i 0 } { $i < $num_fuentes} { incr i } {
    if { 0 == [ expr ($i / 2) ] } {
        $ficherosdetrazas($i) filename $HQs([expr (($i)/2)%$HQsi])
    } else {
        $ficherosdetrazas($i) filename $LQs([expr (($i)/2)%$LQsi])
    }
}

# Configuramos el creador de tráfico personalizado para que inyecte 
# paquetes del contenedor de trazas y lo añadimos al nodo
for { set i 0 } { $i < $num_fuentes} { incr i } {
    $generadores($i) attach-tracefile $ficherosdetrazas($i)
    $generadores($i) attach-agent $inyectores($i)
}


# Creamos las conexiones entre los inyectores y el receptor
for { set i 0 } { $i < $num_fuentes} { incr i } {
    $simulacion connect $inyectores($i) $receptor
}

# Creamos los eventos para que empiezen a transmitir
set rng [new RNG ]
$rng seed [expr [clock clicks] % 100000000 ]
puts "[$rng exponential]"

for { set i 0 } { $i < $num_fuentes} { incr i } {
    set var [$rng exponential ]
    puts "El tiempo de salida es $var"
    $simulacion at $var "$generadores($i) start"
    $simulacion at 9.99 "$generadores($i) stop"

}

# Empezamos a sacar la información del monitor
$simulacion at 0.0 "sacar_info_monitor"

# Creamos el evento de finalización
$simulacion at 10 "finish"

# Ejecutamos el programa
$simulacion run
