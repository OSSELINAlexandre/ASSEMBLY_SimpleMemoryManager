.section .data

	.equ HEADER_SIZE,          9
	.equ AIVAILABILITY_OFFSET, 0
	.equ SIZE_OFFSET,          1
	.equ AVAILABILITY,   1

.global deallocate
.type deallocate, @function
deallocate:
	
	movq 16(%rsp), %rcx
	movq %rcx, %rdx
	subq HEADER_SIZE, %rdx
	movq $AVAILABILITY, AIVAILABILITY_OFFSET(%rdx)
	
	retq
	
