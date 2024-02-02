main:
addi $a0, $0, 100
addi $a1, $0, 7
jal MUL

li $v0, 10
syscall

MUL:
addi $t0, $a1, 0  #a
addi $t1, $a0, 0  #b
addi $t2, $0, 0   #i
addi $t4, $0, 0   #m

LOOP1:
add $t4, $t4, $t1
addi $t2, $t2, 1
slt $t3, $t2, $t0
bne $t3, $0, LOOP1

add $v0, $t4, $0

jr $ra 