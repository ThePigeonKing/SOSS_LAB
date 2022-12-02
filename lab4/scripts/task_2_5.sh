#!/bin/bash

echo "*.txt files:";
ls "$HOME" | grep ".txt$";
echo;
echo "Total size in bytes:";

find "$HOME" -maxdepth 1 -type f -name "*.txt" -exec du -cb {} + | tail -1 | cut -f 1;
echo;
echo "Total number of lines:";
find "$HOME" -maxdepth 1 -type f -name "*.txt" -exec wc -l {} + | tail -1 | cut -f 3 -d" ";