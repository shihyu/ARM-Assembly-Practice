/* -- rec_sum.s */
.data
message1: .asciz "Type 5 numbers: "
format:   .asciz "%d"
message2: .asciz "The sum is:%d"
.balign 4
array: .skip 20 /* leave space for 5 integers*/

.text
 
rec_sum:
    push {r4, lr}
    ldr r2, [r0, r1, LSL #2]
    str r2, [sp,#-4]!  /* Push r0 onto the top of the stack */
                       /* Note that after that, sp is 8 byte aligned */
                       /* r1 is the index */
    cmp r1, #5         /* compare r1 and 5 */
    bne recurse
    mov r0, #0
    b base     /* if r1 != 5 then branch */
recurse:
                       /* Prepare the call to recurse(r1+1) */
    add r1, r1, #1     /* r1 ← r1 + 1 */
    bl rec_sum
                       /* After the call r0 contains factorial(n-1) */
                       /* Load r0 (that we kept in th stack) into r1 */
    ldr r2, [sp]       /* r2 ← *sp */
    add r0, r0, r2     /* r0 ← r0 * r2 */
    
 
base:
    add sp, sp, #4
    pop {r4, lr}
    bx lr              /* Leave rec_sum */

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

/*    ldr r0, =array       
    bl print_array
*/

    ldr r0, =array
    mov r1, #0
    bl rec_sum

    mov r1, r0
    ldr r0, address_of_message2  /* Set &message2 as the first parameter of printf */
    bl printf                    /* Call printf */
 
    add sp, sp, #+4              /* Discard the integer read by scanf */
    ldr lr, [sp], #+4            /* Pop the top of the stack and put it in lr */
    bx lr                        /* Leave main */
 
address_of_message1: .word message1
address_of_message2: .word message2

