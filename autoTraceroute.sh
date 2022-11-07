#!/bin/sh

# let "a = $(traceroute youtube.com)"
# echo "$a"

if test -d "data"
    then echo "Data directory already exists"
else 
    echo "Creating data directory"
    mkdir data
fi

traceroute $2 > data/$1.txt