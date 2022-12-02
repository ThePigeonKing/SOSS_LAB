#!/bin/bash

date >> /tmp/run.log;
echo "Hello, World!";
wc -l /tmp/run.log | cut -f1 -d" " >&2;