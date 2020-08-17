#!/bin/sh
# SPDX-License-Identifier: GPL-2.0

in="$1"
out="$2"
my_abis=`echo "($3)" | tr ',' '|'`
offset="$4"
is_compat="$5"
num_syscall_args="$6"
ni_syscall="$7"

if [ "$num_syscall_args" = "3" ]; then
	syscall_fmt='__SYSCALL(%s, %s, )\n'
else
	syscall_fmt='__SYSCALL(%s,%s)\n'
fi
if [ -z "$ni_syscall" ];then
	ni_syscall='sys_ni_syscall'
fi

emit() {
	t_nxt="$1"
	t_nr="$2"
	t_entry="$3"

	while [ $t_nxt -lt $t_nr ]; do
		printf "$syscall_fmt" "${t_nxt}" "$ni_syscall"
		t_nxt=$((t_nxt+1))
	done
	printf "$syscall_fmt" "${t_nxt}" "${t_entry}"
}

grep -E "^[0-9A-Fa-fXx]+[[:space:]]+${my_abis}" "$in" | sort -n | (
	nxt=0
	if [ -z "$offset" ]; then
		offset=0
	fi

	while read nr abi name entry compat ; do
		if [ -n "$is_compat" ] && [ ! -z "$compat" ]; then
			emit $((nxt+offset)) $((nr+offset)) $compat
		else
		emit $((nxt+offset)) $((nr+offset)) $entry
		fi
		nxt=$((nr+1))
	done
) > "$out"
