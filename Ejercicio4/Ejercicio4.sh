#!/bin/bash

help () {
        echo "El script permite:"
        echo "• Eliminar espacios duplicados."
        echo "• Eliminar espacios de más antes de un punto (.), coma (,) o punto y coma (;)"
        echo "• Agregar un espacio luego de un punto seguido, coma o punto y coma (En caso de que no lo tuviera)."
        echo "Paramentros necesarios para el correcto funcionamiento del script:"
        echo "1:    -in"
        echo "2:    Archivo de entrada: archivo txt que se analizará"
        echo ""
        echo "Ejemplo"
        echo "./Corrector.sh -in [archivo]"

   exit
}
mensajeErrorCantParametros () {
   echo "La cantidad de parametros proporcionados no es correcta. Consulte el script con -help para mas informacion."
   exit
}
mensajeErrorArchivo () {
   echo "El archivo enviado no es valido"
   exit
}

mensajeErrorRutaDestino () {
   echo "La ruta destino $1 es una ruta invalida"
   exit
}

mensajeErrorRutaOrigen () {
   echo "La ruta origen $1 es una ruta invalida"
   exit
}
directorioOrigen=""
directorioDestino=""
archivoExcluido=""

while getopts ":d:e:o:" s; do
    case "${s}" in
        d)
            d=${OPTARG}
            if [ -d "$d" ]; then
                directorioOrigen="$d"
            else
                mensajeErrorRutaOrigen "$d"
            fi
            ;;
        e)
            e=${OPTARG}
            archivoExcluido=$e
            ;;
        o)
            o=${OPTARG}
            if [ -d "$o" ]; then
                directorioDestino="$o"
            else
                mensajeErrorRutaDestino "$o"
            fi
            ;;
        h | *)
            help
            ;;
    esac
done

if [[ $directorioOrigen == "" || $directorioDestino == "" ]]; then
    mensajeErrorCantParametros
fi
list=$(find "$directorioOrigen" -type f -name '*.csv')
arrIN=(${list//" "/ })

arrayArticulo=()
arrayCantidad=()

for arch in "${arrIN[@]}"; do
    if [ ! -s "$arch" ]; then
        echo "El archivo $arch esta vacio"
        continue;
    fi

    if [[ "${arch,,}" == *"${archivoExcluido,,}"* ]]; then 
        continue;
    fi

    while IFS=";" read -r rec_column1 rec_column2 
    do

        if [[ ! " ${arrayArticulo[*],,} " =~ " ${rec_column1,,} " ]]; then
            
            arrayArticulo+=($rec_column1)
            number=$(echo $rec_column2 | sed 's/[^0-9]*//g')
            arrayCantidad+=($number)
            
        else

            for i in "${!arrayArticulo[@]}"; do
                if [[ "${arrayArticulo[$i],,}" == "${rec_column1,,}" ]]; then
                    number=$(echo $rec_column2 | sed 's/[^0-9]*//g')
                    arrayCantidad[$i]=$((${arrayCantidad[$i]} + $number)) 
                fi
            done

        fi


    done < <(tail -n +2 $arch)

done

for s in "${arrayArticulo[@]}"; do
    echo $s
done

for s in "${arrayCantidad[@]}"; do
    echo $s
done

echo "trabajando en git"

