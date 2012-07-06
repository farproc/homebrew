#!/bin/bash

function fixUpFormula {
    url=$1
    newurl=$2
    # find all the formulas that have this url
    for f in `grep ${url} ../Formula/*.rb | cut -d':' -f1`
    do
        echo "Fixing up ${f}"
        sed "s*${url}*${newurl}*g" ${f} > ${f}
    done
}

# assume we've got wget?
# if not brew install wget

# we must already have git for brew to work

# svn is another one which we'd require

cd Library/
mkdir Mirror
cd Mirror

# build url list
grep "^[[:space:]]*url '" ../Formula/*.rb | sed "s/^.*url\ \'//g" | sed "s/\'.*$//g" | sort | uniq > url_list

# start with the HTTP
for url in `cat url_list | grep ^http`
do
    echo "Downloading ${url}"
    wget --timestamping --force-directories $url > /dev/null
    newurl=`echo -n "${PWD}/" && ( echo ${url} | sed 's/^.*\:\/\///g' )`
    fixUpFormula $url $newurl
done
# default to HTTP if no protocol
for url in `cat url_list | grep -v ://`
do
    echo "Downloading ${url}"
    wget --timestamping --force-directories $url > /dev/null
    newurl=`echo -n "${PWD}/" && ( echo ${url} | sed 's/^.*\:\/\///g' )`
    fixUpFormula $url $newurl
done

# FTP
for url in `cat url_list | grep ^ftp`
do
    echo "Downloading ${url}"
    wget --timestamping --force-directories $url > /dev/null
    newurl=`echo -n "${PWD}/" && ( echo ${url} | sed 's/^.*\:\/\///g' )`
    fixUpFormula $url $newurl
done

# git
for url in `cat url_list | grep ^git`
do
    echo "Cloning ${url}"
    # assume every repo has a different name :\  *eek*
    git clone --bare ${url} > /dev/null

    fixUpFormula $url $newurl
done

# svn (who's still using that!)
for url in `cat url_list |grep ^svn.http`
do
    echo "Checking out $url"
    $origurl=$url
    url=`echo ${url} | sed 's/^svn.//g'`
    dest=`echo ${url} | sed 's/^http:\/\///g' | sed 's/\/.*$//g'`
    dest=`echo "${PWD}/${dest}"`
    svn co ${url} ${dest} > /dev/null
    fixUpFormula $origurl $dest
done

