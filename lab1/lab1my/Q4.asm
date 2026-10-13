#comment
.text
	la $a0,prompt			# output prompt message on terminal
	li $v0,4			# syscall 4 prints the string
	syscall

	li $v0, 5			# syscall 5 reads an integer
	syscall

	move $t0,$v0
	move $s0,$t0
	la $t1, array
	
	j test
	next:
		li $v0, 5      		#read int
    		syscall 
    		sw $v0, ($t1)       	#store input in array
    		addi  $t0, $t0, -1   
    		addi $t1, $t1, 4 	#go to the next item address in the array
	test:
		bne $t0,$zero,next
	done:
		la $t1, array
		move $t0, $s0
	
	la $a0,arrayContents		# output prompt message on terminal
	li $v0,4			# syscall 4 prints the string
	syscall
	
	j testPrintDone
	nextForPrintArrayElements:
		lw $a0, 0($t1)		# Load value from array
		li $v0, 1		# Syscall 1 prints integer
		syscall
		
		la $a0, space
		li $v0, 4
		syscall

		addi  $t0, $t0, -1   
    		addi $t1, $t1, 4
	testPrintDone:
		bne $t0, $zero,nextForPrintArrayElements
	printDone:
		move $t0, $s0
		la $t1, array
	
	la $a0,newLine
	li $v0,4
	syscall
	
	menuOpened:
		la $a0,welcome
		li $v0,4
		syscall
	
		la $a0,userSelection
		li $v0,4
		syscall
	
		li $v0, 12
		syscall
		move $t2,$v0
		
		li $t4, 'a'
		beq $t2,$t4,selectA
		
		li $t4, 'b'
		beq $t2,$t4,selectB
		
		li $t4, 'c'
		beq $t2,$t4,selectC
		
		li $t4, 'd'
		beq $t2,$t4,selectD
		
		li $t4, 'e'
		beq $t2,$t4,selectE
	
		la $a0,newLine
		li $v0,4
		syscall
	selectA:
		add $t3, $zero,$zero
		findMax:
			addi $t0,$t0,-1
			lw $t5, 0($t1)
			addi $t1, $t1, 4
			bgt $t5,$t3,updateMax
			bne $t0,$zero,findMax
    			j doneMax
    			
		updateMax:
			move $t3, $t5
			bne $t0,$zero,findMax
		doneMax:
			move $t0, $s0
			la $t1,array
			move $s2, $t3

			
		la $a0,messageForA
		li $v0,4
		syscall
		
		move $a0,$t3
		li $v0,1
		syscall	
		
		la $a0,newLine
		li $v0,4
		syscall
		
		add $t3, $zero,$zero
		j doneOperations
		
	selectB:
	
	add $t3, $zero,$zero
		findMax2:
			addi $t0,$t0,-1
			lw $t5, 0($t1)
			addi $t1, $t1, 4
			bgt $t5,$t3,updateMax2
			bne $t0,$zero,findMax2
    			j doneMax2
    			
		updateMax2:
			move $t3, $t5
			bne $t0,$zero,findMax2
		doneMax2:
			move $t0, $s0
			la $t1,array
			move $s2, $t3

			
		la $a0,messageForA
		li $v0,4
		syscall
		
		move $a0,$t3
		li $v0,1
		syscall	
		
		la $a0,newLine
		li $v0,4
		syscall
		
		add $t3, $zero,$zero
		countMax:
			addi  $t0, $t0, -1
			lw $t4, 0($t1)
			addi $t1, $t1, 4
			beq $t4,$s2,testAndUpdateCount
    			bne $t0,$zero,countMax
    			j countDone
		testAndUpdateCount:
		    	addi $t3,$t3,1
			bne $t0, $zero,countMax
		countDone:
			move $t0, $s0
			la $t1, array
			
		la $a0,messageForB
		li $v0,4
		syscall
		
		move $a0,$t3
		li $v0,1
		syscall
		
		la $a0,newLine
		li $v0,4
		syscall
		
		add $t3, $zero,$zero
		j doneOperations
	selectC:
    li $t3, 0
    move $t0, $s0
    la $t1, array

findSum:
    lw $t5, 0($t1)
    add $t3, $t3, $t5
    addi $t1, $t1, 4
    addi $t0, $t0, -1
    bne $t0, $zero, findSum

doneSum:
    move $t0, $s0
    beq $t0, $zero, zeroCaseC

    div $t3, $t0
    mflo $t5
    move $s3, $t5

    j displayAverageC

zeroCaseC:
    li $t5, 0

displayAverageC:
    la $a0, messageForC
    li $v0, 4
    syscall

    move $a0, $t5
    li $v0, 1
    syscall

    la $a0, newLine
    li $v0, 4
    syscall

    j doneOperations

selectD:
    li $t3, 0
    move $t0, $s0
    la $t1, array

findSum1:
    lw $t5, 0($t1)
    add $t3, $t3, $t5
    addi $t1, $t1, 4
    addi $t0, $t0, -1
    bne $t0, $zero, findSum1

doneSum1:
    move $t0, $s0
    beq $t0, $zero, zeroCaseD

    div $t3, $t0
    mflo $t5
    move $s3, $t5

    j countSmallerGreater

zeroCaseD:
    li $s3, 0

countSmallerGreater:
    li $t6, 0
    li $t3, 0
    move $t0, $s0
    la $t1, array

functionD:
    lw $t5, 0($t1)
    addi $t1, $t1, 4
    blt $t5, $s3, smallerThanAvrg
    bgt $t5, $s3, greaterThanAvrg
    addi $t0, $t0, -1
    bne $t0, $zero, functionD
    j doneFunctionD

smallerThanAvrg:
    addi $t6, $t6, 1
    j continueLoop

greaterThanAvrg:
    addi $t3, $t3, 1

continueLoop:
    addi $t0, $t0, -1
    bne $t0, $zero, functionD

doneFunctionD:
    move $t0, $s0
    la $t1, array

    la $a0, messageForDsmaller
    li $v0, 4
    syscall

    move $a0, $t6
    li $v0, 1
    syscall

    la $a0, newLine
    li $v0, 4
    syscall

    la $a0, messageForDgreater
    li $v0, 4
    syscall

    move $a0, $t3
    li $v0, 1
    syscall

    la $a0, newLine
    li $v0, 4
    syscall

    j doneOperations


	doneOperations:
		j menuOpened
		
	selectE:
		li $v0,10
		syscall
#data segment
.data
	.align 4
	array: .space 400
	prompt:	.asciiz "Enter array size: "
	messageForA: .asciiz "The greatest element in the array is : "
	messageForB: .asciiz "The number of times the maximum number appears in the array : "
	messageForC: .asciiz "Average value of the array elements: "
	messageForDsmaller:.asciiz "The number of array elements smaller than the average value: "
	messageForDgreater:.asciiz "The number of array elements greater than the average value: "
	welcome: .asciiz "Welcome to Simple Array Application\n a. Find the maximum number stored in the array and display that number.\n b. Find and display the number of times the maximum number appears in the array.\n c. Find and display the average value of the array elements.\n d. Find the number of array elements smaller than the average value and also find the number of array element greater than the average value. Display both.\n e. Quit. \n"
	newLine: .asciiz "\n"
	userSelection: .asciiz "Please select one of these provided operations: "
	space: .asciiz " "
	arrayContents: .asciiz "Array Elements are: "
