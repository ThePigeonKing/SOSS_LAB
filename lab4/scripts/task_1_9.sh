#!/bin/bash

ps aux --sort -%mem | head -6 | awk '{print $2,$11}'
