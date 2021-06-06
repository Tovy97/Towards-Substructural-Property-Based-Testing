#!/bin/bash

for mut in {0..15}
do
    echo Mutazione $mut
    for query in {0..13}
    do
        echo Test query $query
        for gas in {10..70..60}
        do
            echo Benzina $gas
            ./executeQuery.pro $mut $query 3 0 $gas
            ./executeQuery.pro $mut $query 6 1 $gas
        done
    done
done