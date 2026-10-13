 #This program will calculate the expression A = (B / C + D Mod B - C) without using div
.text
	li $v0, 4
	la $a0, text
	syscall
	
	la $a0, newLine
	syscall
	
	la $a0, inputB
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0 #putting input b to register t1
	
	li $v0, 4
	la $a0, inputC
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0 #putting input c to register t2
	
	li $v0, 4
	la $a0, inputD
	syscall
	
	li $v0, 5
	syscall
	move $t3, $v0 #putting input d to register t3
	
	move $t4, $t1
	
	#finding B/C by constantly subtracting B from C and incrementing the count ($t5)
	div1:
		sub $t4,$t4,$t2
		addi $t5 ,$t5,1
		bgt $t4, $t2, div1
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		move $t4, $t3
	#finding D mod B by constantly subtracting D from B and finally looking at the last version of D ($t4)	
	modOperation:
	 	sub $t4,$t4,$t1
		bgt $t4, $t1, modOperation
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		add $t5,$t5,$t4
		sub $t5,$t5,$t2
	#finding (B/C + D mod B - C)/B by constantly subtracting the expression from B and incrementing the count ($t6)
	div2:
		add $t6, $zero, $zero
		sub $t5,$t5,$t1
		addi $t6 ,$t6,1 #final result will be loaded to register t6
		bgt $t5, $t1, div2
		
		li $v0, 4
		la $a0, newLine
		syscall
	
	li $v0, 4
	la $a0, resultA
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	move $a0,$t6
	li $v0,1
	syscall
	
	li $v0, 10
	syscall
.data
	text: .asciiz "You'll enter 3 integer values."
	resultText: .asciiz "The result is: "
	inputB: .asciiz "B input: "
	inputC: .asciiz "C input: "
	inputD: .asciiz "D input "
	resultA: .asciiz "The calculation A = (B / C + D Mod B - C)"
	newLine: .asciiz "\n"
