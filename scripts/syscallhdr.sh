#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

in="$1"
out="$2"
my_abis=$(echo "($3)" | tr ',' '|')
prefix="$4"
offset="$5"
fg_arch="$6"

fg_val=''
sep='	'		# a TAB
if [ "$fg_arch" = 'arm' ]; then
	fg_val=' 1'
	sep=' '		# a SPACE
fi

fileguard=$(printf '_UAPI_ASM_%s_%s' "$fg_arch" "$(basename "$out")" |
	tr '[:lower:]' '[:upper:]' | tr -c -s '[:alnum:]_' '[_*]')

grep -E "^[[:xdigit:]Xx]+[[:space:]]+$my_abis" "$in" | sort -n | {
	printf '#ifndef %s\n' "$fileguard"
	printf '#define %s%s\n\n' "$fileguard" "$fg_val"

	nxt=0
	while read -r nr _ name _ _ ; do
		if [ -n "$offset" ]; then
			value="($offset + $nr)"
		else
			value="$nr"
		fi
		printf '#define __NR_%s%s%s%s\n' \
			"$prefix" "$name" "$sep" "$value"
		nxt=$(( nr + 1 ))
	done

	if [ "$fg_arch" != 'arm' ]; then
		printf '\n#ifdef __KERNEL__\n'
		printf '#define __NR_syscalls%s%s\n' "$sep" "$nxt"
		printf '#endif\n'
	fi
	printf '\n#endif /* %s */\n' "$fileguard"
} > "$out"
