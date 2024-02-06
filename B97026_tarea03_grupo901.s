# Tarea03
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
main:

addi $a0, $0, 630
addi $a1, $0, 210

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