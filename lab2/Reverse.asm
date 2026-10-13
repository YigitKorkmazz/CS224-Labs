# Reverse Register Contents
.text

main:
    	addi $sp, $sp, -24
    	sw $s4, 20($sp)    
    	sw $s3, 16($sp)    
    	sw $s2, 12($sp)    
    	sw $s1, 8($sp)
    	sw $s0, 4($sp)
    	sw $ra, 0($sp)

loop:
    	jal getInput
    	add $s0, $zero, $v0
    
    	add $a0, $zero, $s0
    	jal reverseBits
    	add $s1, $zero, $v0
    
    	la $a0, resultMsg
    	li $v0, 4
    	syscall
    
    	add $a0, $zero, $s1
    	li $v0, 34   # Print in hex
    	syscall
    
    	la $a0, continuePrompt
    	li $v0, 4
    	syscall
    
    	li $v0, 5
    	syscall
    
    	beq $v0, $zero, exit
    	j loop

exit:
   	lw $s1, 20($sp)
    	lw $s1, 16($sp)
    	lw $s1, 12($sp)
    	lw $s1, 8($sp)
    	lw $s0, 4($sp)
    	lw $ra, 0($sp)
    	addi $sp, $sp, 16
    	li $v0, 10
    	syscall

getInput:
    	la $a0, inputPrompt
    	li $v0, 4
    	syscall
    
    	li $v0, 5
    	syscall
    
    	add $v0, $zero, $v0
    	jr $ra

reverseBits:
    	add $s3, $zero, $a0
    	li $s4, 0
    	addi $s5, $zero, 32

reverseLoop:
    	beq $s5, $zero, doneReverse
    
    	andi $s6, $s3, 1
    	sll $s4, $s4, 1
    	or $s4, $s4, $s6
    
    	srl $s3, $s3, 1
    	addi $s5, $s5, -1
    	j reverseLoop

doneReverse:
    	add $v0, $zero, $s4
    	jr $ra

.data
inputPrompt: .asciiz "Please enter an integer: "
resultMsg: .asciiz "Reversed bit representation: "
continuePrompt: .asciiz "\nDo you want to continue? (Enter 0 to exit, any other number to continue): "
