.include "linux.s"
.include "records_definition.s"

.section .data
	buffer_ptr:
		long 0
.section .text

.global _start

_start:
	movq %rsp, %rbp
	subq  $FILEDESCRIPTOR_LOCATION, %rsp
	
memory_manager_init:
	callq init_manager
	
open_input_file:
	movq $SYS_OPEN, %rax
	movq $filename, %rdi
	movq $O_RDONLY, %rsi
	movq $0, %rdx
	syscall
	
	movq  %rax, FILEDESCRIPTOR_LOCATION(%rbp)
	
	pushq $1000
	callq allocate
	movq %rax, buffer_ptr
	pushq buffer_ptr
	pushq FILEDESCRIPTOR_LOCATION(%rbp)
	callq read_from_file
	
.write_output:
	movq $1, %rax
	movq $1, %rdi
	movq $buffer_ptr, %rsi
	movq $1000, %rdx
	syscall	

close_file:
	movq $SYS_CLOSE, %rax
	movq FILEDESCRIPTOR_LOCATION(%rbp), %rdi
	syscall
	
exit_system:
	movq $60, %rax
	movq $0, %rdi
	syscall	
