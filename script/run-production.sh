#!/bin/bash

set -e
cd "$(dirname "$0")/.."

source "/home/matteo/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export LANG=en_US.UTF-8

exec puma config.ru -b tcp://127.0.0.1:4002  -e production --pidfile tmp/production.pid -C config.puma.rb
