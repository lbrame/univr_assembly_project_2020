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
str1:   .asciz "test"
str2:   .asciz "test"
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

test_strcmp:
    leal str1, %esi
    leal str2, %edi
    call strcmp_asm
    movl %eax, retval
    cmpl $1, %eax
    je exit_fail
    jmp exit_success

