#!/bin/bash

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
done
# default to HTTP if no protocol
for url in `cat url_list | grep -v ://`
do
    echo "Downloading ${url}"
    wget --timestamping --force-directories $url > /dev/null
done

# FTP
for url in `cat url_list | grep ^ftp`
do
    echo "Downloading ${url}"
    wget --timestamping --force-directories $url > /dev/null
done

# git
for url in `cat url_list | grep ^git`
do
    echo "Cloning ${url}"
    # assume every repo has a different name :\  *eek*
    git clone --bare ${url} > /dev/null
done

# svn (who's still using that!)
for url in `cat url_list |grep ^svn.http`
do
    echo "Checking out $url"
    dest=`echo http://closure-compiler.googlecode.com/svn/trunk/ | sed 's/^http:\/\///g' | sed 's/\/.*$//g'`
    # same as git - we're assuming the repo name is uniq
    url=`echo ${url} | sed 's/^svn.//g'`
    svn co ${url} ${dest} > /dev/null
done

