# Hamming Distance Between Registers
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
    	jal displayInHex
    
    	add $a0, $zero, $s0
    	add $a1, $zero, $s1
    	jal findHamming
    	add $s2, $zero, $v0
    
    	la $a0, newLine
    	li $v0, 4
    	syscall
    
    	la $a0, theResult
    	li $v0, 4
    	syscall
    
    	add $a0, $zero, $s2
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
    
    
displayInHex:
    	add $s2, $zero, $a0
    	add $s3, $zero, $a1
    
 	add $a0, $zero, $s2    
	li $v0, 34        # Print contents of $a in hex
	syscall
    
	la $a0, newLine
	li $v0, 4
	syscall
    
	add $a0, $zero, $s3    
	li $v0, 34        # Print contents of $a in hex
	syscall    
	jr $ra
    
findHamming:
	add $s4, $zero, $a0
	add $s5, $zero, $a1
	add $s7, $zero, $zero #counter
    
	xor $s6, $s4, $s5
	add $v0, $zero, $s6
    
nextBit:
	beq $s6, $zero, done
	andi $s3, $s6, 1
	add $s7, $s7, $s3
	srl $s6, $s6, 1
	j nextBit

done:
	add $v0, $zero, $s7
	jr $ra    
    
.data
input1Prompt: .asciiz "Please enter the first integer: "
input2Prompt: .asciiz "Please enter the second integer: "
theResult:.asciiz "The result is: "
newLine: .asciiz "\n"
continuePrompt: .asciiz "\nDo you want to continue? (Enter 0 to exit, any other number to continue): "
