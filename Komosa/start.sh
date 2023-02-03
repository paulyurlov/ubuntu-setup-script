#!/bin/bash

killall conky
sleep 2s

conky -c $HOME/.config/conky/Komosa/Komosa.conf &> /dev/null &

exit
