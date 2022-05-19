#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/nord

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	# printf "^c$green^  "
	# printf "^c$white^ ^b$black^$cpu_val"

  printf "^c$black^ ^b$green^ CPU"
	printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
    updates=$(checkupdates | wc -l)

	if [ "$updates" -eq "0" ]; then
		printf "^c$green^  Fully Updated"
    elif [ "$updates" -eq "1" ]; then
		printf "^c$green^  $updates"" update"
	else
		printf "^c$green^  $updates"" updates"
	fi
}

battery() {
	get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
    status="$(cat /sys/class/power_supply/BAT1/status)"

	if [ "$status" = "Charging" ] || [ "$status" = "Full" ] || [ "$status" = "Unknown" ]; then
	    printf "^c$blue^   $get_capacity"
	else
        if [ "$get_capacity" -ge "90" ]; then
            printf "^c$blue^    $get_capacity"
        elif [ "$get_capacity" -ge "70" ]; then
            printf "^c$blue^    $get_capacity"
        elif [ "$get_capacity" -ge "50" ]; then
            printf "^c$blue^    $get_capacity"
        elif [ "$get_capacity" -ge "25" ]; then
            printf "^c$blue^    $get_capacity"
        elif [ "$get_capacity" -ge "10" ]; then
            printf "^c$blue^    $get_capacity"
        else
            printf "^c$blue^    $get_capacity"
        fi
	fi
}

brightness() {
	printf "^c$red^   "
	printf "^c$red^%.0f\n" $(xbacklight -get)
}

mem() {
	printf "^c$blue^^b$black^   "
	printf "^c$darkblue^$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

clock() {
	# printf "^c$white^ 󱑆 "
	printf "^c$black^^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%a %b %d %I:%M:%S %p')"
	#printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

vol() {
	volume="$(pamixer --get-volume)"
  ismute="$(pamixer --get-mute)"

  if [ "$ismute" = true ]; then
    printf "^c$green^ 婢 " 
  else
    if [ "$volume" -ge "50" ]; then
      printf "^c$green^   $volume"
    else
      printf "^c$green^ 奄 $volume"
    fi
  fi
}


#clock() {
#	printf "^c$black^ ^b$darkblue^ 󱑆 "
#	printf "^c$black^^b$blue^ $(date '+%I:%M %p')  "
#}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates  $(battery)  $(brightness) $(cpu)  $(mem)  $(clock)  "
done
