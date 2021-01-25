#!/bin/bash

# zipfile from swaggerhub. expected to be in this directory
ZIPFILE=go-client-generated.zip

# directory for temporily unzipping file. this will be deleted once package is renamed
TEMPDIR=swagger

# final resting place of client
CLIENTDIR=client

# go module identifier
MODULE=github.com/wfscot/go-strava-v3

# make sure we have unzip tool
if ! which unzip > /dev/null; then
    echo could not find unzip tool. aborting.
    exit 1
fi

# make sure we have go installed
if ! which go > /dev/null; then
    echo could not find go. aborting.
    exit 1
fi

# look for zip
if [ ! -r "$ZIPFILE" ]; then
    echo could not find $ZIPFILE. aborting.
    exit 1
fi

# if tempdir exists, blow it away
if [ -e "$TEMPDIR" ]; then
    echo $TEMPDIR exists. deleting...
    if ! rm -rf "$TEMPDIR" > /dev/null; then
        echo temp directory $TEMPDIR exists and cannot be removed. aborting.
        exit 1
    fi
fi

# unzip to tempdir
echo unzipping $ZIPFILE into $TEMPDIR...
if ! unzip -d "$TEMPDIR" "$ZIPFILE"; then
    echo error unzipping into $TEMPDIR. aborting.
    exit 1
fi

# if clientdir exists, blow it away
if [ -e "$CLIENTDIR" ]; then
    echo $CLIENTDIR exists. deleting...
    if ! rm -rf "$CLIENTDIR" > /dev/null; then
        echo temp directory $CLIENTDIR exists and cannot be removed. aborting.
        exit 1
    fi
fi

# copy all files to clientdir. the go files will be overwritten, but this ensures we get everything.
echo initializing "$CLIENTDIR"...
if ! cp -r "$TEMPDIR" "$CLIENTDIR"; then
    echo error copying $TEMPDIR to $CLIENTDIR. aborting.
    exit 1
fi

# change package of all go files from swagger to client
echo changing package from swagger to client...
for tempfile in "$TEMPDIR"/*.go; do
    # it wouldn't hurt to add some error checking here, but it's so simple...
    clientfile=${tempfile/$TEMPDIR/$CLIENTDIR}
    echo $clientfile
    sed -e 's/^package swagger/package client/' < $tempfile > $clientfile
done

# delete tempdir
echo deleting temporary $TEMPDIR directory...
if ! rm -rf "$TEMPDIR"; then
    echo error deleting $TEMPDIR. aborting.
    exit 1 
fi

# initialize go module. build to download dependencies and update go.mod
# error checking would be nice...
echo initializing go module $MODULE...
cd $CLIENTDIR
go mod init $MODULE
go build

echo done.