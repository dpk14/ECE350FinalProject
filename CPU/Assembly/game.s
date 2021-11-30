splash_init:
add $r29, $r0, $r0
lw $r27, 0($r0) #find high score
addi $r1, $r0, 0              #pipe 1 x left edge
addi $r2, $r0, 0              #pipe 1 y center
addi $r3, $r0, 0              #pipe 1 y gap height
addi $r4, $r0, 0              #pipe 2 x left edge
addi $r5, $r0, 0              #pipe 2 y center
addi $r6, $r0, 0              #pipe 2 y gap height
addi $r7, $r0, 0              #pipe 3 x left edge
addi $r8, $r0, 0              #pipe 3 y center
addi $r9, $r0, 0              #pipe 3 y gap height
addi $r10, $r0, 0             #pipe 4 x left edge
addi $r11, $r0, 0             #pipe 4 y center
addi $r12, $r0, 0             #pipe 4 y gap height
addi $r13, $r0, 0              #bird's y coord (top)
addi $r14, $r0, 0 #bird's (right) x coord
addi $r26, $r0, 0

splash_loop:
bne $r29, $r0, 1
j splash_loop
j game_init

game_init:
addi $r1, $r0, 200              #pipe 1 x left edge
addi $r2, $r0, 340              #pipe 1 y center
addi $r3, $r0, 200              #pipe 1 y gap height
addi $r4, $r0, 340              #pipe 2 x left edge
addi $r5, $r0, 300              #pipe 2 y center
addi $r6, $r0, 150              #pipe 2 y gap height
addi $r7, $r0, 480              #pipe 3 x left edge
addi $r8, $r0, 340              #pipe 3 y center
addi $r9, $r0, 200              #pipe 3 y gap height
addi $r10, $r0, 620             #pipe 4 x left edge
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
jal check_collisions
jal move_items
bne $r29, $r0, 1 #see if button is pressed- if it has been then skip j game loop and update bird position
j game_loop
jal button_pressed
j game_loop

move_items:
addi $r23, $r23, 1  #update total count of game frame
sub $r1, $r1, $r22 #update position of pipe 1
sub $r4, $r4, $r22 #update position of pipe 2
sub $r7, $r7, $r22 #update position of pipe 3
sub $r10, $r10, $r22 #update position of pipe 4
addi $r13, $r13, 2 #update bird position
add $r28, $r0, $r0 #(clear reg 28)
addi $r15, $r1, 75 #store pipe 1 right edge in r15
bne $r15, $r0, 1 # if pipe 1 right edge not at end of screen ignore next instruction
addi $r1, $r0, 640 #if pipe 1 at end of screeen push pipe back
addi $r15, $r4, 75 #store pipe 2 right edge in r15
bne $r15, $r0, 1 # if right edge not at end of screen ignore next instruction
addi $r4, $r0, 640 #if pipe 2 at end of screeen push pipe back
addi $r15, $r7, 75 #store pipe 3 right edge in r15
bne $r15, $r0, 1 # if right edge not at end of screen ignore next instruction
addi $r7, $r0, 640 #if pipe 3 at end of screeen push pipe back
addi $r15, $r10, 75 #store pipe 3 right edge in r15
bne $r15, $r0, 1 # if right edge not at end of screen ignore next instruction
addi $r10, $r0, 640 #if pipe 3 at end of screeen push pipe back
add $r15, $r0, $r0 #clear r15

sw $ra, 1($r0) #store address of old link
jal check_fall
lw $ra, 1($r0) #load address of old link
jr $ra

button_pressed:
addi $r13, $r13, -20
add $r29, $r0, $r0
jr $ra

#check_top:
#blt $r13, $r0, 1
#jr $ra
#j game_end


check_fall:
addi $r16, $r0, 447 #use parameter to find position of bottom edge of bird (640-48=592)
sub $r17, $r16, $r13 #find bottom edge of bird starting from bottom (592-pixel from top)
blt $r0, $r17, 1
j game_end
add $r16, $r0, $r0 #clear temp reg
add $r17, $r0, $r0 #clear temp reg
jr $ra

check_collisions:
sw $ra, 1($r0)
jal check_collision1
jal check_collision2
jal check_collision3
jal check_collision4
lw $ra, 1($r0)
jr $ra


check_collision1:
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

check_collision2:
addi $r18, $r13, 34 #bottom edge of bird to reg 18 (from top)
sub $r17, $r5, $r6 #bottom edge of top pipe
blt  $r5, $r18, 2  #branch if below top of bottom pipe edge
blt $r13, $r17, 1 #branch if above bottom edge of top pipe
jr $ra #jump back if not because collision not possible
add $r18, $r0, $r0
add $r17, $r0, $r0
add $r0, $r0, $r0 #collision is possible check left, right and midpoint
addi $r16, $r14, -23 #find midpoint of bird
addi $r15, $r14, -46 #find left edge of bird
addi $r19, $r4, 57 #find right edge of pipes
blt $r4, $r14, 3  #check if bird right edge is past left point
blt $r4, $r16, 3 #check if bird midpt is past left point
blt $r4, $r15, 3 #check if bird  left edge is past left point
jr $ra #if none of above conditions met jump back to game loop
blt  $r14, $r19, 3  #check if bird right edge is before pipe right point
blt  $r16, $r19, 2 #check if bird right edge is before pipe right point
blt  $r15, $r19, 1 #check if bird right edge is before pipe right point
jr $ra
j game_end

check_collision3:
addi $r18, $r13, 34 #bottom edge of bird to reg 18 (from top)
sub $r17, $r8, $r9 #bottom edge of top pipe
blt  $r8, $r18, 2  #branch if below top of bottom pipe edge
blt $r13, $r17, 1 #branch if above bottom edge of top pipe
jr $ra #jump back if not because collision not possible
add $r18, $r0, $r0
add $r17, $r0, $r0
add $r0, $r0, $r0 #collision is possible check left, right and midpoint
addi $r16, $r14, -23 #find midpoint of bird
addi $r15, $r14, -46 #find left edge of bird
addi $r19, $r7, 57 #find right edge of pipes
blt $r7, $r14, 3  #check if bird right edge is past left point
blt $r7, $r16, 3 #check if bird midpt is past left point
blt $r7, $r15, 3 #check if bird  left edge is past left point
jr $ra #if none of above conditions met jump back to game loop
blt  $r14, $r19, 3  #check if bird right edge is before pipe right point
blt  $r16, $r19, 2 #check if bird right edge is before pipe right point
blt  $r15, $r19, 1 #check if bird right edge is before pipe right point
jr $ra
j game_end

check_collision4:
addi $r18, $r13, 34 #bottom edge of bird to reg 18 (from top)
sub $r17, $r11, $r12 #bottom edge of top pipe
blt  $r11, $r18, 2  #branch if below top of bottom pipe edge
blt $r13, $r17, 1 #branch if above bottom edge of top pipe
jr $ra #jump back if not because collision not possible
add $r18, $r0, $r0
add $r17, $r0, $r0
add $r0, $r0, $r0 #collision is possible check left, right and midpoint
addi $r16, $r14, -23 #find midpoint of bird
addi $r15, $r14, -46 #find left edge of bird
addi $r19, $r10, 57 #find right edge of pipes
blt $r10, $r14, 3  #check if bird right edge is past left point
blt $r10, $r16, 3 #check if bird midpt is past left point
blt $r10, $r15, 3 #check if bird  left edge is past left point
jr $ra #if none of above conditions met jump back to game loop
blt  $r14, $r19, 3  #check if bird right edge is before pipe right point
blt  $r16, $r19, 2 #check if bird right edge is before pipe right point
blt  $r15, $r19, 1 #check if bird right edge is before pipe right point
jr $ra
j game_end


game_end:

add $r15, $r0, $r0 #clear temp reg
add $r16, $r0, $r0 #clear temp reg
add $r17, $r0, $r0 #clear temp reg
add $r18, $r0, $r0 #clear temp reg
add $r19, $r0, $r0 #clear temp reg
add $r20, $r0, $r0 #clear temp reg
add $r21, $r0, $r0 #clear temp reg
j splash_init #jump back to initial state
