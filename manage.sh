#!/bin/sh
#######################################
# Authors:
#   Oumar Kone
#   Josh Santos <josh@nerdsville.net>
#######################################
# Initial Source: https://unix.stackexchange.com/questions/4489/a-tool-for-automatically-applying-randr-configuration-when-external-display-is-p
# Because good artists create, but great ones steal! :-)
#######################################

function Activate {
    # Need to manage config using yaml for monitor configuration and use this w/ activate
    # This will allow us to further improve the activate function
    local monitor width height res
    monitor=$1
    width=$2
    height=$3
    res="$(printf "%sx%s" "$width" "$height")"
    echo "Switching on $monitor"
    xrandr --output $monitor --mode $res --pos 0x0 --output eDP-1-1 --primary --mode 1920x1080 --pos "$width"x0 --rotate normal 
}

function Deactivate {
    local monitor
    monitor=$1
    echo "Switching off $monitor"
    xrandr --output $monitor --off --auto
}

function Active {
    local monitor
    monitor=$1
    xrandr --listactivemonitors | grep -q "$monitor"
}

function Connected {
    local monitor
    monitor=$1
    ! xrandr | egrep "^$monitor\s.*" | grep -nq disconnected
}

while true
do
  if ! Active "DP\-0" && Connected "DP-0"
  then
      Activate "DP-0" "3440" "1440"
  elif Active "DP\-0" && ! Connected "DP-0"
  then
      Deactivate "DP-0"
  fi
  sleep 1s
done
#xrand --output eDP-1-1 --primary --mode 1920x1080 --rotate normal --output DP-0 --mode 3440x1440 --pos 0x0 --rotate normal
#xrandr --output HDMI-1-1 --off --output eDP-1-1 --primary --mode 1920x1080 --pos 3440x0 --rotate normal --output DP-1 --off --output HDMI-0 --off --output DP-1-1 --off --output DP-0 --mode 3440x1440 --pos 0x0 --rotate normal
