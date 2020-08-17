# SPDX-License-Identifier: GPL-2.0
syscall := $(srctree)/$(src)/syscall.tbl
systbl := $(srctree)/$(src)/syscalltbl.sh

syshdr_abis_unistd_32 := common,nospu,32
syshdr_abis_unistd_64 := common,nospu,64
systbl_abis_syscall_table_32 := common,nospu,32
systbl_abi_syscall_table_32 := 32
systbl_abis_syscall_table_64 := common,nospu,64
systbl_abi_syscall_table_64 := 64
systbl_abis_syscall_table_c32 := common,nospu,32
systbl_abi_syscall_table_c32 := c32

uapisyshdr-y		+= unistd_32.h unistd_64.h
kapisyshdr-y		+= syscall_table_32.h		\
			   syscall_table_64.h		\
			   syscall_table_c32.h		\
			   syscall_table_spu.h

include scripts/Makefile.syscalls

systbl_abis_syscall_table_spu := common,spu
systbl_abi_syscall_table_spu := spu
$(kapi)/syscall_table_spu.h: $(syscall) $(systbl)
	$(call if_changed,systbl)
