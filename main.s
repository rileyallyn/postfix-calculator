.text
.global _start

_start:
    // lets start by storing the stack pointer
    mov r7, sp

    // print welcome message
    ldr r0, =welcome_msg
    bl printf
    
    b loop
    
loop:
    // print the stack
    bl print_stack

    ldr r0, =input_fmt
    bl printf    

    // wait for input
    ldr     r0, =myString
    mov     r1, #100
    ldr     r2, =stdin
    ldr     r2, [r2]
    bl      fgets

    // read an integer from the string
    ldr     r0, =myString
    ldr     r1, =format_msg
    ldr     r2, =num
    bl      sscanf

    // if string is an integer, lets push the value to the stack
    cmp r0, #1
    beq is_int

    // now that we know that the string is not an integer, lets check if it is an operator
    ldr     r0, =myString
    ldrb    r0, [r0]

    // program control commands
    cmp r0, #'q'
    beq pgm_exit

    cmp r0, #'c'
    beq pop_stack

    cmp r0, #'a'
    beq pop_entire_stack

    // arithmetic commands
    
    // lets make sure any operation can actually run
    // compare stack pointer to saved stack pointer
    add r4, sp, #4
    cmp r7, r4
    ble error_not_enough_in_stack

    // add
    mov r1, #'+'
    cmp r0, r1
    beq add_int

    // sub
    mov r1, #'-'
    cmp r0, r1
    beq sub_int
    
    // multiply
    mov r1, #'*'
    cmp r0, r1
    beq mult_int

    // no other commands exist, so lets error and let the user know
    b error_non_existant_command

// sub routines

// -- errors --

error_not_enough_in_stack:
    ldr r0, =error_not_enough_in_stack_msg
    bl printf

    b loop

error_non_existant_command:
    ldr r0, =error_non_existant_command_msg
    bl printf

    b loop

// -- arithmetic --

is_int:
    ldr r1, =num
    ldr r1, [r1]
    push {r1}

    b loop
    
add_int:
    pop {r0}
    pop {r1}
    add r0, r0, r1
    push {r0}

    b loop

sub_int:
    pop {r0}
    pop {r1}
    sub r0, r1, r0
    push {r0}

    b loop

mult_int:
    pop {r0}
    pop {r1}
    mul r2, r0, r1
    push {r2}

    b loop

// -- stack --

print_stack:
    mov r11, lr
    ldr r0, =stack_msg_begin
    bl printf
    
    mov r5, sp

    b print_stack_loop

print_stack_loop:
    cmp r5, r7
    beq print_stack_end

    ldr r0, =print_stack_msg
    ldr r1, [r5]
    bl printf

    add r5, r5, #4
    b print_stack_loop

print_stack_end:
    ldr r0, =stack_msg_end
    bl printf

    bx r11

pop_stack:
    pop {r0}

    b loop

pop_entire_stack:
    mov r5, sp

    b pop_entire_stack_loop

pop_entire_stack_loop:
    cmp sp, r7
    beq loop

    pop {r0}

    b pop_entire_stack_loop

// -- exit --

pgm_exit:
    mov r0, #0
    bl exit

.data
    input_fmt: .asciz ">> "
    
    welcome_msg: .asciz ">> Insert commands (numbers, +, -, *, q, c, a) to calculate: \n"

    result_msg: .asciz ">> Result: %i \n"

    print_stack_msg: .asciz "%i "
    
    error_non_existant_command_msg: .asciz ">> Please enter a proper integer or command (+, -, *, q, c, a)\n"

    error_not_enough_in_stack_msg: .asciz ">> Error: Not enough integers in stack to perform operation \n"

    format_msg: .asciz "%i"

    stack_msg_begin: .asciz ">> Stack: [ "
    
    stack_msg_end: .asciz "]\n"

    myString: .space 100
    
    num: .word 0

