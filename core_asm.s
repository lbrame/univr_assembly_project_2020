########################
# filename: core_asm.s #
########################

.data

// bufferin:
//     .fill 1001,1,0
// 
// bufferout_asm:
//     .fill 3001,1,0

sa_max:
    .long 31

sb_max:
    .long 31

sc_max:
    .long 24

sa_arr:
    .ascii "0000"

sb_arr:
    .ascii "0000"

sc_arr:
    .ascii "0000"

a_letter:
    .ascii "A"

b_letter:
    .ascii "B"

c_letter:
    .ascii "C"

sa:
    .long 0

sb:
    .long 0

sc:
    .long 0

buff:
    .ascii "0000000"

buff_len:
    .long 7

entrato:
    .asciz "Entrato"

entrato_len:
    .long 8


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
