        .text
	.globl	mymain
	.type	mymain, @function
mymain:
	subq	$40, %rsp	#,
	call	read_int	#
	movq	%rax, 8(%rsp)	# tmp84, n
	movq	$0, 24(%rsp)	#, sum
	movq	$1, 16(%rsp)	#, i
	jmp	.L5	#
.L6:
	call	read_int	#
	movq	%rax, (%rsp)	# tmp85, v
	movq	(%rsp), %rax	# v, tmp86
	addq	%rax, 24(%rsp)	# tmp86, sum
	addq	$1, 16(%rsp)	#, i
.L5:
	movq	16(%rsp), %rax	# i, tmp87
	cmpq	8(%rsp), %rax	# n, tmp87
	jle	.L6	#,
	movq	24(%rsp), %rax	# sum, tmp88
	movq	%rax, %rdi	# tmp88,
	call	print_int	#
	addq	$40, %rsp	#,
	ret	
