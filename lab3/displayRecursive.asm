#This program displays a list recursively

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
	
	la $a0, printingReverseLabel
	li $v0, 4
	syscall
	
	add $a0, $zero, $s7
	jal displayListRecursively
	
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
	
displayListRecursively:
    	beq $a0, $zero, recursionDone  # Base case: if node is NULL, return
    	add $s1, $zero, $a0

    	addi $sp, $sp, -16
    	sw $s1, 12($sp)
    	sw $ra, 8($sp)
    	sw $a0, 4($sp)

    	beq $s1, $zero, recursionDone  
    	lw $a0, 8($s1)   # Load next node address
    	jal displayListRecursively 

    	lw $a0, 4($sp)
    	lw $ra, 8($sp)
    	lw $s1, 12($sp)
    	addi $sp, $sp, 16
    
    	la $a0, line
	li $v0, 4
	syscall	

    	la $a0, keyOfCurrentNodeLabel
    	li $v0, 4
    	syscall

    	lw $a0, 0($s1)
    	li $v0, 1
    	syscall

    	la $a0, dataValueOfCurrentNode
    	li $v0, 4
    	syscall

   	lw $a0, 4($s1)
   	li $v0, 1
    	syscall

    	jr $ra

recursionDone:
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
	
# Data Segment	
	.data
printingReverseLabel:.asciiz "\n Printing the reverse list"
line: .asciiz "\n --------------------------------------"
nodeNumberPrompt: .asciiz	"\n Enter the number of nodes: "
keyOfCurrentNodeLabel:.asciiz "\n Key of Current Node: "
addressOfCurrentNodeLabel: .asciiz	"\n Address of Current Node: "
addressOfNextNodeLabel: .asciiz	"\n Address of Next Node: "
dataValueOfCurrentNode: .asciiz	"\n Data Value of Current Node: "
keyValuePrompt:.asciiz 	 "\n Key Value: "
dataValuePrompt:.asciiz " Data Value: "
