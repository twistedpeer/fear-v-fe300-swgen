ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

CFLAGS_EXTRA := -march=rv32imac -mabi=ilp32

###############################################################################
# QEMU checks & rules:
###############################################################################
QEMU ?= qemu-system-riscv32
ifeq ($(shell command -v $(QEMU) 2> /dev/null),)
$(error QEMU executable '$(QEMU)` not found)
endif

QEMU_MACHINE := sifive_e
QEMU_CPU := rv32,g=false,a=true,m=true,c=true,f=false,d=false,s=false,u=false,mmu=false,pmp=true
QEMU_TERMINATOR := 0x80000000

define qemu
$(QEMU) -M $(QEMU_MACHINE) -cpu $(QEMU_CPU) -nographic -device terminator,address=$(QEMU_TERMINATOR) -kernel "$(1)"
endef
