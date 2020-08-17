# SPDX-License-Identifier: GPL-2.0
syscall := $(srctree)/$(src)/syscall.tbl
systbl := $(srctree)/$(src)/syscalltbl.sh

uapisyshdr-y		+= unistd_32.h
kapisyshdr-y		+= syscall_table.h

include scripts/Makefile.syscalls
