#This program uses subprograms to find the frequency of items in the array
.text

main:
	addi $sp, $sp, -32         # Reserve space for saved registers (no $ra)
	sw   $s7, 28($sp)
    	sw   $s6, 24($sp)
    	sw   $s5, 20($sp)
    	sw   $s4, 16($sp)
    	sw   $s3, 12($sp)
    	sw   $s2, 8($sp)
    	sw   $s1, 4($sp)
    	sw   $s0, 0($sp)
    
    	jal CreateArray 
    	add  $s5, $v0, $zero     # Array size returned in $v0
    	add  $s3, $v1, $zero     # Array pointer returned in $v1
    
    	add  $a0, $s5, $zero
    	add  $a1, $s3, $zero
    	jal printArray
    	
    	la   $s0, FreqTable
    	add  $a0, $s5, $zero
    	add  $a1, $s3, $zero
    	add  $a2, $s0, $zero
    	
    	jal FindFreq
    	
    	la   $a0, nextLine
    	li   $v0, 4
    	syscall
    	
    	addi $a0, $zero ,11
    	add  $a1, $s0, $zero
    	jal printFreq 
    
    # Restore saved registers
    	lw   $s0, 0($sp)
    	lw   $s1, 4($sp)
    	lw   $s2, 8($sp)
    	lw   $s3, 12($sp)
    	lw   $s4, 16($sp)
    	lw   $s5, 20($sp)
    	lw   $s6, 24($sp)
    	lw   $s7, 28($sp)
    	addi $sp, $sp, 32
    
    li   $v0, 10
    syscall

CreateArray:
	addi $sp, $sp, -4   
    	sw   $ra, 0($sp)           # Save return address
    
    	la   $a0, arraySizePrompt
    	li   $v0, 4
    	syscall
    
    	li   $v0, 5
    	syscall
    
    	add  $s0, $v0, $zero       # Store array size in $s0
    	mul  $s1, $s0, 4         # Calculate memory size (array size * 4)
    
    	add  $a0, $s1, $zero
    	li   $v0, 9              # Allocate dynamic memory
    	syscall
    
    	add  $s3, $v0, $zero     # Store the allocated array address in $s3
    	add  $a0, $s0, $zero
    	add  $a1, $s3, $zero 
    
    	jal  InitializeArray 
    
    	lw   $ra, 0($sp)
    	addi $sp, $sp, 4
    
    	add  $v0, $s0, $zero
    	add  $v1, $s3, $zero
    	jr   $ra 

InitializeArray:
    	add  $s2, $a0, $zero     # Copy array size to $s2
    	add  $s6, $a1, $zero     # $s6 points to start of array
	for:
    	la   $a0, enterArrayElementPrompt
    	li   $v0, 4
    	syscall

    	li   $v0, 5 
   		syscall

    	sw   $v0, 0($s6)        # Store the element in memory
    	addi $s2, $s2, -1 
    	blez $s2, done 
    	addi $s6, $s6, 4
    	j    for
	done:
    	jr   $ra
    	
FindFreq:
    addi $sp, $sp, -4
    sw   $a2, 0($sp)	# Save FreqTable base address

    add  $s1, $a0, $zero	#array size
    add  $s2, $a1, $zero	#array starting address

freq:
    lw   $s4, 0($sp)
    lw   $s6, 0($s2)	##load current element
    addi $s1, $s1, -1 
    addi $s2, $s2, 4  
    bgt  $s6, 9, freq11

freq0To9:
    mul  $s6, $s6, 4 
    add  $s4, $s4, $s6 
    lw   $s7, 0($s4) 
    addi $s7, $s7, 1
    sw   $s7, 0($s4)
    bne  $s1, $zero, freq
    j    freqDone 

freq11:
    addi  $s4, $s4, 40  
    lw   $s7, 0($s4) 
    addi $s7, $s7, 1 
    sw   $s7, 0($s4) 
    bne  $s1, $zero, freq

freqDone:
    addi $sp, $sp, 4
    jr   $ra 


printArray:
    	add  $s6, $a0, $zero	# Copy array size to $s6
    	add  $s7, $a1, $zero    # $s7 points to start of array

    	la   $a0, arrayElementsAre
    	li   $v0, 4
    	syscall

next:
    	lw   $a0, 0($s7)	# Load next element
    	li   $v0, 1
    	syscall

    	la   $a0, space
    	li   $v0, 4
    	syscall

    	addi $s7, $s7, 4
    	addi $s6, $s6, -1
    	bne  $s6, $zero, next
printDone:
    	jr   $ra
    	
printFreq:    	
    	add  $s6, $a0, $zero    # Copy array size to $s6
    	add  $s7, $a1, $zero    # $s7 points to start of array
    	addi $s5, $s6, -11

    	la   $a0, freqOfElements
    	li   $v0, 4
    	syscall
    	
    	la   $a0, nextLine
    	li   $v0, 4
    	syscall

nextFreq:
	la   $a0, frequencyOf
    	li   $v0, 4
    	syscall
    		
    	bgt $s5,9,biggerThan9   
    	ble $s5,9 lessOrEqual9	  	
    	
    	biggerThan9:
    	la   $a0, numbersGreaterThan9
    	li   $v0, 4
    	syscall
    	j decisionDone
    	 
    	lessOrEqual9:
    	add  $a0, $s5, $zero
    	li   $v0, 1
    	syscall 
    	
    	decisionDone:
    	
    	la   $a0, arrow
    	li   $v0, 4
    	syscall

    	lw   $a0, 0($s7)	# Load next element
    	li   $v0, 1
    	syscall

    	la   $a0, nextLine
    	li   $v0, 4
    	syscall

    	addi $s7, $s7, 4
    	addi $s6, $s6, -1
    	addi $s5, $s5, 1
    	bne  $s6, $zero, nextFreq
printFreqDone:
    	jr   $ra 

 

.data
numbersGreaterThan9: .asciiz "numbers greater than 9 "
frequencyOf: .asciiz "Frequency of  "
freqOfElements: .asciiz "Frequency of elements are: "
arrayElementsAre: .asciiz "Array Elements are: "
enterArrayElementPrompt: .asciiz "Enter array element: "
arraySizePrompt: .asciiz "Enter array Size: "
FreqTable: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
nextLine: .asciiz "\n"
space: .asciiz " "
arrow: .asciiz "----->"
