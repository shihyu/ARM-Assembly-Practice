/* -- insertion_sort.s */
.data
message1: .asciz "Type 5 numbers: "
format:   .asciz "%d"
message2: .asciz "Sorted result: "
.balign 4
array: .skip 20 /* leave space for 5 integers*/

.text
 
insertion_sort:
    push {r4, lr}
    mov r1, #1  // check from a[1], r1 keeps the index of outer loop, 1 through 4
outer_loop:
    cmp r1, #5
    beq complete

    ldr r2, [r0,+r1, LSL #2]  // r2 keeps the current checked value
    mov r3, r1

inner_loop:
    cmp r3, #0
    beq inner_end
    sub r6, r3, #1
    ldr r5, [r0,+r6, LSL #2]
    cmp r2, r5
    bge inner_end
    str r5, [r0,+r3, LSL #2]
    sub r3, r3, #1
    b inner_loop
inner_end:
    add r1, r1, #1
    str r2, [r0, +r3, LSL #2]
    b outer_loop    

complete:

    pop {r4, lr}
    bx lr              /* Leave sort */

print_array: 
    push {r4, lr} 
    ldr r6, =array
    mov r5, #0                  /* r5 ← 0 */
loop:
    cmp r5, #20            /* Have we reached 5 yet? */
    beq end                /* If so, leave the loop, initialization finished */
    ldr r1, [r6, r5]  /* r1 ← r1 + (r2*4) */ 
    ldr r0, =format
    bl printf                    /* Call printf */
    add r5, r5, #4          /* r2 ← r2 + 1 */
    b loop                  /* Go to the beginning of the loop */
end:
    pop {r4, lr}
    bx lr              /* Leave print_array */



 
.globl main
main:
    str lr, [sp,#-4]!            /* Push lr onto the top of the stack */
    sub sp, sp, #4               /* Make room for an integer in the stack */
                                 /* In these 4 bytes we will keep the numbers */
                                 /* entered by the user each time*/
                                 /* Note that after that the stack is 8-byte aligned */
    ldr r0, address_of_message1  /* Set &message1 as the first parameter of printf */
    bl printf                    /* Call printf */

    
    mov r5, #0                  /* r2 ← 0 */ 
initialize_loop:
    cmp r5, #20            /* Have we reached 5 yet? */
    beq finished                 /* If so, leave the loop, initialization finished */
    ldr r0, =format    /* Set &format as the first parameter of scanf */
    ldr r6, =array
    add r6, r6, r5
    mov r1, r6
                                 /* of scanf */
    bl scanf                     /* Call scanf */
    add r5, r5, #4          /* r2 ← r2 + 1 */
    b initialize_loop                  /* Go to the beginning of the loop */
finished:

    ldr r0, =array       /* Load the base address of array into r0 */
    bl print_array                 /* Call print_array */
 
    ldr r0, =array
    bl insertion_sort

    ldr r0, address_of_message2  /* Set &message2 as the first parameter of printf */
    bl printf                    /* Call printf */

    ldr r0, =array  /* Set &message2 as the first parameter of print_array */
    bl print_array                    /* Call print_array */
 
 
    add sp, sp, #+4              /* Discard the integer read by scanf */
    ldr lr, [sp], #+4            /* Pop the top of the stack and put it in lr */
    bx lr                        /* Leave main */
 
address_of_message1: .word message1
address_of_message2: .word message2

