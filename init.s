.section .data

char_a:     .ascii "A"
char_b:     .ascii "B"
char_c:     .ascii "C"
char_nl:    .ascii "\n"
buff_a:     .ascii "0000"
buff_b:     .ascii "0000"
buff_c:     .ascii "0000"
int_a:      .word 0
int_b:      .word 0
int_c:      .word 0
in_a:       .asciz "IN-A"
in_b:       .asciz "IN-B"
in_c:       .asciz "IN-C"
out_a:      .asciz "OUT-A"
out_b:      .asciz "OUT-B"
out_c:      .asciz "OUT-C"

.section .text
    .global init

init:
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx

    /*
    Initialize A, B, C sectors
    %esi: bufferin
    %eax: temporary register for comparison
    %ebx: second temporary register
    %ecx: char counter
    %edx: line number (from 0)
    (%esi,%ecx): bufferin[%ecx]

    use <op>b for char interactions
    registers: al, bl...
    remember to clean when necessary (zero out target register
    before moving)
    */

parse_line:
    leal (%esi,%ecx), %eax
    testl %eax, %eax            # check if terminator is reached
    jz parse_complete
    xorl %eax, %eax             # clean eax for upcoming ops
    cmpl $3, %edx               # check if the init phase is over
    jl parse_slots             # parse commands from line 4 onwards
    jmp parse_command


parse_slots:    # parse initial values for sectors' capacity (A,B,C)
    movb (%esi,%ecx), %al       # %eax = 0000041
    incl %ecx
    cmpb char_a, %al
    je parse_a
    cmpb char_b, %al
    je parse_b
    cmpb char_c, %al
    je parse_c
    jmp parse_next
    
parse_a:
    xorl %eax, %eax
    pushl %edi
    pushl %ecx
    pushl %edx
    leal buff_a, %edi
    xorl %edx, %edx
    incl %ecx

parse_a_loop:
    movb (%esi,%ecx), %al
    movb %al, (%edi,%edx)
    incl %ecx
    incl %edx
    cmpb char_nl, %al
    je parse_a_atoi
    jmp parse_a_loop

parse_a_atoi:
    popl %edx
    popl %ecx
    popl %edi
    pushl %esi
    pushl %edi
    pushl %ebp
    pushl %ecx
    pushl %edx
    leal buff_a, %edi
    call atoi_asm
    movw %ax, int_a
    popl %edx
    popl %ecx
    popl %ebp
    popl %edi
    popl %esi
    jmp parse_next

parse_b:
    xorl %eax, %eax
    pushl %edi
    pushl %ecx
    pushl %edx
    leal buff_b, %edi
    xorl %edx, %edx
    incl %ecx

parse_b_loop:
    movb (%esi,%ecx), %al
    movb %al, (%edi,%edx)
    incl %ecx
    incl %edx
    cmpb char_nl, %al
    je parse_b_atoi
    jmp parse_b_loop

parse_b_atoi:
    popl %edx
    popl %ecx
    popl %edi
    pushl %esi
    pushl %edi
    pushl %ebp
    pushl %ecx
    pushl %edx
    leal buff_b, %edi
    call atoi_asm
    movw %ax, int_b
    popl %edx
    popl %ecx
    popl %ebp
    popl %edi
    popl %esi
    jmp parse_next

parse_c:
    xorl %eax, %eax
    pushl %edi
    pushl %ecx
    pushl %edx
    leal buff_c, %edi
    xorl %edx, %edx
    incl %ecx

parse_c_loop:
    movb (%esi,%ecx), %al
    movb %al, (%edi,%edx)
    incl %ecx
    incl %edx
    cmpb char_nl, %al
    je parse_c_atoi
    jmp parse_c_loop

parse_c_atoi:
    popl %edx
    popl %ecx
    popl %edi
    pushl %esi
    pushl %edi
    pushl %ebp
    pushl %ecx
    pushl %edx
    leal buff_c, %edi
    call atoi_asm
    movw %ax, int_c
    popl %edx
    popl %ecx
    popl %ebp
    popl %edi
    popl %esi
    jmp parse_next



parse_command:  # parse IN/OUT commands
    jmp parse_next

parse_next:
    xorl %eax, %eax
    movb char_nl, %al
    testl %eax, %eax
    je parse_complete       # exit when "\0" escape is reached
    cmpb (%esi,%ecx), %al
    je prepare_to_parse_line
    incl %ecx
    jmp parse_next

prepare_to_parse_line:
    incl %ecx
    incl %edx
    jmp parse_line

parse_complete:
    ret
    

parse_error:
    movl $1, %eax       # syscall_exit
    movl $1, %ebx       # return value 1 (failure)
    int $0x80
