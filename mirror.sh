#!/bin/bash

# assume we've got wget?

cd Library/Formula
mkdir mirror
cd mirror
for url in `grep url\ \' ../* | sed "s/^.*url\ \'//g" | sed "s/\'.*$//g" | sort | uniq`
do
        wget -m $url
done
