#!/bin/bash

START_TIME=$(date +%s)

if [[ $# -ne 1 ]]; then
    echo "Parameter not entered"
elif [[ !(-d $1) ]]; then
    echo "No such directory"
else
    dir=$1

    folders_count=$(($(sudo find ${dir} -type d | wc -l) - 1))
    echo "Total number of folders (including all nested ones) = ${folders_count}"

    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    if [[ $folders_count -eq 0 ]]; then
        echo "Folders are missing"
    fi

    i=0
    IFS=$'\n'
    for line in $(sudo du $dir | sort -nr); do
        if [[ $i -eq 0 ]]; then
            i=$(($i + 1))
            continue
        fi
        
        echo -n "${i} - $(echo $line | awk '{print $2 ", " }')"
        echo "$(echo $line | awk '{if ($1 > 999999) {printf "%d GB", $1/1000000} else if ($1 > 999) {printf "%d MB", $1/1000} else {print $1 " KB"}}')"
        
        
        if [[ $i -eq 5 || ($i -lt 5 && $folders_count -le 1) ]]; then
            if [[ $folders_count -le 1 ]]; then
                echo "There are no more folders"
            fi
            break
        fi
        i=$(($i + 1))
        folders_count=$(($folders_count - 1))
    done

    files_count=$(sudo ls -laR ${dir} | grep -cE "^-")
    echo "Total number of files = ${files_count}"

    echo "Number of:"
    echo "Configuration files (with the .conf extension) = $(sudo ls -laR ${dir} | grep -cE "^-.*.conf$")"
    
    echo "Text files = $(sudo ls -laR ${dir} | grep -ciE "^-.*.(txt|pdf|doc|docx)$")"

    files_exec_count=$(sudo find ${dir} -type f -perm /a=x | wc -l)
    echo "Executable files = ${files_exec_count}"
    # еще можно исполняемые файлы искать через sudo ls -laR ${dir} | grep -cE "^-.*[r-][w-]x"
    
    echo "Log files (with the extension .log) = $(sudo ls -laR ${dir} | grep -cE "^-.*.log$")"
    
    echo "Archive files = $(sudo ls -laR ${dir} | grep -ciE "^-.*.(gz|tar|shar|a|zip|7z|rar)$")"

    echo "Symbolic links = $(sudo find ${dir} -type l | wc -l)"

    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    if [[ $files_count -eq 0 ]]; then
        echo "Files are missing"
    fi

    i=1
    for line in $(sudo find ${dir} -type f -ls | sort -nrk7); do
        echo "${i} - $(echo ${line} | awk '{if ($7 > 999999999) {printf "%s, %d GB,", $11, $7/1000000000}
        else if ($7 > 999999) {printf "%s, %d MB,", $11, $7/1000000} else if ($7 > 999) {printf "%s, %d KB,", $11, $7/1000}
        else {printf "%s, %d B,", $11, $7}}') $(echo ${line} | awk -F. '{print $2}')"
        
        if [[ $i -eq 10 || ($i -lt 10 && $files_count -le 1) ]]; then
            if [[ $files_count -le 1 ]]; then
                echo "There are no more files"
            fi
            break;
        fi
        i=$(($i + 1))
        files_count=$(($files_count - 1))
    done

    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
    if [[ $files_exec_count -eq 0 ]]; then
        echo "Files are missing"
    fi

    i=1
    for line in $(sudo find ${dir} -type f -perm /a=x -ls | sort -nrk7); do
        echo "${i} - $(echo ${line} | awk '{if ($7 > 999999999) {printf "%s, %d GB,", $11, $7/1000000000}
        else if ($7 > 999999) {printf "%s, %d MB,", $11, $7/1000000} else if ($7 > 999) {printf "%s, %d KB,", $11, $7/1000}
        else {printf "%s, %d B,", $11, $7}}') $(echo ${line} | awk '{print $11}' | md5sum | awk '{print $1}')"
        
        if [[ $i -eq 10 || ($i -lt 10 && $files_exec_count -le 1) ]]; then
            if [[ $files_exec_count -le 1 ]]; then
                echo "There are no more files"
            fi
            break;
        fi
        i=$(($i + 1))
        files_exec_count=$(($files_exec_count - 1))
    done

    echo "Script execution time (in seconds) = $(($(date +%s) - START_TIME))"
fi