.section .data

char_a:         .ascii "A"
char_b:         .ascii "B"
char_c:         .ascii "C"
char_nl:        .ascii "\n"
char_nl_z:      .asciz "\n"
char_open:      .asciz "O"
char_closed:    .asciz "C"
char_sep:       .asciz "-"
char_zero:      .asciz "0"
char_one:       .asciz "1"
buff_a:         .asciz "000"
buff_b:         .asciz "000"
buff_c:         .asciz "000"
int_a:          .word 0
int_b:          .word 0
int_c:          .word 0
in_a:           .asciz "IN-A"
in_b:           .asciz "IN-B"
in_c:           .asciz "IN-C"
out_a:          .asciz "OUT-A"
out_b:          .asciz "OUT-B"
out_c:          .asciz "OUT-C"
buff_cmd:       .asciz "000000"
max_a:          .word 31
max_b:          .word 31
max_c:          .word 24

.section .text
    .global init

.type init, @function

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
    movb (%esi,%ecx), %al
    testb %al, %al
    jz parse_complete
    xorl %eax, %eax
    leal (%esi,%ecx), %eax
    testb %al, %al            # check if terminator is reached
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
    pushl %edi
    pushl %ecx
    pushl %edx
    xorl %eax, %eax
    xorl %edx, %edx
    leal buff_cmd, %edi

parse_command_loop:
    movb (%esi,%ecx), %al
    movb %al, (%edi,%edx)
    cmpb char_nl, %al
    je parse_command_loop_end
    incl %ecx
    incl %edx
    jmp parse_command_loop

parse_command_loop_end:
    popl %edx
    popl %ecx
    popl %edi

    # Compare with known valid strings
    pushl %ecx
    pushl %esi
    pushl %edi
    leal in_a, %esi
    leal buff_cmd, %edi
    call strcmp_asm
    testl %eax, %eax
    jz parse_command_in_a
    leal in_b, %esi
    leal buff_cmd, %edi
    call strcmp_asm
    testl %eax, %eax
    jz parse_command_in_b
    leal in_c, %esi
    leal buff_cmd, %edi
    call strcmp_asm
    testl %eax, %eax
    jz parse_command_in_c
    leal out_a, %esi
    leal buff_cmd, %edi
    call strcmp_asm
    testl %eax, %eax
    jz parse_command_out_a
    leal out_b, %esi
    leal buff_cmd, %edi
    call strcmp_asm
    testl %eax, %eax
    jz parse_command_out_b
    leal out_c, %esi
    leal buff_cmd, %edi
    call strcmp_asm
    testl %eax, %eax
    jz parse_command_out_c
    jmp parse_command_invalid
    

parse_command_in_a:
    popl %edi
    popl %esi
    popl %ecx
    xorl %eax, %eax
    xorl %ebx, %ebx
    movw max_a, %ax
    movw int_a, %bx
    cmpw %ax, %bx
    jl parse_command_in_a_success
    jmp parse_command_failure
    

parse_command_in_a_success:
    xorl %eax, %eax
    incw %bx
    movw %bx, int_a
    xorl %eax, %eax
    movw %bx, %ax

    call update_arrays
    call fix_arrays
    call append_in_success

    jmp parse_next

parse_command_in_b:
    popl %edi
    popl %esi
    popl %ecx
    xorl %eax, %eax  
    xorl %ebx, %ebx
    movw max_b, %ax
    movw int_b, %bx
    cmpw %ax, %bx
    jl parse_command_in_b_success
    jmp parse_command_failure  

parse_command_in_b_success:
    xorl %eax, %eax
    incw %bx
    movw %bx, int_b

    call update_arrays
    call fix_arrays
    call append_in_success
    
    jmp parse_next

parse_command_in_c:
    popl %edi
    popl %esi
    popl %ecx
    xorl %eax, %eax
    xorl %ebx, %ebx
    movw max_c, %ax
    movw int_c, %bx
    cmpw %ax, %bx
    jl parse_command_in_c_success
    jmp parse_command_failure

parse_command_in_c_success:
    xorl %eax, %eax
    incw %bx
    movw %bx, int_c

    call update_arrays
    call fix_arrays
    call append_in_success

    jmp parse_next

parse_command_out_a:
    popl %edi
    popl %esi
    popl %ecx
    xorl %eax, %eax
    movw int_a, %ax
    decw %ax
    movw %ax, int_a
    jmp parse_next

parse_command_out_b:
    popl %edi
    popl %esi
    popl %ecx
    xorl %eax, %eax
    movw int_b, %ax
    decw %ax
    movw %ax, int_b
    jmp parse_next

parse_command_out_c:
    popl %edi
    popl %esi
    popl %ecx
    xorl %eax, %eax
    movw int_c, %ax
    decw %ax
    movw %ax, int_c
    jmp parse_next

parse_command_failure:
    jmp parse_next

parse_command_invalid:
    popl %edi
    popl %esi
    popl %ecx
    jmp parse_next


parse_next:
    xorl %eax, %eax
    movb (%esi,%ecx), %al
    testb %al, %al
    jz parse_complete       # exit when "\0" escape is reached
    xorl %eax, %eax
    movb char_nl, %al
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

update_arrays:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    // Update sectors' array values
    xorl %eax, %eax
    movw int_a, %ax
    leal buff_a, %edi
    call itoa_asm
    xorl %eax, %eax
    movw int_b, %ax
    leal buff_b, %edi
    call itoa_asm
    xorl %eax, %eax
    movw int_c, %ax
    leal buff_c, %edi
    call itoa_asm
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    ret

fix_arrays:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    // Replace \n with \0 to work with strcat_asm
    leal buff_a, %edi
    call nltoz
    leal buff_b, %edi
    call nltoz
    leal buff_c, %edi
    call nltoz
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    ret

append_in_success:
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi
    // Append to bufferout_asm
    movl %edi, %esi
    leal char_open, %edi
    call strcat_asm
    leal char_closed, %edi
    call strcat_asm
    leal char_sep, %edi
    call strcat_asm
    // Sector A
    xorl %eax, %eax
    movw $10, %ax
    cmpw $10, int_a
    jl append_in_success_addzero_a
append_in_success_a:
    leal buff_a, %edi
    call strcat_asm
    leal char_sep, %edi
    call strcat_asm
    // Sector B
    xorl %eax, %eax
    movw $10, %ax
    cmpw $10, int_b
    jl append_in_success_addzero_b
append_in_success_b:
    leal buff_b, %edi
    call strcat_asm
    leal char_sep, %edi
    call strcat_asm
    // Sector C
    xorl %eax, %eax
    movw $10, %ax
    cmpw $10, int_c
    jl append_in_success_addzero_c
append_in_success_c:
    leal buff_c, %edi
    call strcat_asm
    leal char_sep, %edi
    call strcat_asm

    // Empty/Full status
    leal char_zero, %edi
    call strcat_asm
    leal char_zero, %edi
    call strcat_asm
    leal char_zero, %edi
    call strcat_asm
    leal char_nl_z, %edi
    call strcat_asm
    
    jmp append_in_success_done

append_in_success_addzero_a:
    leal char_zero, %edi
    call strcat_asm
    jmp append_in_success_a

append_in_success_addzero_b:
    leal char_zero, %edi
    call strcat_asm
    jmp append_in_success_b

append_in_success_addzero_c:
    leal char_zero, %edi
    call strcat_asm
    jmp append_in_success_c

append_in_success_done:
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
    ret
