.data
Array:
.word 1, 5, 1, 7, 1,10 , 1, 1, 1, 15 , 0, 0

.text
main:
la $a1, Array
jal BUBBLE_SORT_FRAQ



li $v0, 10
syscall

BUBBLE_SORT_FRAQ:

while:              # mientras los swap sean 0
li $t9, 0           # variable de verificación de swap
add $t8, $0, $a1

iteration: 
lw $t1, 0($t8) # se carga numerador i 
lw $t2, 4($t8) # se carga el denominador i

lw $t3, 8($t8) # se carga el numerador j
lw $t4, 12($t8) # se carga el denominador j


beq $t4, $0, salir # si el denominador j es cero, se terminan las iteraciones

# obteniendo valores de referencia
mul $t5, $t1, $t4               # Valor de referencia de fracción [m]
mul $t6, $t3, $t2               # Valor de referencia de fracción [m + 1]

slt $t7, $t6,  $t5  

beq $t7, $0, noesmenor     # si no es menor se salta el cambio
sw $t1, 8($t8)             # se guarda numerador j en el lugar del numerador i 
sw $t2, 12($t8)        # se guarda denominador j en el lugar del denominador i

sw $t3, 0($t8)         # se guarda numerador i en el lugar del numerador j
sw $t4, 4($t8)         # se guarda denominador j en el lugar del denominador i
addi $t9, $t9, 1       # se hizo cambio, $t9 no es 0

noesmenor: 

addi $t8, $t8, 8 # variable de iteración

j iteration

salir:
beq $t9, $0, notwhile
j while

notwhile: 
jr $ra





