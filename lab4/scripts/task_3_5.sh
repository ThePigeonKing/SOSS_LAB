#!/bin/bash

grep "$2" "$1" -m "$3" | sort | nl;