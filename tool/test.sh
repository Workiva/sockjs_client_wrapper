#!/bin/bash

# Fast fail the script on failures.
set -e

DART_VERSION=$(dart --version 2>&1)
DART_2_PREFIX="Dart VM version: 2"

if [[ $DART_VERSION = $DART_2_PREFIX* ]]; then
    node tool/server.js &
    SOCKJS_SERVER=$!
    sleep 2

    echo -e 'pub run build_runner test --release -- -P travis'
    pub run build_runner test --release -- -P travis

    kill $SOCKJS_SERVER
    sleep 2
else
    echo -e 'pub run dart_dev test'
    pub run dart_dev test
fi
