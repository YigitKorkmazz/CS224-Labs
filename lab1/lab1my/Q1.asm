#This program swaps takes the array size from the user
#And array elements and swap that array

	.text 
	la $a0,prompt
	li $v0,4
	syscall

	li $v0, 5			#getting array size input from user
	syscall

	move $t0,$v0
	move $s0,$t0
	la $t1, array
	
	j test
	next:
		li $v0, 5
    		syscall 
    		sw $v0, ($t1)       	#store input in array
    		addi  $t0, $t0, -1   
    		addi $t1, $t1, 4 	#go to the next item address in the array
	test:
		bne $t0,$zero,next
	done:
		la $t1, array
		move $t0, $s0

	
	la $a0,arrayContents
	li $v0,4
	syscall
	
	#printing the input array
	j testPrintDone
	printArrayElements:
		lw $a0, ($t1)
		li $v0, 1
		syscall
		
		la $a0, space
		li $v0, 4
		syscall

		addi  $t0, $t0, -1   
    		addi $t1, $t1, 4
	testPrintDone:
		bne $t0, $zero,printArrayElements
	printDone:
		move $t0, $s0
		la $t1, array

	la $a0,endl		
	li $v0,4
	syscall
	
	mul $t4, $t0, 4	
	add $t2, $t1, $t4		# Pointer to end of array
	addi $t2, $t2, -4		# Move to last element

	div $t0, $t0, 2			# Loop half the array size
	mflo $t0
	j swapLoopTest
	swapNext:
		lw $t3, 0($t1)
		lw $t5, 0($t2)
		sw $t5, 0($t1)		# Swap values
		sw $t3, 0($t2)
		addi $t1, $t1, 4	# Move forward in the array
		addi $t2, $t2, -4	# Move backward in the array
		addi $t0, $t0, -1	# Decrement swap counter
	swapLoopTest:
		bne $t0, $zero, swapNext
	swappingDone:
		move $t0, $s0
		la $t1, array
		
	la $a0,swappedArrayContents
	li $v0,4
	syscall
		
	#printing swapped array	
	printSwappedArrayElements:
		lw $a0, ($t1)
		li $v0, 1
		syscall
		
		la $a0, space
		li $v0, 4
		syscall

		addi  $t0, $t0, -1   
    		addi $t1, $t1, 4
	testSwappedArrayPrint:
		bne $t0, $zero,printSwappedArrayElements
	swappedArrayPrintDone:
		move $t0, $s0

	li $v0,10
	syscall	

#data segment

	.data
	.align 4 # Makes sure that the address of the variable array is divisible by 4
array: .space 80
prompt:	.asciiz "Enter array size: "
space: .asciiz " "
arrayContents: .asciiz "Array Elements are: "
swappedArrayContents: .asciiz "Swapped Elements are: "
endl:	.asciiz "\n"
