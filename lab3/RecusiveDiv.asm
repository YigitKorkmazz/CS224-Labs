#perform integer division by successive subtractions
.text
main:
    	addi $sp, $sp, -32
    	sw $s6, 28($sp)    
    	sw $s5, 24($sp)    
    	sw $s4, 20($sp)
    	sw $s3, 16($sp)
    	sw $s2, 12($sp)
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
    	sw $ra, 0($sp)

loop:
    	jal getInput
    	add $s0, $zero, $v0
    	add $s1, $zero, $v1
    
    	add $a0, $zero, $s0
    	add $a1, $zero, $s1
    	add $s2, $zero, $zero
    	add $s3, $zero, $zero    	
    	jal RecursiveDivision
    	add $s2, $zero, $v0 #quotient
    	add $s3, $zero, $v1 #remainder
    
    	la $a0, newLine
    	li $v0, 4
    	syscall
    
    	la $a0, theQuotient
    	li $v0, 4
    	syscall
    
    	add $a0, $zero, $s2
    	li $v0, 1
    	syscall
    	
    	la $a0, newLine
    	li $v0, 4
    	syscall
    
    	la $a0, theRemainder
    	li $v0, 4
    	syscall
    
    	add $a0, $zero, $s3
    	li $v0, 1
    	syscall
    
    	la $a0, continuePrompt
    	li $v0, 4
    	syscall
    
    	li $v0, 5
    	syscall
    
    	beq $v0, $zero, exit
    	j loop

exit:
    	addi $sp, $sp, 32
    	lw $ra, 0($sp)
    	lw $s0, 4($sp)
    	lw $s1, 8($sp)
    	lw $s2, 12($sp)
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)        
    	lw $s6, 28($sp)    

    	li $v0,10
    	syscall  
 getInput:
    	la $a0, input1Prompt
    	li $v0, 4
    	syscall
    
    	li $v0, 5
    	syscall
    
    	add $s0, $zero, $v0
    
    	la $a0, input2Prompt
    	li $v0, 4
    	syscall
    
    	li $v0, 5
    	syscall
    
    	add $s1, $zero, $v0
    
    	add $v0, $zero, $s0
    	add $v1, $zero, $s1
    
    	jr $ra
    	
   RecursiveDivision:
       	blt $a0, $a1, recursionDone  # Base case: if node is NULL, return
    	add $s1, $zero, $a0
    	
    	addi $sp, $sp, -20
    	sw $s2, 16($sp)    	
    	sw $s1, 12($sp)
    	sw $ra, 8($sp)
    	sw $a0, 4($sp) 
    	
    	sub $s1, $s1, $a1
    	addi $s2, $s2, 1
    	
    	add $a0, $zero, $s1
    	jal RecursiveDivision
    	
    	lw $a0, 4($sp)
    	lw $ra, 8($sp)
    	lw $s1, 12($sp)
    	lw $s2, 16($sp)
    	addi $sp, $sp, 20
    	
    	jr $ra
   recursionDone:
   	add $v0, $zero, $s2
   	add $v1, $zero, $s1
   	jr $ra 		   	
.data 
input1Prompt: .asciiz "Please enter the first integer: "
input2Prompt: .asciiz "Please enter the second integer: "
theQuotient:.asciiz "The quotient is: "
theRemainder:.asciiz "The remainder is: "
newLine: .asciiz "\n"
continuePrompt: .asciiz "\nDo you want to continue? (Enter 0 to exit, any other number to continue): "
