.data

lista: .word 1, 10, 20, 45, -1, -100, 100, -10, 56, -989, 1000, 0

.text

main:


la $a0, lista
jal QS

la $t0, lista
for:
lw $t1, 0($t0)
beq $t1, $0, finalizar
add $a0, $0, $t1
addi $v0, $0, 1
syscall
addi $t0, $t0, 4
addi $v0, $0, 11
addi $a0, $0, 32
syscall

j for
finalizar:


addi $v0, $0, 10
syscall

# FUNCIÓN

QS:

add $t0, $0, $a0               # cargando direccion de valor inicial a temporal
addi $t9, $0, 0                # iniciando contador en cero

contador:

lw $t3, 0($t0)                 # Cargando valor
beq $t3, $0, fin_contador      # Si valor = cero, termina
addi $t9, $t9, 1               # contador +1
addi $t0, $t0, 4               # siguiente valor
j contador                     
fin_contador:
beq $t9, $0, terminar








terminar:
jr $ra
