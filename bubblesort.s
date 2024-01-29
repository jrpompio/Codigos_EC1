addi $s0, $0, 0x10010000
addi $s1, $s0, 32

# agregando lista
addi $t0, $0, 15
sw $t0, 0($s0)

addi $t0, $0, 12
sw $t0, 4($s0)

addi $t0, $0, 35
sw $t0, 8($s0)

addi $t0, $0, 8
sw $t0, 12($s0)

addi $t0, $0, 7
sw $t0, 16($s0)

addi $t0, $0, 10
sw $t0, 20($s0)

addi $t0, $0, 1
sw $t0, 24($s0)

addi $t0, $0, 0
sw $t0, 28($s0)



while: # mientras los swap sean 0
li $t7, 0 # variable de control while 
li $t6, 0 # variable de iteración

iteration: 
sll $t5, $t6, 2 # iteración * 4
add $t4, $t5, $s0 # dirección de puntero + iteración * 4
lw $s1, 0($t4) # se carga el elemento i 
lw $s2, 4($t4) # se carga el elemento i + 1

beq $s2, $0, salir # si el elemento i + 1 es cero, se terminan las iteraciones

slt $t3, $s2,  $s1  # si el elemento i + 1 es menor a i $t3 = 1 (orden ascendente )

beq $t3, $0, noesmenor # si no es menor se salta el cambio

sw $s1, 4($t4) # cambio de variables
sw $s2, 0($t4)
addi $t7, $t7, 1 # se hizo cambio, $t7 no es 0

noesmenor: 


addi $t6, $t6, 1 # variable de iteración

j iteration

salir:

beq $t7, $0, notwhile
j while

notwhile: 






