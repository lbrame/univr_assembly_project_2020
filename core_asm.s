########################
# filename: core_asm.s #
########################

.data

// bufferin:
//     .fill 1001,1,0
// 
// bufferout_asm:
//     .fill 3001,1,0


buff:   .ascii "0000000"
buff_len:   .long 7
str1:   .asciz "IN-A"
str2:   .ascii "IN-A"
retval: .long -1

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

/*
test_atoi:
    pushl %esi
    pushl %edi
    leal numstr, %edi
    call atoi_asm
    movl %eax, toprint
    popl %edi
    popl %esi
*/

test_strcmp:
    pushl %esi
    pushl %edi
    leal str1, %esi
    leal str2, %edi
    call strcmp_asm
    popl %edi
    popl %esi
    movl %eax, retval
    cmpl $1, %eax
    je exit_fail
    jmp exit_success

exit_success:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

exit_fail:
    movl $1, %eax
    movl $1, %ebx
    int $0x80
