ifndef PROGRAM
$(error PROGRAM is not defined!)
endif

ifndef CSMITHFLAGS
$(error CSMITHFLAGS is not defined!)
endif

include ../common.mk

CSMITH := $(ROOT_DIR)/work/csmith/bin/csmith
ifeq ($(shell command -v $(CSMITH) 2> /dev/null),)
    $(error CSsmith executable $(CSMITH) not found)
endif

OUT_DIR := $(ROOT_DIR)/bin/csmith

# CSMITHFLAGS := --main --no-argc --no-float --no-math64 --no-longlong

CFLAGS_EXTRA := -march=rv32imac -mabi=ilp32 \
	-I$(ROOT_DIR)/csmith/include \
	-I$(ROOT_DIR)/include/crt \
	-O2 -DCSMITH_MINIMAL -DNO_PRINTF \
	$(ROOT_DIR)/include/crt/crt0.S \
	"$(OUT_DIR)/$(PROGRAM).c" \
	-nostartfiles -nostdlib \
	-L$(ROOT_DIR)/include/crt/ \
	-T$(ROOT_DIR)/include/crt/link.ld \
	-o "$(OUT_DIR)/$(PROGRAM).elf"

csmith:
	mkdir -p $(OUT_DIR)
	$(CSMITH) -o "$(OUT_DIR)/$(PROGRAM).c" $(CSMITHFLAGS)
	riscv64-unknown-elf-gcc $(CFLAGS_EXTRA)
	timeout --foreground 3s $(call qemu,$(OUT_DIR)/$(PROGRAM).elf) -d in_asm,goldenrun -D "$(OUT_DIR)/$(PROGRAM).lst" > "$(OUT_DIR)/$(PROGRAM).signature"

clean:
	rm -rf $(OUT_DIR)/