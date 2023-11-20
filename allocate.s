.section .data
	heap_begin:
		.long 0
			
	heap_end:
		.long 0
		
	manager_inited:
		.int 0 
	
	.equ AVAILABILITY,   1
	.equ UNAVAILABILITY, 0
	
	.equ HEADER_SIZE,          9
	.equ AIVAILABILITY_OFFSET, 0
	.equ SIZE_OFFSET,          1

	.equ SYS_BREAK, 12
	
.section .text

.global init_manager
.type init_manager, @function
init_manager:

	pushq %rbp
	movq  %rsp, %rbp
	
	movq $SYS_BREAK, %rax
	movq $0, %rdi	
	syscall
	
	addq  $8,   %rax            #Need to add one octet
	movq  %rax, heap_begin
	movq  %rax, heap_end
	movq  $1,   manager_inited
	
	movq %rbp, %rsp
	popq %rbp
	retq

.global allocate
.type allocate, @function
allocate:
# %rcx : memory_needed
# %rdx : current_break
# %rbx : heap_end

	pushq %rbp
	movq  %rsp, %rbp
	cmpq  $1, manager_inited
	jne   ERROR
	
	movq  heap_begin, %rdx
	movq  heap_end,   %rbx
	movq  -16(%rbp),  %rcx

loop:
	cmpq %rdx, %rbx
	je   heap_space_needed
	
	cmpq $AVAILABILITY, AIVAILABILITY_OFFSET(%rdx)
	jne  INCREMENT_CURRENT
	
	cmpq %rcx, SIZE_OFFSET(%rdx)
	jg   INCREMENT_CURRENT
	
 	movq HEADER_SIZE(%rdx), %rax
 	movq $UNAVAILABILITY, AIVAILABILITY_OFFSET(%rdx)
 	
 	jmp exit_function
	
heap_space_needed:
	addq $HEADER_SIZE, %rcx

	pushq %rcx
	pushq %rdx
	pushq %rbx
	
	movq $SYS_BREAK, %rax
	movq %rcx, %rdi
 	syscall
 
 	cmpq $0, %rax
 	je ERROR
 
 	popq %rcx
	popq %rdx
	popq %rbx
	 		
 	addq %rax, %rbx
 	movq %rbx, heap_end
 	movq $UNAVAILABILITY, AIVAILABILITY_OFFSET(%rdx)
 	subq $HEADER_SIZE, %rax
 	movq %rax, SIZE_OFFSET(%rdx)
 	
 	movq HEADER_SIZE(%rdx), %rax
 	
 	jmp exit_function
 
INCREMENT_CURRENT:
	movq SIZE_OFFSET(%rdx), %r8
	addq $HEADER_SIZE, %r8
	addq %r8, %rdx
	jmp  loop

exit_function:
	movq %rbp, %rsp
	popq %rbp
	retq

ERROR:
	movq $0, %rax
	jmp exit_function

