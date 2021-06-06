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

while true
do
    echo "Numero di test"
    read numTest
    if [ $numTest -ge 0 ]; then
        break
    fi
done 

echo
echo

./query.pro $ver $numTest 0 $dim
echo
./query.pro $ver $numTest 1 $dim
echo
./query.pro $ver $numTest 2 $dim
echo
./query.pro $ver $numTest 3 $dim
echo
./query.pro $ver $numTest 4 $dim
echo
./query.pro $ver $numTest 5 $dim
echo

if [ $ver -eq 0 ] || [ $ver -eq 2 ]; then
    ./query.pro $ver $numTest 6 $dim
    echo
fi

./query.pro $ver $numTest 7 $dim
echo
./query.pro $ver $numTest 8 $dim
echo
./query.pro $ver $numTest 9 $dim
echo
./query.pro $ver $numTest 10 $dim
echo
./query.pro $ver $numTest 11 $dim
echo
./query.pro $ver $numTest 12 $dim
