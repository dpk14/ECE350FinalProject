nop # Flappy bird assembly code
nop
nop # Author: Jason + Daniel
nop
nop
nop

init:
addi $r26, $r26, 0              #initialize game score to 0
addi $r1, $r0, 120              #pipe 1 x left edge
addi $r2, $r0, 190              #pipe 1 y bottom pipe top
addi $r3, $r0, 100              #pipe 1 y gap height
addi $r4, $r0, 270              #pipe 2 x left edge
addi $r5, $r0, 340              #pipe 2 y bottom pipe top
addi $r6, $r0, 150              #pipe 2 y gap height
addi $r7, $r0, 420              #pipe 3 x left edge
addi $r8, $r0, 340              #pipe 3 y bottom pipe top
addi $r9, $r0, 200              #pipe 3 y gap height
addi $r10, $r0, 570             #pipe 4 x left edge
addi $r11, $r0, 240             #pipe 4 y bottom pipe top
addi $r12, $r0, 150             #pipe 4 y gap height
addi $r13, $r0, 325              #bird's y coord (top)
addi $r14, $r0, 1                #r8 store speed of incoming pipe
addi $r15, $r0, 10               #r9 scores vertical height gained by bird on jump
addi $r16, $r0, 0               #r10 stores how many game rates we've gone through
addi $r17, $r0, 100000          #$r11 stores number of game loops to go through before updating difficulty

game_loop:
nop
j game_loop