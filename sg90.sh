#!/bin/sh
# Copyright 2017 Don Willingham
# See LICENSE for 3 clause BSD license

# Kill any existing instances
sudo killall servod

# Start servod
# Use values closer to 544/2400 like Arduino
# https://www.arduino.cc/en/Reference/ServoAttach
sudo ./servod --min=550us --max=2400us --cycle-time=20000 --p1pins=7,11,12
