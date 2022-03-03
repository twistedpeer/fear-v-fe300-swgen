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

BIN_DIR := $(BIN_DIR)/riscv-torture
SRC_DIR := $(SRC_DIR)/riscv-torture

ENV_DIR := $(ROOT_DIR)/include/env
LDFLAGS := -T"$(ENV_DIR)/link.ld" -nostartfiles -nostdlib

CFLAGS_EXTRA += -ffunction-sections -fdata-sections \
	-I"$(ROOT_DIR)/torture/include/" -I"$(ENV_DIR)/" \
	-O0 -g

TORTURE_DIR := $(abspath $(ROOT_DIR)/tools/riscv-torture)

riscv-torture:
	mkdir -p $(BIN_DIR)
	mkdir -p $(SRC_DIR)
	make -C "$(TORTURE_DIR)" gen OPTIONS="-o $(PROGRAM) -I $(TORTURE_ISA) -C $(TORTURE_CONFIG)"
	mv "$(TORTURE_DIR)/output/$(PROGRAM).S" "$(SRC_DIR)"
	mv "$(TORTURE_DIR)/output/$(PROGRAM).stats" "$(SRC_DIR)"
	riscv64-unknown-elf-gcc $(CFLAGS_EXTRA) $(LDFLAGS) -o "$(BIN_DIR)/$(PROGRAM).elf" "$(SRC_DIR)/$(PROGRAM).S" "$(ENV_DIR)/qemu.c"
	qemu-system-riscv32 -M $(QEMU_MACHINE) -bios none -nographic -kernel "$(BIN_DIR)/$(PROGRAM).elf" $(QEMU_TERMINATOR) > "$(BIN_DIR)/$(PROGRAM).signature.output"

clean:
	rm -rf $(BIN_DIR)
	rm -rf $(SRC_DIR)