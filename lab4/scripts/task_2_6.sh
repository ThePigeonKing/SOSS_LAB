#!/bin/bash

md5sum *.txt | sort -k2 | rev | uniq -f1 -c | sort -n -r |  awk -d '{print $1 "\t" $2}';

