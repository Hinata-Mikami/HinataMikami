# The desired assembly for Step 1.1 (given the constant -42)
# On a Mac, the code looks slighly differently: see the Mac version
# Beginning of the code
	.text
# The name (label) defined below is global (visible outside this file)
	.globl	ti_main
# This name is a function name (that is, it points to code)
	.type	ti_main, @function
# The declaration of the name itself
ti_main:
# x86-64 ABI, stack alignment: see the text
	subq	$8, %rsp
# move -42 to the argument register
	movq	$-42, %rdi
# call the external function
	call	print_int
# restore the stack
	addq	$8, %rsp
# return
	ret	
