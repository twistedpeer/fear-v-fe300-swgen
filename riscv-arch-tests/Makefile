include ../common.mk

OUT_DIR := $(ROOT_DIR)/bin/riscv-arch-tests

ENV_DIR := $(ROOT_DIR)/include/env
LDFLAGS := -T"$(ENV_DIR)/link.ld" -nostartfiles -nostdlib

INCLUDES := -I"$(ROOT_DIR)/riscv-arch-tests/include/" -I"$(ENV_DIR)/"

NOTRAPS = 1

include rv32i/Makefrag
include rv32im/Makefrag
include rv32imc/Makefrag
include rv32Zicsr/Makefrag
include rv32Zifencei/Makefrag
ifneq ($(RISCV_TEST),)
    target_tests = $(RISCV_TEST).elf
endif

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

vpath %.S $(abspath rv32i/src)
vpath %.S $(abspath rv32im/src)
vpath %.S $(abspath rv32imc/src)
vpath %.S $(abspath rv32Zicsr/src)
vpath %.S $(abspath rv32Zifencei/src)

#------------------------------------------------------------
# Build and run assembly tests

default: run

%.signature: %.elf
	$(V) echo "Execute $(@)"
	$(call qemu,$(<)) > "$(*).signature"


define compile_template

$(OUT_DIR)/%.elf: %.S
	$(V) echo "Compile $$(@)"
	@mkdir -p $$(@D)
	riscv64-unknown-elf-gcc -march=rv32imac -mabi=ilp32 -static -g -mcmodel=medany -nostartfiles -nostdlib $$(INCLUDES) $$(LDFLAGS) "$$(<)" "$(ENV_DIR)/qemu.c" -o "$$@"
	riscv64-unknown-elf-objdump -D "$$@" > "$$(@:.elf=.dump)"
	cp "$$(<)" "$(OUT_DIR)"

.PRECIOUS: $(OUT_DIR)/%.elf

endef

$(eval $(call compile_template,-march=rv32imac -mabi=ilp32))

target_elf = $(foreach e,$(target_tests),$(OUT_DIR)/$(e))
target_log = $(patsubst %.elf,%.signature,$(target_elf))

run: clean $(target_log)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(OUT_DIR)/
