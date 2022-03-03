ifndef PROGRAM
$(error PROGRAM is not defined!)
endif

include ../common.mk

CSMITH := $(ROOT_DIR)/tools/csmith/build/bin/csmith
ifeq ($(shell command -v $(CSMITH) 2> /dev/null),)
    $(error CSsmith executable $(CSMITH) not found)
endif

OUT_DIR := $(ROOT_DIR)/bin/csmith

CSMITHFLAGS := --main --no-argc --no-float --no-math64 --no-longlong

CFLAGS_EXTRA := -march=rv32imac -mabi=ilp32 -mcmodel=medlow \
	-I$(ROOT_DIR)/csmith/include \
	-I$(ROOT_DIR)/include/crt \
	-ffunction-sections -fdata-sections \
	--specs=nano.specs -DMTIME_RATE_HZ_DEF=32768 -O0 -g -w \
	"$(OUT_DIR)/$(PROGRAM).c" \
	-Wl,--gc-sections -nostartfiles -nostdlib \
	-L$(ROOT_DIR)/include/crt/ \
	-T$(ROOT_DIR)/include/crt/link.lds \
	-Wl,--start-group -lc -lgcc -lm -lmetal -lmetal-gloss -Wl,--end-group \
	-o "$(OUT_DIR)/$(PROGRAM).elf"

csmith:
	mkdir -p $(OUT_DIR)
	$(CSMITH) -o "$(OUT_DIR)/$(PROGRAM).c" $(CSMITHFLAGS)
	riscv64-unknown-elf-gcc $(CFLAGS_EXTRA)
	timeout --foreground 3s $(call qemu,$(OUT_DIR)/$(PROGRAM).elf) > "$(OUT_DIR)/$(PROGRAM).signature"

clean:
	rm -rf $(OUT_DIR)/