	.data
msg1:	.asciiz "What is your name?"
msg2:	.asciiz "When were you born?"
msg3:	.asciiz "Who is your father?"
msg4:	.asciiz "Are you still alive?"
msg5:	.asciiz "Are you a ghost?"

anw1:	.asciiz "My name is ENIAC\n"
anw2:	.asciiz "I was born in 1946\n"
anw3:	.asciiz "My father is Professor Mauchly\n"
anw4:	.asciiz "No, I died in 1955\n"
anw5:	.asciiz "...what do you think?\n"

	.text
main: 
	sub $sp, $sp, 500
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	add $fp, $sp, 496
	
	li $t8, 0xffff0000	#control register
	li $t9, 0xffff0004	#what we're reading in
	li $t7, 0x2		#load in value of 2
	sw $t7, 0($t8)		#store value in control register - we're ready to read in keyboard
	addi $t1, $sp, 6	#store starting location, should be in s register
	
beforeLoop:
	addi $t0, $sp, 6	#set place in memory to store user input, should also be in s register
	move $t8, $zero		#reset $t8
	
loop:	
	beq $t8, 0xA, newLineEntered	#idle loop, waiting for new line to be entered
	j loop

newLineEntered:
	la $a0, msg1
	move $a1, $t1 
	jal checksame
	bgtz $v0, printanw1
	
	la $a0, msg2
	move $a1, $t1 
	jal checksame
	bgtz $v0, printanw2
	
	la $a0, msg3
	move $a1, $t1 
	jal checksame
	bgtz $v0, printanw3
	
	la $a0, msg4
	move $a1, $t1 
	jal checksame
	bgtz $v0, printanw4
	
	la $a0, msg5
	move $a1, $t1 
	jal checksame
	bgtz $v0, printanw5
	
	b beforeLoop

printanw1:
	li $t3, 0xffff0008 	#control register of display device
	li $t4, 0xffff000c	#actual data to display device
	move $t5, $zero
loop1:
	lw $t6, 0($t3)		#load to see if it's ready to print or not
	andi $t6, $t6, 0x1	#gives 0 or 1
	beqz $t6, loop1		#if it's equal to zero, we gotta' wait
	lb $t7, anw1($t5)
	beqz $t7, beforeLoop		#if null character, break loop
	sb $t7, 0($t4)
	addi $t5, $t5, 1
	b loop1

printanw2:
	li $t3, 0xffff0008 	#control register of display device
	li $t4, 0xffff000c	#actual data to display device
	move $t5, $zero
loop2:	
	lw $t6, 0($t3)		#load to see if it's ready to print or not
	andi $t6, $t6, 0x1	#gives 0 or 1
	beqz $t6, loop2		#if it's equal to zero, we gotta' wait
	lb $t7, anw2($t5)
	beqz $t7, beforeLoop		#if null character, break loop
	sb $t7, 0($t4)
	addi $t5, $t5, 1
	b loop2
	
printanw3:
	li $t3, 0xffff0008 	#control register of display device
	li $t4, 0xffff000c	#actual data to display device
	move $t5, $zero
loop3:
	lw $t6, 0($t3)		#load to see if it's ready to print or not
	andi $t6, $t6, 0x1	#gives 0 or 1
	beqz $t6, loop3		#if it's equal to zero, we gotta' wait
	lb $t7, anw3($t5)
	beqz $t7, beforeLoop		#if null character, break loop
	sb $t7, 0($t4)
	addi $t5, $t5, 1
	b loop3

printanw4:
	li $t3, 0xffff0008 	#control register of display device
	li $t4, 0xffff000c	#actual data to display device
	move $t5, $zero
loop4:
	lw $t6, 0($t3)		#load to see if it's ready to print or not
	andi $t6, $t6, 0x1	#gives 0 or 1
	beqz $t6, loop4		#if it's equal to zero, we gotta' wait
	lb $t7, anw4($t5)
	beqz $t7, beforeLoop		#if null character, break loop
	sb $t7, 0($t4)
	addi $t5, $t5, 1
	b loop4

printanw5:
	li $t3, 0xffff0008 	#control register of display device
	li $t4, 0xffff000c	#actual data to display device
	move $t5, $zero
loop5:
	lw $t6, 0($t3)		#load to see if it's ready to print or not
	andi $t6, $t6, 0x1	#gives 0 or 1
	beqz $t6, loop5		#if it's equal to zero, we gotta' wait
	lb $t7, anw5($t5)
	beqz $t7, beforeLoop		#if null character, break loop
	sb $t7, 0($t4)
	addi $t5, $t5, 1
	b loop5
	
end:	
	lw $fp, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 500						
				
checksame:			#should return something that indicates a match
	subi $sp, $sp, 100
	sw $ra, 0($sp)
	sw $fp, 4($sp)
	addi $fp, $sp, 96
	li $t3, 15		#just check the first 15 chars
	
	move $t4, $a0 
	move $t5, $a1
checkloop:	
	lb $t6, 0($t4)
	lb $t7, 0($t5)
	
	beq $t6, $t7, increment
	j notsame
	
increment:
	addi $t4, $t4, 1
	addi $t5, $t5, 1
	subi $t3, $t3, 1
	beqz $t3, same
	j checkloop

same: 
	li $v0, 1
	j endfunction

notsame:
	li $v0, 0
	j endfunction
	
endfunction:
	lw $ra, 0($sp)
	lw $fp, 4($sp)
	addi $sp, $sp, 100
	jr $ra
	
	
	.ktext 0x80000180
	li $t9, 0xffff0004
	lb $t8, ($t9)
	sb $t8, ($t0)		#store keyboard input into stack
	addi $t0, $t0, 1	#increase place in stack
	
	mfc0 $k0,$14   		# Coprocessor 0 register $14 has address of trapping instruction
  	#addi $k0,$k0,4		# Add 4 to point to next instruction
  	mtc0 $k0,$14   		# Store new address back into $14
   	eret           		# Error return; set PC to value in $14


