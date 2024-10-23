# The desired assembly for Step 1.1 (given the constant -42)
# Beginning of the code
	.text
# The name (label) defined below is global (visible outside this file)
	.globl	_ti_main
# The declaration of the name itself
_ti_main:
# x86-64 ABI, stack alignment: see the text
	subq	$8, %rsp
# move -42 to the argument register
	movq	$-42, %rdi
# call the external function
	call	_print_int
# restore the stack
	addq	$8, %rsp
# return
	ret	
