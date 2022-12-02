#!/bin/bash

userlen=$(echo -n "$USER" | wc -c);
homelen=$(echo -n "$HOME" | wc -c);

totallen=$((userlen+homelen));

echo "$USER $HOME $totallen";