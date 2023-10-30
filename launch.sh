#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
# echo "---" | tee -a /tmp/polybar.log
# polybar example 2>&1 | tee -a /tmp/polybar.log & disown

(
  flock 200

  killall -q polybar

  while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

  outputs=$(polybar --list-monitors | cut -d":" -f1)
  tray_output=eDP1

  for m in $outputs; do
    if [[ $m == "HDMI-1" ]]; then
        tray_output=$m
    fi
  done

  for m in $outputs; do
    export MONITOR=$m
    export TRAY_POSITION=none
    if [[ $m == $tray_output ]]; then
      TRAY_POSITION=right
    fi

    polybar --reload example &
    disown
  done
) 200>/var/tmp/polybar-launch.lock

echo "Bars launched..."
