init: 
#initialize score 
#assume bird width to be 20
#assume bird height to be 10
#assume pipe width to be 25
#keep high score at memory address 1000


addi $r19, $r0, 130 #bird's (right) x coord (120+10)
addi $r20, $r0, 325 #bird's y coord (top- 320+5)

addi $r21, $r0, 10 #r21 scores vertical height gained by bird on jump
addi $r22, $r0, 1 #r22 store speed of incoming pipe
addi $r23, $r0,0 #r23 stores how many game rates we've gone through 
addi $r24, $r0, 500 #$r24 stores number of game loops to go through before updating difficulty
addi $r25, $r0, 1 #set game to be underway
addi $r26, $r0, 0 #initialize game score to 0
lw $r27, 1000($r0) #find high score

game_loop:
#check if button pressed
jal check_collision #check if collision occurred
bne $r29, $r0, 1 #check if flappy should jump
jal button_pressed
bne $r28, $r0, 1 #check if frame should be updated
jal move_barriers #check if need to update screen 
j game_loop

move_barriers: #update pipe position (may have to tweak addi parameter to see how fast pipe moves)
addi $r23,$r23,1  #update total count of game frame 
addi $r26, $r26, 1 #update score
bne $r24, $r23, 3 #if equal then we update speed at which pipes move and clear r10
addi $r22, $r22,1
sub $r23, $r23, $r23
sub $r28, $r28, $r28 #clear frame reate register
jr $ra

check_collision:  #just checking pipe 1 for now 
addi $r18, $r20, -10 #set $r18 to temporarily be bottom edge of bird
add $r17, $r2, $r3, #set $r17 to temporarily be "height" of top pipe
blt $r18, $r2,2  #branch if bottom edge of bird is below top edge of pipe 
blt $r17, $r20, 1  #branch if top edge of bird is above top pipe height
jr $ra #between pipes can jump back as no collision is possible
add $r0, $r0, $r0 #collision is possible check left, right and midpoint
addi $r16, $r19, -10 #find midpoint of bird
addi $r15, $r19, -20 #find left edge of bird
addi $r14, $r1, 25 #find right edge of pipes
blt $r1, $r19, 3  #check if bird right edge is past left point
blt $r1, $r16, 3 #check if bird midpt is past left point
blt $r1, $r15, 3 #check if bird  left edge is past left point
jr $ra 3 #if none of above conditions met jump back to game loop
blt  $r19, $r14, 8  #check if bird right edge is before pipe right point
blt  $r16, $r14, 7 #check if bird right edge is before pipe right point
blt  $r15, $r14, 6 #check if bird right edge is before pipe right point
sub $r18, $r18, $r18 #clear temp registers
sub $r17, $r17, $r17
sub $r16, $r16, $r16
sub $r15, $r15, $r15
sub $r14, $r14, $r14
jr $ra
j end_game


button_pressed: #may need to introduce procedure to slowly update value of bird's y_coord
addi $r5, $r5, $r21
sub $r29, $r29, $r29 #clear button register
jr $ra

#if collsion occurs end game 
end_game: 
sub $r25, $r25, $r25 #clears game underway register to indicate game is over 

#see if score>high score
#if >high score store new score in data memory address 
#clear all registers

blt $r27, $r26, 1
sw $r26, 1000($r0)
add $r1, $r0, $r0 #clear rest of regs 
add $r2, $r0, $r0
add $r3, $r0, $r0
add $r4, $r0, $r0
add $r5, $r0, $r0
add $r6, $r0, $r0
add $r7, $r0, $r0
add $r8, $r0, $r0
add $r9, $r0, $r0
add $r10, $r0, $r0
add $r11, $r0, $r0
add $r12, $r0, $r0
add $r13, $r0, $r0
add $r14, $r0, $r0
add $r15, $r0, $r0
add $r16, $r0, $r0
add $r17, $r0, $r0
add $r18, $r0, $r0
add $r19, $r0, $r0
add $r20, $r0, $r0
add $r21, $r0, $r0
add $r22, $r0, $r0
add $r23, $r0, $r0
add $r24, $r0, $r0
add $r25, $r0, $r0
add $r26, $r0, $r0
add $r27, $r0, $r0
add $r28, $r0, $r0
add $r29, $r0, $r0
add $r30, $r0, $r0
add $r31, $r0, $r0