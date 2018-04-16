#!/bin/bash

# Fast fail the script on failures.
set -e

# Check arguments.
TASK=$1

if [ -z "$TASK" ]; then
  echo -e '\033[31mTASK argument must be set!\033[0m'
  echo -e '\033[31mExample: tool/travis.sh test\033[0m'
  exit 1
fi

# Run the correct task type.
case $TASK in
  test)
    echo -e '\033[1mTASK: Testing [test]\033[22m'

    pub serve test --web-compiler=dartdevc --port=8081 &
    PUB_SERVER=$!

    node tool/server.js &
    SOCKJS_SERVER=$!

    sleep 2

    echo -e 'pub run test -P travis'
    pub run test -P travis

    kill $PUB_SERVER
    kill $SOCKJS_SERVER
    sleep 2

    ;;

  *)
    echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
    exit 1
    ;;
esac
