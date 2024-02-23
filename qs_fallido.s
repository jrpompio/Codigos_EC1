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


sll $t9, $t9, 2                # (n - 1) * 4
sub $sp, $sp, $t9              # Apartando espacio para mayores
add $t8, $0, $sp               # Dirección primer elemento mayores
sub $sp, $sp, $t9              # Apartando espacio para menores
add $t7, $0, $sp               # Dirección primer elemento menores

addi $sp, $sp, -20
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $t9, 8($sp)
sw $t8, 12($sp)
sw $t7, 16($sp)

add $t5, $0, $sp


add $t0, $0, $a0               # Cargando direccion de valor inicial a temporal
lw $t3, 0($t0)                 # Cargando valor inicial, que será el pivote

add $t1, $0, $t7               # menores

menor_que_pivote:
addi $t0, $t0, 4
lw $t4, 0($t0)
beq $t4, $0, terminar_menor

slt $t2, $t4, $t3              # Valor cargado menor a valor pivote, $t1 = 1
beq $t2, $0, no_guarda         # si t1 = 0, no guarda
sw $t4, 0($t1)                 # Guarda valor que si es menor en lista menor
addi $t1, $t1, 4               # Abre campo en lista para el siguiente

no_guarda:
j menor_que_pivote
terminar_menor:
sw $0, 0($t1)                  # Guarda valor cero al final de la lista

add $t0, $0, $a0               # Cargando direccion de valor inicial a temporal
lw $t3, 0($t0)                 # Cargando valor inicial, que será el pivote

add $t1, $0, $t8               # mayores

mayor_que_pivote:
addi $t0, $t0, 4
lw $t4, 0($t0)
beq $t4, $0, terminar_mayor

slt $t2, $t3, $t4              # Valor pivote menor a valor cargado, $t1 = 1
beq $t2, $0, no_guarda2         # si t1 = 0, no guarda
sw $t4, 0($t1)                 # Guarda valor que si es mayor en lista mayor
addi $t1, $t1, 4               # Abre campo en lista para el siguiente

no_guarda2:
j mayor_que_pivote
terminar_mayor:
sw $0, 0($t1)                  # Guarda valor cero al final de la lista


add $t0, $0, $a0
add $t1, $0, $t7                # menores

Devolviendo_lista_menor:
lw $t2, 0($t1)
beq $t2, $0, terminar_return_menor
sw $t2, 0($t0)

addi $t0, $t0, 4
addi $t1, $t1, 4
j Devolviendo_lista_menor
terminar_return_menor:

sw $t3, 0($t0)
addi $t0, $t0, 4

add $t1, $0, $t8

Devolviendo_lista_mayor:
lw $t2, 0($t1)
beq $t2, $0, terminar_return_mayor
sw $t2, 0($t0)

addi $t0, $t0, 4
addi $t1, $t1, 4
j Devolviendo_lista_mayor
terminar_return_mayor:


add $a0, $0, $t8
jal QS                  # ERROR EN LA LÓGICA SOLO ACCESA A SEMILISTAS MAYORES

add $a0, $0, $t7  
jal QS

terminar:



lw $t7, 16($sp)
lw $t8, 12($sp)
lw $t9, 8($sp)
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 20

add $sp, $sp, $t9
add $sp, $sp, $t9


jr $ra
