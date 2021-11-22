init: 
#initialize score 
#assume bird width to be 20
#assume bird height to be 10
addi $r26, $r26, 0
#bird's x coord
addi $r6, $r0, 120
#bird's y coord (top)
addi $r5, $r0, 325 (320+5)


game_loop:

#check if button pressed

#check if collision occurred
jal check_collision
#if no collision run back to game_loop

#update pipe position (may have to tweak addi parameter to see how fast pipe moves)E
addi $r1, $r1, -1
j game_loop

check_collision: 
#assume pipe left edge coord is stored in reg 1
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


#if collsion occurs end game 
end_game: 