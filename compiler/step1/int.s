	.file	"int.c"
# GNU C17 (GCC) version 11.2.0 (x86_64-slackware-linux)
#	compiled by GNU C version 11.2.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O0 -fomit-frame-pointer
	.text
	.globl	ti_main
	.type	ti_main, @function
ti_main:
.LFB0:
	.cfi_startproc
	subq	$8, %rsp	#,
	.cfi_def_cfa_offset 16
# int.c:8: { print_int(-42LL); }
	movq	$-42, %rdi	#,
	call	print_int	#
# int.c:8: { print_int(-42LL); }
	nop	
	addq	$8, %rsp	#,
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE0:
	.size	ti_main, .-ti_main
	.ident	"GCC: (GNU) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
