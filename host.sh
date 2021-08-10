#!/bin/bash

##   Host 	    : 	Expose your Localhost :) Temporary File hosting using Ngrok
##   Author 	: 	TaNviiR-RiiYaD
##   Version 	: 	2.0.2
##   Github 	: 	https://github.com/TaNviiR-RiiYaD


# Deafult Port
def_port='8080'

# Color Codes
CR=$'\e[1;31m' CG=$'\e[1;32m' CY=$'\e[1;33m' CB=$'\e[1;34m' CC=$'\e[1;36m' CW=$'\e[1;37m' RS=$'\e[1;0m'

architecture=`uname -m`

# Terminate Program
terminated() {
    printf "\n\n${RS} ${CR}[${CW}!${CR}]${CY} Program Interrupted ${CR}[${CW}!${CR}]${RS}\n"
    exit 1
}

trap terminated SIGTERM
trap terminated SIGINT

kill_pid() {
	if [[ `pidof php` ]]; then
		killall php > /dev/null 2>&1
	fi
	if [[ `pidof ngrok` ]]; then
		killall ngrok > /dev/null 2>&1
	fi	
}


# Host Banner
logo(){

clear
echo "${CY}     _    _           _   
${CY}    | |  | |  ${CC}V${CB}-${CG}2.1${CY}  | |  
${CG}    | |__| | ___  ___| |_ 
${CG}    |  __  |/ _ \/ __| __|
${CY}    | |  | | (_) \__ \ |_ 
${CY}    |_|  |_|\___/|___/\__|
${RS}
${CR} [${CW}~${CR}]${CY} Created By  ${CG}(${CC}TaNviiR-RiiYaD${CG})${RS}"

}

path(){

    printf "\n${RS} ${CR}[${CW}1${CR}]${CY} Use Current Path [host/htdocs]"
    printf "\n${RS} ${CR}[${CW}2${CR}]${CY} Setup a Path"
    printf "\n${RS}"
    printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Select A Hosting option: ${CC}"
    read red_path
    
    if [[ $red_path == 1 || $red_path == 01 ]]; then
        path=$'./htdocs'
    elif [[ $red_path == 2 || $red_path == 02 ]]; then
        printf "\n${RS} ${CC}Enter File Path [Example : /home/tahmid/htdocs]"
        printf "\n${RS}"
        printf "\n${RS} ${CR}>>${CG} ${CC}"
        read path
    else
        printf "\n${RS} ${CR}[${CW}!${CR}]${CY} Invalid option ${CR}[${CW}!${CR}]${RS}\n"
        sleep 2 ; logo ; path
    fi

    if [[ ! -d "$path" ]]; then
	    mkdir -p "$path"
    fi
    
    menu

}

package(){

	printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Setting up Environment..${RS}"

    if [[ -d "/data/data/com.termux/files/home" ]]; then
        if [[ `command -v proot` ]]; then
            printf ''
        else
			printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Installing ${CY}Proot${RS}\n"
            pkg install proot resolv-conf -y
        fi
    fi

    if [[ `command -v curl` && `command -v php` && `command -v wget` && `command -v unzip` ]]; then
        printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Environment Setup Completed !${RS}"
    else
        repr=(curl php wget unzip)
        for i in "${repr[@]}"; do
            type -p "$i" &>/dev/null || 
                { 
                    printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Installing ${CY}${i}${RS}\n"
                    
                    if [[ `command -v apt` ]]; then
                        apt install "$i" -y
                    elif [[ `command -v apt-get` ]]; then
                        apt-get install "$i" -y
                    elif [[ `command -v pkg` ]]; then
                        pkg install "$i" -y
                    elif [[ `command -v dnf` ]]; then
                        sudo dnf -y install "$i"
                    else
                        printf "\n${RS} ${CR}[${CW}!${CR}]${CY} Unfamiliar Distro ${CR}[${CW}!${CR}]${RS}\n"
                        exit 1
                    fi
                }
        done
    fi

}

localhost() {

    printf "\n${RS} ${CR}[${CW}-${CR}]${CY} Input Port [default:${def_port}]: ${CC}"
    read port
    port="${port:-${def_port}}"
    printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Starting PHP Server on Port ${CY}${port}${RS}\n"
    cd "$path" && php -S 127.0.0.1:"$port" > /dev/null 2>&1 &
    sleep 2
    printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Successfully Hosted at : ${CY}http://127.0.0.1:$port ${RS}"
    printf "\n\n ${CR}[${CW}-${CR}]${CC} Press Ctrl + C to exit.${RS}\n"
    while [ true ]; do
        sleep 0.75
    done

}

install_ngrok() {
	
    if [[ -e "ngrok" ]]; then
		printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Ngrok already installed.${RS}"
	else
		printf "\n${RS} ${CR}[${CW}-${CR}]${CC} Installing ngrok...${RS}"
		
		if [[ ("$architecture" == *'arm'*) || ("$architecture" == *'Android'*) ]]; then
			ngrok_file='https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip'
		elif [[ "$architecture" == *'aarch64'* ]]; then
			ngrok_file='https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip'
		elif [[ "$architecture" == *'x86_64'* ]]; then
			ngrok_file='https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'
		else
			ngrok_file='https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip'
		fi

        wget "$ngrok_file" --no-check-certificate > /dev/null 2>&1
        ngrok_deb=`basename $ngrok_file`
    
    	if [[ -e "$ngrok_deb" ]]; then
		    unzip "$ngrok_deb" > /dev/null 2>&1
		    rm -rf "$ngrok_deb" > /dev/null 2>&1
		    chmod +x ./ngrok > /dev/null 2>&1
        else
            echo -e "\n${RS} ${CR}[${CW}!${CR}]${CY} Error occured, Install Ngrok manually.${RS}"
            exit 1
        fi
    fi

}

ngrok() {

    printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Starting PHP Server on Port ${CY}${def_port}${RS}\n"
    cd "$path" && php -S 127.0.0.1:"$def_port" > /dev/null 2>&1 &
    sleep 1
    printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Launching Ngrok on Port ${CY}${def_port}${RS}"

    if [[ `command -v termux-chroot` ]]; then
        sleep 2 && termux-chroot ./ngrok http 127.0.0.1:"$def_port" > /dev/null 2>&1 &
    else
        sleep 2 && ./ngrok http 127.0.0.1:"$def_port" > /dev/null 2>&1 &
    fi

    sleep 8
    ngrok_url=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    printf "\n\n${RS} ${CR}[${CW}-${CR}]${CG} Successfully Hosted at : ${CY}${ngrok_url}${RS}"
    printf "\n\n ${CR}[${CW}-${CR}]${CC} Press Ctrl + C to exit.${RS}\n"
    while [ true ]; do
        sleep 0.75
    done

}

menu() {
		
    echo -e "\n${CR} [${CW}01${CR}]${CG} Localhost ${CR}[${CC}For Devs${CR}]"
	echo -e "${CR} [${CW}02${CR}]${CG} Ngrok.io  ${CR}[${CC}Best${CR}]"

	printf "\n${RS} ${CR}[${CW}-${CR}]${CG} Select an Option: ${CB}"
    read MEW
    
    if [[ "$MEW" == 1 || "$MEW" == 01 ]]; then
		localhost
	elif [[ "$MEW" == 2 || "$MEW" == 02 ]]; then
        ngrok
	else
		printf "\n${RS} ${CR}[${CW}!${CR}]${CY} Invalid option ${CR}[${CW}!${CR}]${RS}\n"
		sleep 2 ; logo ; path
	fi

}


kill_pid ; package ; install_ngrok ; logo ; path


