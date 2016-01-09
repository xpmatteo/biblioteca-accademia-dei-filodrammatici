#!/bin/bash

ssh matteo@www-mv tail -f '/var/log/apache2/*.log' 'filo-sinatra/log/*.log'
