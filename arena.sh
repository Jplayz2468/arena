#!/bin/sh
echo -ne '\033c\033]0;arena\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/arena.x86_64" "$@"
