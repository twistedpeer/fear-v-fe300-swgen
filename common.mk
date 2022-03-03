ROOT_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
BIN_DIR := $(ROOT_DIR)/bin
SRC_DIR := $(ROOT_DIR)/src

CFLAGS_EXTRA := -march=rv32imac -mabi=ilp32
QEMU_MACHINE := sifive_e
QEMU_TERMINATOR := -device terminator,address=0x80000000