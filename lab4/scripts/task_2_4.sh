#!/bin/bash

while read -r line;
do
    if [[ "$line" =~ .*"bin".* ]];
    then
        echo "$line" >&2;
    fi
done