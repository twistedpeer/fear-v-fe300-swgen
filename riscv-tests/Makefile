include ../common.mk

BIN_DIR := $(BIN_DIR)/riscv-tests
SRC_DIR := $(abspath ./isa)

ENV_DIR := $(ROOT_DIR)/include/env
LDFLAGS := -T"$(ENV_DIR)/link.ld" -nostartfiles -nostdlib

INCLUDES := -I"$(SRC_DIR)/macros/scalar/" -I"$(ENV_DIR)/"

include $(SRC_DIR)/rv32ui/Makefrag
include $(SRC_DIR)/rv32uc/Makefrag
include $(SRC_DIR)/rv32um/Makefrag
include $(SRC_DIR)/rv32ua/Makefrag
include $(SRC_DIR)/rv32mi/Makefrag

default: all

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

RISCV_PREFIX ?= riscv64-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_GCC_OPTS ?= -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -Wl,--gc-sections $(LDFLAGS)
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump --disassemble-all --disassemble-zeroes --section=.text --section=.text.startup --section=.text.init --section=.data

vpath %.S $(SRC_DIR)

#------------------------------------------------------------
# Build assembly tests

%.dump: %
	$(RISCV_OBJDUMP) "$(BIN_DIR)/$<.elf" > "$(BIN_DIR)/$@"

define compile_template

$$($(1)_p_tests): $(1)-p-%: $(1)/%.S
	mkdir -p $(BIN_DIR)
	$$(RISCV_GCC) $(2) $$(RISCV_GCC_OPTS) $$(INCLUDES) "$$<" "$(ENV_DIR)/qemu.c" -o "$$(BIN_DIR)/$$@.elf"
$(1)_tests += $$($(1)_p_tests)

$(1)_tests_dump = $$(addsuffix .dump, $$($(1)_tests))

$(1): $$($(1)_tests_dump)

.PHONY: $(1)

tests += $$($(1)_tests)

endef

$(eval $(call compile_template,rv32ui,-march=rv32imac -mabi=ilp32))
$(eval $(call compile_template,rv32uc,-march=rv32imac -mabi=ilp32))
$(eval $(call compile_template,rv32um,-march=rv32imac -mabi=ilp32))
$(eval $(call compile_template,rv32ua,-march=rv32imac -mabi=ilp32))
$(eval $(call compile_template,rv32mi,-march=rv32imac -mabi=ilp32))

tests_dump = $(addsuffix .dump, $(tests))

#------------------------------------------------------------
# Default

all: $(tests_dump)

#------------------------------------------------------------
# Clean up

clean:
	rm -rf $(BIN_DIR)/
