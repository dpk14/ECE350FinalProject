#initialize score 
#assume bird width to be 34
#assume bird height to be 48
#assume pipe width to be 58
#keep high score at memory address 0

#initialize score 
#assume bird width to be 34
#assume bird height to be 48
#assume pipe width to be 58
#keep high score at memory address 0

splash_init: 
lw $r27, 0($r0) ##just initilize everything to be still for now 
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
addi $r13, $r0, 125              #bird's y coord (top)
addi $r14, $r0, 94 #bird's (right) x coord 
addi $r22, $r0, 1 #r22 store speed of incoming pipe
addi $r23, $r0, 0 #r23 stores how many game rates we've gone through 
addi $r24, $r0, 3600 #$r24 stores number of game loops to go through before updating difficulty
addi $r25, $r0, 1 #set game to be underway
addi $r26, $r0, 0 #initialize game score to 0
#end of initialization

bne $r29, $r0, 1
j splash_init
j game_init

game_init:
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
addi $r13, $r0, 125              #bird's y coord (top)
addi $r14, $r0, 94 #bird's (right) x coord 
addi $r22, $r0, 1 #r22 store speed of incoming pipe
addi $r23, $r0, 0 #r23 stores how many game rates we've gone through 
addi $r24, $r0, 3600 #$r24 stores number of game loops to go through before updating difficulty
addi $r25, $r0, 1 #set game to be underway
addi $r26, $r0, 0 #initialize game score to 0

game_loop:
bne $r28, $r0, 1 #branch to move barrier instrutions if interrupt
j game_loop
jal move_items 
bne $r29, $r0, 1 #see if button is pressed- if it has been then skip j game loop and update bird position
j game_loop
jal button_pressed
j game_loop

move_items:
addi $r23, $r23, 1  #update total count of game frame 
addi $r26, $r26, 1 #update score
sub $r1, $r1, $r22 #update position of pipe
addi $r13, $r13, 2 #update bird position 
add $r28, $r0, $r0 #(clear reg 28)
addi $r15, $r1, 75 #store right edge in r15
bne $r15, $r0, 1 # if right edge not at end of screen ignore next instruction
addi $r1, $r0, 600 #if at end of screeen push pipe back 
add $r15, $r0, $r0 #clear r15 
jr $ra 

button_pressed:
addi $r13, $r13, -25
add $r29, $r0, $r0
jr $ra