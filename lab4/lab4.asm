.org 0
addi $a0, $zero, 0x18
addi $a1, $zero, 0x08
jalsub $a0, $a1
addi $a2, $zero, 3
addi $a3, $zero, 6
.org 0x10
continue:
add $t0, $a0, $a1
sub $t1, $a0, $a1
and $t2, $a0, $a1
or $t3, $a0, $a1
slt $t4, $a1, $a0
lui $t5, 0x1001
ori $t6, $zero, 0xFFFF
sra $t7, $t6, 4
sw $t0, 0($sp)
lw $s0, 0($sp)
beq $a0, $a1, skip
addi $s1, $zero, 1
skip:
jr $ra