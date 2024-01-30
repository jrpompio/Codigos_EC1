.data 
arreglo: .asciiz "este arreglo tiene 4 espacios"
.text
main:

la $a0, arreglo
jal COMPARAR_ESPACIOS

li $v0, 10
syscall

COMPARAR_ESPACIOS:
addi $t0, $a0, 0
addi $t3, $0, 0

loop1:
lb $t1, 0($t0)
beq $t1, $0, end # Me faltó esta linea

addi $t2, $0, 0x20
addi $t0, $t0, 1
 
bne $t1, $t2, loop1

addi $t3, $t3, 1

bne $t1, $0, loop1


end:


addi $v0, $t3, 0

jr $ra