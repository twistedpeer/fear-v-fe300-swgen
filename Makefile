# This Makefile wraps SW generation for Freedom E300
#
# Test suites / generators:
# - riscv-tests      (static test suite, done)
# - riscv-arch-tests (static test suite, planned)
# - riscv-torture    (generator, planned)
# - csmith           (generator, planned)

.PHONY: all riscv-tests riscv-arch-tests riscv-torture

all: riscv-tests riscv-arch-tests riscv-torture

riscv-tests:
	make -C ./riscv-tests

riscv-arch-tests:
	make -C ./riscv-arch-tests run

riscv-torture:
	make -C ./riscv-torture

clean:
	make -C ./riscv-tests clean
	make -C ./riscv-arch-tests clean
	make -C ./riscv-torture clean
