#This program generates odd even linked lists of given input list
.text
	
	la $a0, nodeNumberPrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s0, $zero, $v0 #number of nodes in s0
	
	add $a0, $zero, $s0 #create a linked list with user input number nodes
	jal createLinkedList
	
	add $a0, $zero, $v0
	add $s7, $zero ,$v0
	jal printLinkedList
	
	add $a0, $zero, $s7
	jal evenList
	
	add $s6, $zero, $v0
	la $a0, printingEvens
	li $v0, 4
	syscall
	
	add $a0, $zero, $s6
	jal printLinkedList
	
	add $a0, $zero, $s7
	jal oddList
	
	add $s5, $zero, $v0
	la $a0, printingOdds
	li $v0, 4
	syscall
	
	add $a0, $zero, $s5
	jal printLinkedList
	
	li $v0, 10
	syscall
	
createLinkedList:
	addi $sp, $sp, -28
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	add $s0, $a0, $zero
	li $s1, 1	
	
	li $a0, 12
	li $v0, 9
	syscall
	
	add $s2, $v0, $zero	# $s2 points to the first and last node of the linked list.
	add $s3, $v0, $zero	# $s3 now points to the list head.
	
	la $a0, keyValuePrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s5, $zero, $v0
	la $a0, dataValuePrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s4, $zero, $v0
	
	sw $s4, 4($s2)	# Store the data value
	sw $s5	0($s2) # Store key
	
nextNode:
	beq $s1, $s0, creationDone
	addi $s1,$s1,1
	
	la $a0, keyValuePrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s5,$zero, $v0 
	la $a0, dataValuePrompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	add $s4,$zero, $v0
	
	li $a0, 12
	li $v0,  9
	syscall
	
	sw	$v0, 8($s2)
	add	$s2, $zero, $v0
	sw	$s4, 4($s2)
	sw	$s5, 0($s2)	
	
	j nextNode
	
creationDone:
	sw $zero, 8($s2)
	add $v0, $zero, $s3

	lw $ra, 0($sp)	
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)					
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra
	
evenList:
	addi $sp, $sp, -32
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	add $s0, $zero, $a0 # current node
	li $s6, 0 # counter

	li $a0, 12
	li $v0, 9
	syscall
	
	add $s3, $zero, $v0 # head of new even list
	add $s4, $zero, $v0 # last node in even list
	sw $zero, 0($s3)
	sw $zero, 8($s3)

check:
	beq $s0, $zero, evenListDone
	lw $s1, 0($s0) # Load key
	lw $s2, 4($s0) # Load data value

	div $s5, $s2, 2
	mfhi $s5 # Get remainder
	beq $s5, 1, goNextNode

createEvenList:
	beq $s6, 0, firstEvenNode
	j addNextEvenNode

firstEvenNode:
	sw $s1, 0($s3) # Store key
	sw $s2, 4($s3) # Store data
	sw $zero, 8($s3) # Null next pointer
	addi $s6, $s6, 1
	j goNextNode

addNextEvenNode:
	li $a0, 12
	li $v0, 9
	syscall

	sw $v0, 8($s4) # Update last node's next pointer
	add $s4, $zero, $v0 # Move last node pointer
	sw $s1, 0($s4) # Store key
	sw $s2, 4($s4) # Store data
	sw $zero, 8($s4) # Set next pointer to NULL

goNextNode:
	lw $s0, 8($s0) # Move to next node
	j check

evenListDone:

	add $v0, $zero, $s3 # Return new list head
	beq $s6, 0, returnNull
	j restoreRegisters
returnNull:
	li $v0, 0 
	
restoreRegisters:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	jr $ra
	
oddList:
	addi $sp, $sp, -32
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	add $s0, $zero, $a0 # current node
	li $s6, 0 # counter

	li $a0, 12
	li $v0, 9
	syscall
	
	add $s3, $zero, $v0 # head of new even list
	add $s4, $zero, $v0 # last node in even list
	sw $zero, 0($s3) #
	sw $zero, 8($s3)

checkOdd:
	beq $s0, $zero, oddListDone
	lw $s1, 0($s0) # Load key
	lw $s2, 4($s0) # Load data value

	div $s5, $s2, 2
	mfhi $s5 # Get remainder
	beq $s5, 0, goNextNodeForOdd

createOddList:
	beq $s6, 0, firstOddNode
	j addNextEvenNode

firstOddNode:
	sw $s1, 0($s3) # Store key
	sw $s2, 4($s3) # Store data
	sw $zero, 8($s3) # Null next pointer
	addi $s6, $s6, 1
	j goNextNodeForOdd

addNextOddNode:
	li $a0, 12
	li $v0, 9
	syscall

	sw $v0, 8($s4) # Update last node's next pointer
	add $s4, $zero, $v0 # Move last node pointer
	sw $s1, 0($s4) # Store key
	sw $s2, 4($s4) # Store data
	sw $zero, 8($s4)

goNextNodeForOdd:
	lw $s0, 8($s0) # Move to next node
	j checkOdd

oddListDone:

	add $v0, $zero, $s3 # Return new list head
	beq $s6, 0, returnNullForOdd
	j restoreRegistersForOdd
returnNullForOdd:
	li $v0, 0 
	
restoreRegistersForOdd:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 32
	jr $ra	
	
printLinkedList:

	addi $sp, $sp, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $ra, 0($sp)

	add $s0, $a0, $zero	# current node
	li   $s3, 0
printNextNode:
	beq $s0, $zero, printedAll
	lw $s4, 0($s0)			# address of current
	lw $s1, 8($s0)	# address of next
	lw $s2, 4($s0)	# data of current
	addi $s3, $s3, 1
	
	la	$a0, line
	li	$v0, 4
	syscall	
	
	la	$a0, keyOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	add	$a0, $s4, $zero	# key of current
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	add	$a0, $s0, $zero	# address of current
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	add	$a0, $s1, $zero	# address of next
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	add	$a0, $s2, $zero	#data
	li	$v0, 1		
	syscall	

	add	$s0, $s1, $zero	#  next node.
	j	printNextNode
printedAll:
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra

# Data segment
.data
printingOdds:.asciiz "\n \n Printing list of odd numbers: \n"
printingEvens:.asciiz "\n \n Printing list of even numbers: \n"
line: .asciiz "\n --------------------------------------"
nodeNumberPrompt: .asciiz	"\n Enter the number of nodes: "
keyOfCurrentNodeLabel:.asciiz "\n Key of Current Node: "
addressOfCurrentNodeLabel: .asciiz	"\n Address of Current Node: "
addressOfNextNodeLabel: .asciiz	"\n Address of Next Node: "
dataValueOfCurrentNode: .asciiz	"\n Data Value of Current Node: "
keyValuePrompt:.asciiz 	 "\n Key Value: "
dataValuePrompt:.asciiz " Data Value: "
