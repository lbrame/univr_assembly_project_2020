.section .data

tmp:    .byte 0
ter:    .ascii "\0"
lf:     .ascii "\n"

.section .text
    .global itoa_asm

.type itoa_asm, @function

    # %eax: input
    # %ebx: calculations
    # %ecx: counter
    # %edi: output
    # %ecx: counter (number of digits saved)
    # %edx: 

itoa_asm:
    xorl %ecx, %ecx

itoa_asm_loop:
    cmp $10, %eax
    jge itoa_asm_div    # Jmp if the number is 10 or more
    pushl %eax          # Save eax (input) onto stack
    incl %ecx           # Increment counter
    movl %ecx, %ebx     # Save counter to %ebx
    xorl %edx, %edx     # edx repurposed as aux counter
    jmp itoa_asm_div_done

itoa_asm_div:
    xorl %edx, %edx     # Clean %edx (remainder)
    movl $10, %ebx      # Prepare to divide by 10
    divl %ebx           # %eax / %ebx. Quotient in %eax
                        # remainder in %edx
    pushl %edx          # remainder
    incl %ecx           # increment counter
    jmp itoa_asm_loop
    
    
itoa_asm_div_done:
    xorl %ecx, %ecx     # ecx repurposes as temp
    testl %ebx, %ebx    # Check if any char is left
    je itoa_asm_done    # If there isn't any, we're done
    popl %eax           # Restore
    movb %al, tmp
    addb $48, tmp       # ASCII 0
    decl %ebx           # One less char to print
    pushw %bx

    movb tmp, %cl
    movb %cl, (%edi,%edx)
    incl %edx

    /*
    movl   $4, %eax
	movl   $1, %ebx
	leal  tmp, %ecx		
	mov    $1, %edx
	int $0x80
    */

    popw %bx
    jmp itoa_asm_div_done

itoa_asm_done:
    xorl %ecx, %ecx
    movb lf, %cl
    movb %cl, (%edi,%edx)
    ret
