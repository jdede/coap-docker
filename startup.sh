#!/bin/bash

export DISPLAY=:99
# Start daemons for X11 access
Xvfb :99 -shmem -screen 0 1024x768x16 1>/var/log/xvfb.log 2>/var/log/xvfb.err &
x11vnc -passwd secret -display :99 -N -forever 1> /var/log/x11vnc.log 2>/var/log/x11vnc.err &

echo "Welcome!"
/bin/bash
