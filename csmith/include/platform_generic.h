/* -*- mode: C -*-
 *
 * Copyright (c) 2007, 2008, 2011, 2013 The University of Utah
 * All rights reserved.
 *
 * This file is part of `csmith', a random generator of C programs.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef PLATFORM_GENERIC_H
#define PLATFORM_GENERIC_H

/*****************************************************************************/

#ifdef STANDALONE
extern int printf (const char *, ...);
extern void qemu_exit_normal(void);
#else
#include <stdio.h>
#include <metal/cpu.h>
#endif

// This is memory-mapped to the beginning of RAM (0x80000000)
int terminator __attribute__((section(".terminator")));

void my_exception_handler(struct metal_cpu *cpu, int ecode) {
   terminator = (ecode | 0x10000000);
}

static void
platform_main_begin(void)
{
	struct metal_cpu *cpu0 = metal_cpu_get(0);
	struct metal_interrupt *cpu_int = metal_cpu_interrupt_controller(cpu0);
	metal_interrupt_init(cpu_int);

	// metal_cpu_exception_register(cpu0, 2, my_exception_handler);

	for (int i = 0; i < 16; i++) {
		metal_cpu_exception_register(cpu0, i, my_exception_handler);
	}
}

static void
platform_main_end(uint32_t crc, int flag)
{
#if defined (__FRAMAC)
    Frama_C_dump_assert_each();
#endif

#ifndef NOT_PRINT_CHECKSUM
	printf ("checksum = %X\n", crc);
#endif

#if defined (LOG_WRAPPERS)
	{
		int i, first;

		printf ("executed wrappers: ");
		first = 1;
		for (i=1; i<N_WRAP+1; i++) {
			if (__executed_checks[i]) {
				if (!first) {
					printf (",");
				} else {
					first = 0;
				}
				printf ("%d", i);
			}
		}
		printf ("\n");

		printf ("dead wrappers: ");
		first = 1;
		for (i=1; i<N_WRAP+1; i++) {
			if (!__executed_checks[i]) {
				if (!first) {
					printf (",");
				} else {
					first = 0;
				}
				printf ("%d", i);
			}
		}
		printf ("\n");

		printf ("wrappers that failed at least once: ");
		first = 1;
		for (i=1; i<N_WRAP+1; i++) {
			if (__failed_checks[i]) {
				if (!first) {
					printf (",");
				} else {
					first = 0;
				}
				printf ("%d", i);
			}
		}
		printf ("\n");

		printf ("wrappers that never failed (or never executed): ");
		first = 1;
		for (i=1; i<N_WRAP+1; i++) {
			if (!__failed_checks[i]) {
				if (!first) {
					printf (",");
				} else {
					first = 0;
				}
				printf ("%d", i);
			}
		}
		printf ("\n");
	}
#endif
	terminator = 0;
}

#define MB (1<<20)

/*****************************************************************************/

#endif /* PLATFORM_GENERIC_H */

/*
 * Local Variables:
 * c-basic-offset: 4
 * tab-width: 4
 * End:
 */

/* End of file. */
