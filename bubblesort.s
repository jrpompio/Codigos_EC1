.data
Array:
.word 1, 5, 1, 7, 1,10 , 1, 1, 1, 13 , 0, 0

.text
main:
la $a1, Array
jal BUBBLE_SORT_ASC



li $v0, 10
syscall

BUBBLE_SORT_ASC:

while: # mientras los swap sean 0
li $t7, 0 # variable de control while 
li $t6, 0 # variable de iteración

iteration: 
sll $t5, $t6, 2 # iteración * 4
add $t4, $t5, $a1 # dirección de puntero + iteración * 4
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
jr $ra





