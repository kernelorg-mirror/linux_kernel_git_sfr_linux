# SPDX-License-Identifier: GPL-2.0
syscall := $(srctree)/$(src)/syscall.tbl

systbl_num_syscall_args := 3

syshdr_offset_unistd_64 := __NR_Linux
systbl_offset_syscall_table := 1024

uapisyshdr-y		+= unistd_64.h
kapisyshdr-y		+= syscall_table.h

include scripts/Makefile.syscalls
