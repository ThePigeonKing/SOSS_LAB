#!/bin/bash

home=$(whoami)
grep "000000" "$home/bash.txt" > /tmp/zeros
grep -v "000000" "$home/bash.txt" > /tmp/nozeros
head -n 10 /tmp/zeros && tail -n 10 /tmp/zeros;
echo;
head -n 10 /tmp/nozeros && tail -n 10 /tmp/nozeros;