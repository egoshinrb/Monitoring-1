#!/bin/bash

if [[ $# -ne 4 ]]; then
    echo "Not all parameters are entered or superfluous"
else
    if [[ $1 -lt 1 || $1 -gt 6 || $2 -lt 1 || $2 -gt 6 || $3 -lt 1 || $3 -gt 6 || $4 -lt 1 || $4 -gt 6 ]]; then
        echo "The parameters are set incorrectly"
    elif [[ $1 -eq $2 || $3 -eq $4 ]]; then
            echo "Text and background colors of key or value cannot be the same"
    else
        back_colors=("\e[47m" "\e[41m" "\e[42m" "\e[44m" "\e[45m" "\e[40m")
        font_colors=("\e[37m" "\e[31m" "\e[32m" "\e[34m" "\e[35m" "\e[30m")
        default_color='\033[0m'

        key_color=${back_colors[$1 - 1]}${font_colors[$2 - 1]}
        value_color=${back_colors[$3 - 1]}${font_colors[$4 - 1]}
       
        chmod +x ../02/system_monitoring.sh

        IFS=$'\n'
        for line in $(../02/system_monitoring.sh); do
            key=$(echo $line | awk -F= '{print $1}')
            value=$(echo $line | awk -F= '{print $2}')
            echo -e "${key_color}${key}${default_color}=${value_color}${value}${default_color}"
        done
    fi
fi