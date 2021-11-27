init: 
#initialize score 
#assume bird width to be 20
#assume bird height to be 10


addi $r26, $r26, 0 #initialize game score to 0
addi $r6, $r0, 120 #bird's (mid) x coord
addi $r5, $r0, 325 #bird's y coord (top- 320+5)

addi $r21, $r0, 10 #r21 scores vertical height gained by bird on jump
addi $r22, $r0, 1 #r22 store speed of incoming pipe
addi $r23, $r0,0 #r23 stores how many game rates we've gone through 
addi $r24, $r0, 500 #$r24 stores number of game loops to go through before updating difficulty


game_loop:
#check if button pressed
jal check_collision #check if collision occurred
bne $r29, $r0, 1
bne $r28, $r0, 1
jal button_pressed
jal move_barriers #check if need to update screen 
j game_loop

move_barriers: #update pipe position (may have to tweak addi parameter to see how fast pipe moves)
addi $r23,$r23,1  #update total count of game frame 
addi $r26, $r26, 1 #update score
bne $r24, $r23, 3 #if equal then we update speed at which pipes move and clear r10
addi $r22, $r22,1
sub $r23, $r23, $r23
jr $ra

check_collision:  #just checking pipe 1 for now 
addi $r23, $r6, 5
blt $r23, $r1, cond1_met
jr $ra
cond1_met:
#assume pipe left edge coord is stored in reg 1
addi $r22, $r1, 25
blt $r23, $r22, cond2_met
jr $ra
cond2_met:
#assume pipe top edge coord is stored in reg 2
add $r21, $r5, -10
blt $r21, $r2, cond3_met
jr $ra
cond3_met:
j end_game


button_pressed:
addi $r5, $r5, $r20
jr $ra

#if collsion occurs end game 
end_game: 
sub $r25, $r25, $r25 #clears game underway register to indicate game is over 

#clear rest of regs 
 
#see if score>high score
#if >high score store new score in data memory address 
#clear all registers