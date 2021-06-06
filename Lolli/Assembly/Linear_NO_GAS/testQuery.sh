#!/bin/bash

for mut in {0..7}
do
    echo Mutazione $mut
    for query in {0..4}
    do
        echo Test query $query
        for gas in {20..40..20}
        do
            echo Benzina $gas
            ./executeQuery.pro $mut $query 3 0 $gas
            ./executeQuery.pro $mut $query 6 1 $gas
        done
    done
done