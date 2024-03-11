#!/bin/bash

# Start Xvfb
XVFB_RESOLUTION="1024x768x24"
XVFB_DISPLAY_0=":0"
XVFB_DISPLAY_1=":1"

start_xvfb() {
    Xvfb $1 -screen 0 $XVFB_RESOLUTION &
    export DISPLAY=$1
}

start_xvfb $XVFB_DISPLAY_0
start_xvfb $XVFB_DISPLAY_1

# Start x11vnc
x11vnc -display $XVFB_DISPLAY_1 -bg -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever &

# Start Android emulator
/android-sdk/emulator/emulator -avd test -no-window -gpu off &

# Wait for boot completion
wait_for_boot() {
    adb wait-for-device
    adb wait-for-boot-complete
}
wait_for_boot

# Start socat
socat TCP-LISTEN:5900,fork TCP:localhost:5901 &

# Start fluxbox
fluxbox &

# Keep the container running
exec /bin/bash