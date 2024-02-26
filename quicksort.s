.data

lista: .word 1, 10, 20, 45, -1, -100, 100, -10, 56, -989, 1000, 0

.text

main:


la $a1, lista
li $a2, 0
jal QS




addi $v0, $0, 10
syscall

# FUNCIÓN

QS:

add $t0, $0, $a1               # cargando direccion de valor inicial a temporal
addi $t9, $0, 0                # iniciando contador en cero

contador:

lw $t3, 0($t0)                 # Cargando valor
beq $t3, $a2, fin_contador      # Si valor = valor final, termina
addi $t9, $t9, 1               # contador +1
addi $t0, $t0, 4               # siguiente valor
j contador                     
fin_contador:
beq $t9, $0, terminar
addi $t9, $t9, -1              # t9, valor del ultimo elemento
# SELECCION DE PIVOTE
add $t0, $0, $a1               # cargando direccion de valor inicial a temporal
sll $t9, $t9, 2
add $t0, $t0, $t9
lw $a0, 0x00400020
lw $t8, 0($t0)






terminar:
jr $ra
