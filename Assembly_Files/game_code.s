init: 
# make the bird's width 20 
# make the bird's height 10 
#top edge in $r5

#initialize score 
addi $r26, $r26,0
#bird's x permanent coord (center)
addi $r6, $r0, 120
#bird's y starting top coord 
addi $r5, $r0, 325 #320+5


#initialize pipe values here 



game_loop:
#check if button pressed


#check if collision occurred
jal check_collision
#if no collision update to pipe parameters and jump back to game_loop

#update pipe position (may have to tweak addi parameter to see how fast pipe moves)E
addi $r1, $r1, -1
j game_loop

check_collision: 
#assume pipe left edge coord is stored in reg 1
#check if front end of bird is beyond front end of pipe
addi $r23, $r6, 10
blt $r23, $r1, cond1_met
jr $ra
cond1_met:
#check if front end of bird is in front of back end of pipe
addi $r23, $r6, -10
addi $r22, $r1, 25 #assume width of pipe is 25
blt $r23, $r22, cond2_met
jr $ra
cond2_met:
#assume pipe top edge coord is stored in reg 2
#check if bird is below top end of pipe
addi $r24, $r6, -10
blt $r24, $r2, cond3_met
jr $ra
cond3_met: 
j end_game


#if collsion occurs end game 
end_game: 