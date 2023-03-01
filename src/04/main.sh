#!/bin/bash

default_back_color=7  # == 1 white
default_font_color=8  # == 1 red

key_back_color=$(cat ./colors.conf | awk -F= '/column1_background/{print $2}')
key_font_color=$(cat ./colors.conf | awk -F= '/column1_font_color/{print $2}')
value_back_color=$(cat ./colors.conf | awk -F= '/column2_background/{print $2}')
value_font_color=$(cat ./colors.conf | awk -F= '/column2_font_color/{print $2}')

# проверка если цвета не заданы, заданы неправильные или одинаковые значения
# (с учетом того, чтобы дефолтный цвет не совпал со следующим)
if [[ $key_back_color -lt 1 || $key_back_color -gt 6 ||
($key_back_color -eq $key_font_color && $key_back_color -ne 1) ]]; then
    key_back_color=$default_back_color
fi

if [[ $key_font_color -lt 1 || $key_font_color -gt 6 ||
$key_back_color -eq $key_font_color ]]; then
    key_font_color=$default_font_color
fi

if [[ $value_back_color -lt 1 || $value_back_color -gt 6 ||
($value_back_color -eq $value_font_color && $value_back_color -ne 1) ]]; then
    value_back_color=$default_back_color
fi

if [[ $value_font_color -lt 1 || $value_font_color -gt 6 ||
$value_back_color -eq $value_font_color ]]; then
    value_font_color=$default_font_color
fi

# проверка если цвета все-таки совпали с дефолтными
if [[ $key_back_color%6 -eq $key_font_color%6 ]]; then
    if [[ $key_back_color -eq $(default_back_color) ]]; then
        key_font_color=$default_font_color
    else
        key_back_color=$default_back_color
    fi
fi

if [[ $value_back_color%6 -eq $value_font_color%6 ]]; then
    if [[ $value_back_color -eq $(default_back_color) ]]; then
        value_font_color=$default_font_color
    else
        value_back_color=$default_back_color
    fi
fi

# пропишем возможные цвета
colors=("white" "red" "green" "blue" "purple" "black")
back_colors=("\e[47m" "\e[41m" "\e[42m" "\e[44m" "\e[45m" "\e[40m")
font_colors=("\e[37m" "\e[31m" "\e[32m" "\e[34m" "\e[35m" "\e[30m")
default_color='\033[0m'

# цвета из файла с настройками
key_color=${back_colors[$key_back_color%6 - 1]}${font_colors[$key_font_color%6 - 1]}
value_color=${back_colors[$value_back_color%6 - 1]}${font_colors[$value_font_color%6 - 1]}

# обрабатываем вывод
chmod +x ../02/system_monitoring.sh
IFS=$'\n'
for line in $(../02/system_monitoring.sh); do
    key=$(echo $line | awk -F= '{print $1}')
    value=$(echo $line | awk -F= '{print $2}')
    echo -e "${key_color}${key}${default_color}=${value_color}${value}${default_color}"
done

# обрабатываем финальную часть вывода
colors_config=($key_back_color $key_font_color $value_back_color $value_font_color)
for i in {0..3}; do
    if [[ ${colors_config[$i]} -gt 6 ]]; then
        colors_config[$i]="default"
    fi
done

echo
echo "Column 1 background = ${colors_config[0]} (${colors[$key_back_color%6 - 1]})"
echo "Column 1 font color = ${colors_config[1]} (${colors[$key_font_color%6 - 1]})"
echo "Column 2 background = ${colors_config[2]} (${colors[$value_back_color%6 - 1]})"
echo "Column 2 font color = ${colors_config[3]} (${colors[$value_font_color%6 - 1]})"