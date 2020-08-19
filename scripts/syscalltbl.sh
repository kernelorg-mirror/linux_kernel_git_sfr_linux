#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

in="$1"
out="$2"
my_abis=$(echo "($3)" | tr ',' '|')
offset="$4"
is_compat="$5"
ni_syscall="$6"

if [ -z "$offset" ]; then
	offset=0
fi
if [ -z "$ni_syscall" ];then
	ni_syscall='sys_ni_syscall'
fi

emit() {
	t_nxt="$1"
	t_nr="$2"
	t_entry="$3"

	while [ "$t_nxt" -lt "$t_nr" ]; do
		printf '__SYSCALL(%s,%s)\n' "$t_nxt" "$ni_syscall"
		t_nxt=$(( t_nxt + 1 ))
	done
	printf '__SYSCALL(%s,%s)\n' "$t_nxt" "$t_entry"
}

grep -E "^[[:xdigit:]Xx]+[[:space:]]+${my_abis}" "$in" | sort -n | {
	nxt=0
	while read -r nr _ _ entry compat ; do
		if [ -n "$is_compat" ] && [ -n "$compat" ]; then
			entry="$compat"
		fi
		emit $(( nxt + offset )) $(( nr + offset )) "$entry"
		nxt=$(( nr + 1 ))
	done
} > "$out"
