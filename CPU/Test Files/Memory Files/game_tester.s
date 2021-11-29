init:
addi $r1, $r0, 240              #pipe 1 x left edge
addi $r2, $r0, 340              #pipe 1 y center
addi $r3, $r0, 200              #pipe 1 y gap height
addi $r4, $r0, 270              #pipe 2 x left edge
addi $r5, $r0, 140              #pipe 2 y center
addi $r6, $r0, 150              #pipe 2 y gap height
addi $r7, $r0, 420              #pipe 3 x left edge
addi $r8, $r0, 340              #pipe 3 y center
addi $r9, $r0, 200              #pipe 3 y gap height
addi $r10, $r0, 570             #pipe 4 x left edge
addi $r11, $r0, 240             #pipe 4 y center
addi $r12, $r0, 150             #pipe 4 y gap height
addi $r13, $r0, 325              #bird's y coord (top)
addi $r14, $r0, 94 #bird's (right) x coord 
addi $r21, $r0, 10 #r21 scores vertical height gained by bird on jump
addi $r22, $r0, 1 #r22 store speed of incoming pipe
addi $r23, $r0, 0 #r23 stores how many frames we've gone through 
addi $r24, $r0, 500 #$r24 stores number of game loops to go through before updating difficulty
addi $r25, $r0, 1 #set game to be underway
addi $r26, $r0, 0 #initialize game score to 0
lw $r27, 0($r0) #find high score

addi $r20, $r0, 10



game_loop:
addi $r15, $r15, 1 #update game loop counter
bne $r20, $r15, 6 #jump back to game loop if there is no interrupt
addi $r23, $r23, 1  #update total count of game frame 
addi $r26, $r26, 1 #update score
sub $r1, $r1, $r22 #update position of pipe
add $r15, $r0, $r0 #clear game loop register
bne $r1, $r0, 1 # if not at end of screen ignore next instruction
addi $r1, $r0, 580 #if at end of screeen push pipe back 
j game_loop
add $r0, $r0, $r0
add $r0, $r0, $r0
add $r0, $r0, $r0