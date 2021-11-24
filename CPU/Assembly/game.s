nop # Flappy bird assembly code
nop
nop # Author: Jason + Daniel
nop
nop
nop
init:
addi $r26, $r26, 0              #initialize game score to 0
addi $r1, $r0, 419922120
addi $r2, $r0, 629432620
addi $r3, $r0, 839557520
addi $r4, $r0, 1049067820
addi $r5, $r0, 325              #bird's y coord (top)
addi $r8, $r0, 1                #r8 store speed of incoming pipe
addi $r9, $r0, 10               #r9 scores vertical height gained by bird on jump
addi $r10, $r0, 0               #r10 stores how many game rates we've gone through
addi $r11, $r0, 100000          #$r11 stores number of game loops to go through before updating difficulty