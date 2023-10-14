#!/bin/bash

date '+%b %e %H:%M' | awk '{
    if ($2 ~ /^1[0-9]$/) suffix="th";
    else if ($2 ~ /^1$/) suffix="st";
    else if ($2 ~ /^2$/) suffix="nd";
    else if ($2 ~ /^3$/) suffix="rd";
    else suffix="th";
    print $1 " " $2 suffix " " $3;
}'
