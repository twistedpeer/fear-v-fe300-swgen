ifndef PROGRAM
$(error PROGRAM is not defined!)
endif

ifndef TORTURE_CONFIG
$(error TORTURE_CONFIG is not defined!)
endif

ifndef TORTURE_ISA
$(error TORTURE_ISA is not defined! Example: RV32IMAC)
endif

include ../common.mk

OUT_DIR := $(ROOT_DIR)/bin/riscv-torture

ENV_DIR := $(ROOT_DIR)/include/env
LDFLAGS := -T"$(ENV_DIR)/link.ld" -nostartfiles -nostdlib

CFLAGS_EXTRA += -ffunction-sections -fdata-sections \
	-I"$(ROOT_DIR)/torture/include/" -I"$(ENV_DIR)/" \
	-O0 -g

TORTURE_DIR := $(abspath $(ROOT_DIR)/tools/riscv-torture)

riscv-torture:
	mkdir -p $(OUT_DIR)
	make -C "$(TORTURE_DIR)" gen OPTIONS="-o $(PROGRAM) -I $(TORTURE_ISA) -C $(TORTURE_CONFIG)"
	mv "$(TORTURE_DIR)/output/$(PROGRAM).S" "$(OUT_DIR)"
	mv "$(TORTURE_DIR)/output/$(PROGRAM).stats" "$(OUT_DIR)"
	riscv64-unknown-elf-gcc $(CFLAGS_EXTRA) $(LDFLAGS) -o "$(OUT_DIR)/$(PROGRAM).elf" "$(OUT_DIR)/$(PROGRAM).S" "$(ENV_DIR)/qemu.c"
	$(call qemu,$(OUT_DIR)/$(PROGRAM).elf) -d in_asm,goldenrun -D "$(OUT_DIR)/$(PROGRAM).lst" > "$(OUT_DIR)/$(PROGRAM).signature"

clean:
	rm -rf $(OUT_DIR)/