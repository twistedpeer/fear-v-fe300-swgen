include ../common.mk

BIN_DIR := $(BIN_DIR)/riscv-arch-tests
SRC_DIR := ./src

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

default: all

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

vpath %.S $(abspath rv32i)
vpath %.S $(abspath rv32im)
vpath %.S $(abspath rv32imc)
vpath %.S $(abspath rv32Zicsr)
vpath %.S $(abspath rv32Zifencei)

INCLUDE=./Makefile.include
ifeq ($(wildcard $(INCLUDE)),)
    $(error Cannot find '$(INCLUDE)`. Check that RISCV_TARGET and RISCV_DEVICE are set correctly.)
endif
-include $(INCLUDE)

#------------------------------------------------------------
# Build and run assembly tests

%.signature.output: %.elf
	$(V) echo "Execute $(@)"
	$(V) $(RUN_TARGET)


define compile_template

$(BIN_DIR)/%.elf: $(SRC_DIR)/%.S
	$(V) echo "Compile $$(@)"
	@mkdir -p $$(@D)
	$(V) $(COMPILE_TARGET)

.PRECIOUS: $(BIN_DIR)/%.elf

endef

$(eval $(call compile_template,-march=rv32imac -mabi=ilp32))

target_elf = $(foreach e,$(target_tests),$(BIN_DIR)/$(e))
target_log = $(patsubst %.elf,%.signature.output,$(target_elf))

run: $(target_log)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(BIN_DIR)
