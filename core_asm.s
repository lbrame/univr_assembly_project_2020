########################
# filename: core_asm.s #
########################

.data

srcs:   .ascii "bruh\00000000000000000000000000000000000000000"
dsts:   .asciz "moment"
num:    .long 31
buff:   .ascii "000000000000000000000000000000000000"

.text
    .global core_asm

core_asm:
    pushl %ebp              # Support nested calls
    movl %esp, %ebp         # Set %ebp
    movl 8(%ebp), %esi      # bufferin in esi
    movl 12(%ebp), %edi     # bufferout_asm in edi
    xorl %ecx, %ecx         # counter
    xorl %edx, %edx         # secondary counter
    
    call init

return:
    popl %ebp
    ret

test_itoa_asm:
    
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    movl num, %eax
    leal buff, %edi
    call itoa_asm
    popl %edi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    

    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    leal buff, %edi
    call atoi_asm
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax

exit_success:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

exit_fail:
    movl $1, %eax
    movl $1, %ebx
    int $0x80
