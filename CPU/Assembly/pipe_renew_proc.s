pipe_renew_procedure_1: 
addi $r15, $r1, 75 #store pipe 1 right edge in r15
bne $r15, $r0, 1 # if pipe 1 right edge not at end of screen ignore next instruction
addi $r1, $r0, 640 #if pipe 1 at end of screeen push pipe back 


lw $r2, 10($r21)
addi $r21, $r21, 1
lw $r3, 10($r21)
addi $r21, $r21, 1
addi $r15, $r0, 15
blt $r15, $r21, 1
addi $r21, $r0, 8
add $r15, $r15, $r0
jr $ra


