#!/bin/bash

while true
do
    echo "Version di perm: "
    read ver
    if [ $ver -eq 0 ] || [ $ver -eq 1 ] || [ $ver -eq 2 ]; then
        break
    fi
done 

while true
do
    echo "Dimensione input"
    read dim
    if [ $dim -ge 0 ]; then
        break
    fi
done 

echo
echo

./query.pro $ver 0 $dim
echo
./query.pro $ver 1 $dim
echo
./query.pro $ver 2 $dim
echo
./query.pro $ver 3 $dim
echo
./query.pro $ver 4 $dim
echo
./query.pro $ver 5 $dim
echo

if [ $ver -eq 0 ] || [ $ver -eq 2 ]; then
    ./query.pro $ver 6 $dim
    echo
fi

./query.pro $ver 7 $dim
echo
./query.pro $ver 8 $dim
echo
./query.pro $ver 9 $dim
echo
./query.pro $ver 10 $dim
echo
./query.pro $ver 11 $dim
echo
./query.pro $ver 12 $dim
