# This Makefile wraps SW generation for Freedom E300
#
# Test suites / generators:
# - riscv-tests      (static test suite, done)
# - riscv-arch-tests (static test suite, done)
# - riscv-torture    (generator, done)
# - csmith           (generator, done)

.PHONY: all riscv-tests riscv-arch-tests riscv-torture csmith

all: riscv-tests riscv-arch-tests riscv-torture csmith

riscv-tests:
	make -C ./riscv-tests

riscv-arch-tests:
	make -C ./riscv-arch-tests run

riscv-torture:
	make -C ./riscv-torture

csmith:
	make -C ./csmith csmith

clean:
	make -C ./riscv-tests clean
	make -C ./riscv-arch-tests clean
	make -C ./riscv-torture clean PROGRAM=none TORTURE_CONFIG=none TORTURE_ISA=none
	make -C ./csmith clean PROGRAM=none
