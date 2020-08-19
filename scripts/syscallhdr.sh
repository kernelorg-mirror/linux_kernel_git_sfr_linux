#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

in="$1"
out="$2"
my_abis=$(echo "($3)" | tr ',' '|')
prefix="$4"
offset="$5"
fg_arch="$6"

fg_val=''
fg_prefix='_UAPI'
if [ "$fg_arch" = 'arm' ] || [ "$fg_arch" = 'x86' ]; then
	fg_val=' 1'
fi
if [ "$fg_arch" = 'x86' ]; then
	fg_prefix=''
fi

fileguard=$(printf '%s_ASM_%s_%s' "$fg_prefix" "$fg_arch" "$(basename "$out")" |
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
		printf '#define __NR_%s%s\t%s\n' "$prefix" "$name" "$value"
		nxt=$(( nr + 1 ))
	done

	if [ "$fg_arch" != 'arm' ]; then
		printf '\n#ifdef __KERNEL__\n'
		if [ "$fg_arch" = 'x86' ]; then
			printf '#define __NR_%ssyscall_max\t%s\n' \
				"$prefix" "$(( nxt - 1 ))"
		else
			printf '#define __NR_syscalls\t%s\n' "$nxt"
		fi
		printf '#endif\n'
	fi
	printf '\n#endif /* %s */\n' "$fileguard"
} > "$out"
