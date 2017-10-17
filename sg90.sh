#!/bin/sh

# Kill any existing instanes
sudo killall servod

# Start servod
# Use values closer to 544/2400 like Arduino
# https://www.arduino.cc/en/Reference/ServoAttach
sudo ./servod --min=550us --max=2400us --cycle-time=20000 --p1pins=7,11,12
