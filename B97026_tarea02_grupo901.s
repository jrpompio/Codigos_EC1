# Tarea02
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026

.data
msj_init:       .ascii "\n"
                .asciiz "Mostrando Cadena:\n"

msj_valido:     .ascii  "\n\n"
                .ascii "----Resultado:\n"
                .asciiz "parentesis validos\n"

msj_invalido:   .ascii  "\n\n"
                .ascii "----Resultado:\n"
                .asciiz "parentesis invalidos\n"
                
cadena_1: .asciiz "Aca no hay parentesis"
cadena_2: .asciiz "muchos parentesis () [] {} {{{()}[]}()}"
cadena_3: .asciiz "este cierra 2 veces sin abrir])”"
cadena_4: .asciiz "[{y este último cierra en un orden incorrecto]}"

.text
main:

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_1
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_2
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_3
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_4
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO


jal EXIT

VALIDACION_PARENTESIS:
addi $sp, $sp, -4
sw $s0, 0($sp)
addi $s0, $0, 0  # Variable tamaño de cadena

addi $t0, $a0, 0 # t0 dirección primer elemento, temporal

LEN:
lb $t1, 0($t0)
addi $s0, $s0, 1
beq $t1, $0, NEL
addi $t0, $t0, 1
j LEN
NEL:

sub $sp, $sp, $s0   # Tamaño en en memoria igual a la cadena
                    # se asume que todos los caracteres son paréntesis


addi $t0, $a0, 0 # t0 dirección primer elemento, temporal

addi $t9, $0, 40
addi $t8, $0, 41
addi $t7, $0, 91
addi $t6, $0, 93
addi $t5, $0, 123
addi $t4, $0, 125

addi $t3, $sp, 0
addi $t3, $t3, -1
sb   $0, 0($t3)

PURGE:
lb $t1, 0($t0)
beq $t1, $0, EGRUP
lb  $t2, 0($t3)
beq $t1, $t9, ABRE
beq $t1, $t7, ABRE
beq $t1, $t5, ABRE
j CIERRA
ABRE:
addi $t3, $t3, 1
sb $t1, 0($t3)

CIERRA:
beq $t1, $t8, CIERRA_41
beq $t1, $t6, CIERRA_93
beq $t1, $t4, CIERRA_125

j SIGUIENTE

CIERRA_41:
bne $t2, $t9, NO_VALIDO
addi $t3, $t3, -1
j SIGUIENTE
CIERRA_93:
bne $t2, $t7, NO_VALIDO
addi $t3, $t3, -1
j SIGUIENTE
CIERRA_125:
bne $t2, $t5, NO_VALIDO
addi $t3, $t3, -1
SIGUIENTE:
addi $t0, $t0, 1
j PURGE
EGRUP:


VALIDO:
addi $v0, $0, 1
j TERMINAR_VALIDO

NO_VALIDO:
addi $v0, $0, 0

TERMINAR_VALIDO:
# acá se debe guardar los parentesis de inicio para reconocer cual debe ser 
# el siguiente parentesis de cierre
# no se debe tener uno de cierre sin su pareja previa de inicio

add $sp, $sp, $s0   # devolviendo puntero
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra


VALIDACION_VO:
# muestra en pantalla el valor correspondiente al registro $v0
	addi $t0, $v0, 0  # Valor de v0 a t0
	addi $v0, $0, 4   # mostrar cadena terminada en \0
    beq $t0, $0, VALOR_0
    la $a0, msj_valido
    j VALOR_1
	VALOR_0:
    la $a0, msj_invalido
    VALOR_1:
    syscall
	
jr $ra

PRINT_CADENA:
# esta función obtiene del argumento el inicio de una cadena de carácteres
# tipo asciiz, muestra desde el primer elemento de la cadena
# hasta encontrar un valor 0 y detenerse
# $a0: argumento de dirección del elemento inicial de la cadena

	addi $v0, $0, 4 # el valor 4 en $v0 muestra en pantalla una cadena
			        # esta cadena empieza en la dirección de memoria que contiene $a0
	syscall
jr $ra

EXIT:
# Esta función ejecuta el syscall de $v0 = 10
# que corresponde a la salida del programa
	addi $v0, $0, 10
	syscall	
	
jr $ra