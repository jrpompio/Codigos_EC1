# Tarea03
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
.text
main:
jal MAYORZ
bne $v1, $0, main
add $a0, $v0, $0
jal MAYORZ
bne $v1, $0, main
add $a1, $v0, $0

jal MCD

add $t0, $v0, $0
li $v0, 1
add $a0, $t0, $0
syscall


li $v0, 10
syscall

MCD:
addi $sp, $sp, -4
sw $ra, 0($sp)
beq $a1, $0, RESULTADO

div $a0, $a1
addi $a0, $a1, 0
mfhi $a1

jal MCD

RESULTADO:
add $v0, $a0, 0
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

MAYORZ:
li $v0, 5
syscall
slt $v1, $v0, $0
jr $ra