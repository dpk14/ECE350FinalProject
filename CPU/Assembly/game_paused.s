addi $r10, $r0, 570             #pipe 4 x left edge
addi $r11, $r0, 240             #pipe 4 y center
addi $r12, $r0, 150             #pipe 4 y gap height
addi $r13, $r0, 125              #bird's y coord (top)
addi $r14, $r0, 94 #bird's (right) x coord 
addi $r22, $r0, 1 #r22 store speed of incoming pipe
addi $r23, $r0, 0 #r23 stores how many game rates we've gone through 
addi $r24, $r0, 50000 #$r24 stores number of game loops to go through before updating difficulty
addi $r25, $r0, 1 #set game to be underway
addi $r26, $r0, 0 #initialize game score to 0


game_loop:
bne $r28, $r0, 1 #branch to move barrier instrutions if interrupt
j game_loop
j move_items 

move_items:
addi $r23, $r23, 1  #update total count of game frame 
addi $r26, $r26, 1 #update score
sub $r1, $r1, $r22 #update position of pipe
addi $r13, $r13, 1 #update bird position 
add $r28, $r0, $r0 #(clear reg 28)
addi $r15, $r1, 75 #store right edge in r15
bne $r15, $r0, 1 # if right edge not at end of screen ignore next instruction
addi $r1, $r0, 580 #if at end of screeen push pipe back 
add $r15, $r0, $r0 #clear r15 
bne $r29, $r0, 1 #see if button is pressed- if it has been then skip j game loop and update bird position
j game_loop
addi $r13, $r13, -10
add $r29, $r0, $r0
j game_loop