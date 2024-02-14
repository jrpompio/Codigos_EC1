main:
addi $a0, $0, 100
addi $a1, $0, 7
jal MUL

li $v0, 10
syscall

MUL:
addi $t0, $a1, 0  # $a1 = $t0 = a
addi $t1, $a0, 0  # $a1 = $t1 = b
addi $t2, $0, 0   # $t2 = i = 0
addi $t4, $0, 0   # $t4 = m = 0

LOOP1:
add $t4, $t4, $t1   # m = m + b
addi $t2, $t2, 1    # i = i + 1

slt $t3, $t2, $t0   # $t3 = 1 si t2 < t0 
bne $t3, $0, LOOP1  # se repite si t3 != 0

add $v0, $t4, $0    # return

jr $ra