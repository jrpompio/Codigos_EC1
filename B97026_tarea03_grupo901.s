# Tarea13
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
.data 
bienvenida:     .ascii "\n"
                .asciiz "Iniciando programa..."
                
VALOR_A:        .ascii "\n"
                .ascii "Ingrese el primer numero para obtener el MCD:\n"
                .asciiz "--->  "

VALOR_B:        .ascii "Ingrese el segundo numero para obtener el MCD:\n"
                .asciiz "--->  "

RESULTADO_MCD:  .ascii "El MCD entre los numeros ingresados es:\n"
                .asciiz "===>  "

.text

main:
la $a0, bienvenida
jal PRINT_CADENA

la $a0, VALOR_A
jal PRINT_CADENA
jal MAYORZ
bne $v1, $0, main
add $a1, $v0, $0

la $a0, VALOR_B
jal PRINT_CADENA
jal MAYORZ
bne $v1, $0, main
add $a2, $v0, $0

jal MCD

la $a0, RESULTADO_MCD
jal PRINT_CADENA

add $a0, $v0, $0
jal PRINT_INTEGER

j main

MCD:
addi $sp, $sp, -4
sw $ra, 0($sp)
beq $a2, $0, RESULTADO

div $a1, $a2
addi $a1, $a2, 0
mfhi $a2

jal MCD

RESULTADO:
add $v0, $a1, 0
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

MAYORZ:
li $v0, 5
syscall
slt $v1, $v0, $0
jr $ra

PRINT_CADENA:
# esta función obtiene del argumento el inicio de una cadena de carácteres
# tipo asciiz, muestra desde el primer elemento de la cadena
# hasta encontrar un valor 0 y detenerse
# $a0: argumento de dirección del elemento inicial de la cadena
    addi $sp, $sp, -4
    sw $v0, 0($sp)

	addi $v0, $0, 4 # el valor 4 en $v0 muestra en pantalla una cadena
			        # esta cadena empieza en la dirección de memoria
                    # que contiene $a0
	syscall
    lw $v0, 0($sp)
    addi $sp, $sp, 4
jr $ra

PRINT_INTEGER:
# esta función obtiene del argumento el inicio un valor entero
# $a0: argumento de valor entero a mostrar en pantalla
    addi $sp, $sp, -4
    sw $v0, 0($sp)

	addi $v0, $0, 1 # el valor 1 en $v0 muestra un valor entero
                    # contenido en $a0
	syscall

    addi $v0, $0, 11    # el valor 11 en $v0 muestra un caracter ascii
                        # contenido en $a0
    addi $a0, $0, 10    # codigo ascci para salto de linea "\n"
    syscall

    lw $v0, 0($sp)
    addi $sp, $sp, 4
jr $ra