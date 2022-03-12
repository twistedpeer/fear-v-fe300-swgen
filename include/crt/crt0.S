#include "encoding.h"

#define DELEGATE_NO_TRAPS                                               \
  csrwi mie, 0;                                                         \
  la t0, 1f;                                                            \
  csrw mtvec, t0;                                                       \
  csrwi medeleg, 0;                                                     \
  csrwi mideleg, 0;                                                     \
  .align 2;                                                             \
1:

        .section .text.init;
        .align  6;
        // .weak stvec_handler;
        // .weak mtvec_handler;
        .globl _start;
_start:
        /* reset vector */
        j reset_vector;
        .align 2;
trap_vector:
        csrr t5, mcause;
        /* FEAR5: Just stop here and report the exception... */
        la t6, 0x80000000;
        li t3, 0x10000000;
        add t3, t3, t5;
        sw t3, 0(t6);
        /* END FEAR5 */
reset_vector:
        li x1, 0;
        li x2, 0;
        li x3, 0;
        li x4, 0;
        li x5, 0;
        li x6, 0;
        li x7, 0;
        li x8, 0;
        li x9, 0;
        li x10, 0;
        li x11, 0;
        li x12, 0;
        li x13, 0;
        li x14, 0;
        li x15, 0;
        li x16, 0;
        li x17, 0;
        li x18, 0;
        li x19, 0;
        li x20, 0;
        li x21, 0;
        li x22, 0;
        li x23, 0;
        li x24, 0;
        li x25, 0;
        li x26, 0;
        li x27, 0;
        li x28, 0;
        li x29, 0;
        li x30, 0;
        li x31, 0;
        DELEGATE_NO_TRAPS;
        la t0, trap_vector;
        csrw mtvec, t0;
        /* if an stvec_handler is defined, delegate exceptions to it */
        // la t0, stvec_handler;
        // beqz t0, 1f;
        // csrw stvec, t0;
        // li t0, (1 << CAUSE_LOAD_PAGE_FAULT) | (1 << CAUSE_STORE_PAGE_FAULT) | (1 << CAUSE_FETCH_PAGE_FAULT) | (1 << CAUSE_MISALIGNED_FETCH) | (1 << CAUSE_USER_ECALL) | (1 << CAUSE_BREAKPOINT);
        // csrw medeleg, t0;
1:      csrwi mstatus, 0;
        li a0, MSTATUS_MPP;
        csrs mstatus, a0;
        la t0, 1f;
        csrw mepc, t0;
        csrr a0, mhartid;
        mret;
1:

//	j test_start

//test_start:
	la sp, 0x80003FFC;
	call main
