# SPDX-License-Identifier: GPL-2.0
syscall := $(srctree)/$(src)/syscall.tbl
systbl := $(srctree)/$(src)/syscalltbl.sh

syshdr_abis_unistd_32 := common,32
syshdr_abis_unistd_64 := common,64
systbl_abis_syscall_table_32 := common,32
systbl_abis_syscall_table_64 := common,64
systbl_abis_syscall_table_c32 := common,32
systbl_abi_syscall_table_c32 := c32

uapisyshdr-y		+= unistd_32.h unistd_64.h
kapisyshdr-y		+= syscall_table_32.h		\
			   syscall_table_64.h		\
			   syscall_table_c32.h

include scripts/Makefile.syscalls
