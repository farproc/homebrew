#!/bin/bash

# assume we've got wget?

cd Library/
mkdir Mirror
cd Mirror
grep url\ \' ../Formula/*.rb | sed "s/^.*url\ \'//g" | sed "s/\'.*$//g" | sort | uniq > url_list
# start with the HTTP
for url in `cat url_list | grep ^http`
do
        wget --timestamping --force-directories $url
done
