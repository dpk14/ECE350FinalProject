#initialize score 
#assume bird width to be 46
#assume bird height to be 34
#assume pipe width to be 58
#keep high score at memory address 0 

#800*480 resolution of screen



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
addi $r13, $r0, 175              #bird's y coord (top)
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
jal check_collision
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
addi $r1, $r0, 640 #if at end of screeen push pipe back 
add $r15, $r0, $r0 #clear r15 
sw $ra, 1($r0) #store address of old link
jal check_fall
lw $ra, 1($r0) #load address of old link
jr $ra 

button_pressed:
addi $r13, $r13, -25
add $r29, $r0, $r0
jr $ra


check_fall: 
addi $r16, $r0, 447 #use parameter to find position of bottom edge of bird (640-48=592)
sub $r17, $r16, $r13 #find bottom edge of bird starting from bottom (592-pixel from top)
blt $r0, $r17, 1 
j game_end
add $r16, $r0, $r0 #clear temp reg 
add $r17, $r0, $r0 #clear temp reg
jr $ra

check_collision: 
addi $r18, $r13, 34 #bottom edge of bird to reg 18 (from top) 
sub $r17, $r2, $r3 #bottom edge of top pipe 
blt  $r2, $r18, 2  #branch if below top of bottom pipe edge 
blt $r13, $r17, 1 #branch if above bottom edge of top pipe
jr $ra #jump back if not because collision not possible
add $r18, $r0, $r0
add $r17, $r0, $r0
add $r0, $r0, $r0 #collision is possible check left, right and midpoint
addi $r16, $r14, -23 #find midpoint of bird
addi $r15, $r14, -46 #find left edge of bird
addi $r19, $r1, 57 #find right edge of pipes
blt $r1, $r14, 3  #check if bird right edge is past left point
blt $r1, $r16, 3 #check if bird midpt is past left point
blt $r1, $r15, 3 #check if bird  left edge is past left point
jr $ra #if none of above conditions met jump back to game loop
blt  $r14, $r19, 3  #check if bird right edge is before pipe right point
blt  $r16, $r19, 2 #check if bird right edge is before pipe right point
blt  $r15, $r19, 1 #check if bird right edge is before pipe right point
jr $ra
j game_end

game_end: 

#clear any temp regs 
add $r15, $r0, $r0 #clear temp reg 
add $r16, $r0, $r0 #clear temp reg 
add $r17, $r0, $r0 #clear temp reg
add $r18, $r0, $r0 #clear temp reg 
add $r19, $r0, $r0 #clear temp reg 
add $r20, $r0, $r0 #clear temp reg
add $r21, $r0, $r0 #clear temp reg
j splash_init #jump back to initial state