#!/bin/bash

# Fast fail the script on failures.
set -e

node tool/server.js &
SOCKJS_SERVER=$!
sleep 2

echo -e 'pub run build_runner test --release -- -P travis'
pub run dart_dev test -- -P travis

kill $SOCKJS_SERVER
sleep 2
