ifndef PROGRAM
$(error PROGRAM is not defined!)
endif

include ../common.mk

BIN_DIR := $(BIN_DIR)/csmith
SRC_DIR := $(SRC_DIR)/csmith

CSMITHFLAGS := --main --no-argc --no-float --no-math64 --no-longlong

# TO DO: Properly set terminator address!!!
QEMU_TERMINATOR := -device terminator,address=0x80000000

CFLAGS_EXTRA := -march=rv32imac -mabi=ilp32 -mcmodel=medlow \
	-I$(ROOT_DIR)/csmith/include \
	-I$(ROOT_DIR)/include/crt \
	-ffunction-sections -fdata-sections \
	--specs=nano.specs -DMTIME_RATE_HZ_DEF=32768 -O0 -g -w \
	"$(SRC_DIR)/$(PROGRAM).c" \
	-Wl,--gc-sections -nostartfiles -nostdlib \
	-L$(ROOT_DIR)/include/crt/ \
	-T$(ROOT_DIR)/include/crt/link.lds \
	-Wl,--start-group -lc -lgcc -lm -lmetal -lmetal-gloss -Wl,--end-group \
	-o "$(BIN_DIR)/$(PROGRAM).elf"

csmith:
	mkdir -p $(BIN_DIR)
	mkdir -p $(SRC_DIR)
	$(ROOT_DIR)/tools/csmith/build/bin/csmith -o "$(SRC_DIR)/$(PROGRAM).c" $(CSMITHFLAGS)
	riscv64-unknown-elf-gcc $(CFLAGS_EXTRA)
	timeout --foreground 3s qemu-system-riscv32 -M $(QEMU_MACHINE) -bios none -nographic -kernel "$(BIN_DIR)/$(PROGRAM).elf" $(QEMU_TERMINATOR) > "$(BIN_DIR)/$(PROGRAM).signature.output"

clean:
	rm -rf $(BIN_DIR)
	rm -rf $(SRC_DIR)