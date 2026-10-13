	.text
# Find sum of array elements and print
main:
	la	$s0, array
	lw	$s1, arraysize
	add	$s2, $zero, $zero
	j	test
next:	

	lw	$s3, 0($s0)
	add	$s2, $s2, $s3
	addi	$s1, $s1, -1
	addi	$s0, $s0, 4
test:
	bne	$s1, $zero, next

done:
	la $s4, main
	la $s5, done
	add $a0, $zero, $s4
	add $a1, $zero, $s5
	jal InstructionCount
	
	add $s4, $zero, $v0
	add $s5, $zero, $v1
	
	la $a0, numberOfAddLabel
	li $v0, 4
	syscall
	
	add $a0, $zero, $s4
	li $v0, 1
	syscall
	
	la $a0, numberOfAddiLabel
	li $v0, 4
	syscall
	
	add $a0, $zero, $s5
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
	
	#a0 is the beginning address of where we start to count
	#a1 is the end address of where we start to count
InstructionCount:
	addi $sp, $sp, -28
	sw $s5, 24($sp)	
	sw $s4, 20($sp)	
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	add $s0, $zero, $a0 #beginning
	add $s1, $zero, $a1 #end
	
	add $s2, $zero, $zero #add count
	add $s3, $zero, $zero #addi count
	
	for:
		bgt $s0, $s1, countingDone
		lw $s4, 0($s0)
		add $s5, $zero, $s4
		srl $s5, $s5, 26		
		beq $s5, 0, checkAdd
		beq $s5, 0x08, increaseAddiCount
		j nextInstruction
	checkAdd:
		andi $s4, $s4, 0x3F
		beq $s4, 0x20, increaseAddCount
		j nextInstruction
	increaseAddCount:
		addi $s2, $s2, 1
		j nextInstruction	
	increaseAddiCount:
		addi $s3, $s3, 1
		j nextInstruction
	nextInstruction:
		addi $s0, $s0, 4
		j for
	countingDone:
		add $v0, $s2, $zero
		add $v1, $s3, $zero
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp)											
		lw $s5, 24($sp)	
		addi $sp, $sp, 28
		jr $ra
		
	.data
array:	
	.word	5, 10, 15, 20

arraysize:
	.word	4	
numberOfAddLabel: .asciiz "\n The number of the add instructions: "
numberOfAddiLabel: .asciiz "\n The number of the addi instructions: "
mesaj1:	.asciiz	"sum:"
	
	
