#!/bin/bash

chmod +x ./system_monitoring.sh
./system_monitoring.sh

echo "Write data to a file?(y/n)"
read answer
if [[ "$answer" =~ [Yy] ]]; then
    ./system_monitoring.sh > "$(date +%d_%m_%y_%H_%M_%S).status"
    echo "File to create"
else
    echo "Bye, My Dear Friend"
fi