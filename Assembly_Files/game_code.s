init: 
#initialize score 
addi $r26, $r26,0
#bird's x coord
addi $r23, $r1, 120
#bird's y coord 
addi $r24, $r2, 320
#bird's width
addi $r22, r22, 20
#bird's height
addi $r22, r22, 10

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
blt $r23, $r1, cond1_met
jr $ra
cond1_met:
#assume pipe top edge coord is stored in reg 2
blt $r24, $r2, cond2_met
jr $ra
conda2_met:
j end_game


#if collsion occurs end game 
end_game: 