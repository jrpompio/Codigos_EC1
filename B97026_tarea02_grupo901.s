# Tarea02
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026

.data
cadena_parentesis: .asciiz "(]{}"

.text
main:

la $a0, cadena_parentesis
jal VALIDACION_PARENTESIS



jal EXIT

VALIDACION_PARENTESIS:
# etapa de validación de paridad
addi $t0, $0, 40
addi $t1, $0, 41
addi $t2, $0, 91
addi $t3, $0, 93
addi $t4, $0, 123
addi $t5, $0, 125
addi $t7, $0, 0
addi $t8, $0, 0
addi $t9, $0, 0


INICIO:
lb $t6, 0($a0)
beq $t6, $0, FIN
beq $t6, $t0, PARENTESIS_40
beq $t6, $t1, PARENTESIS_41
beq $t6, $t2, PARENTESIS_91
beq $t6, $t3, PARENTESIS_93
beq $t6, $t4, PARENTESIS_123
beq $t6, $t5, PARENTESIS_125

j CONTINUAR

PARENTESIS_40:
addi $t7, $t7, 1
j CONTINUAR
PARENTESIS_41:
addi $t7, $t7, -1
j CONTINUAR
PARENTESIS_91:
addi $t8, $t8, 1
j CONTINUAR
PARENTESIS_93:
addi $t8, $t8, -1
j CONTINUAR
PARENTESIS_123:
addi $t9, $t9, 1
j CONTINUAR
PARENTESIS_125:
addi $t9, $t9, -1

CONTINUAR:
addi $a0, $a0, 1
j INICIO

FIN:
add $t9, $t9, $t8
add $t9, $t9, $t7

bne $t9, $0, NO_VALIDO

# Etapa de validación de orden


VALIDO:
addi $v0, $0, 1
jr $ra

NO_VALIDO:
addi $v0, $0, 0
jr $ra

EXIT:
# Esta función ejecuta el syscall de $v0 = 10
# que corresponde a la salida del programa
	addi $v0, $0, 10
	syscall	
	
jr $ra