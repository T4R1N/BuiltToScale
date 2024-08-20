#!/bin/sh
echo -ne '\033c\033]0;Designed To Climb\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Designed_To_Climb_Linux.x86_64" "$@"
