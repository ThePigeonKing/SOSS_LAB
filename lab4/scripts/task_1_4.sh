#!/bin/bash

echo "Good morning, $(whoami)!"
date | awk '{print $4, $5, $6}';
echo;
cal;
cat "$HOME"/TODO;