# Tarea03
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
#
# Este codigo solicita por medio de la terminal dos numeros
# ambos numeros mayores a cero, y entrega en pantalla el valor numerico
# que corres ponde al mcd.
#
# Para esto toma cada numero y aplica el algoritmo euclidiano para el calculo 
# del mcd.
#
# En caso de ingresar un valor negativo, el programa se repite de nuevo,
# de la misma manera, el programa se repite de nuevo después de proporcionar 
# el resultado.

.data 
bienvenida:     .ascii "\n"
                .asciiz "Iniciando programa..."
                
VALOR_A:        .ascii "\n"
                .ascii "A) Ingrese el primer numero para obtener el MCD:\n"
                .asciiz "--->  "

VALOR_B:        .ascii "B) Ingrese el segundo numero para obtener el MCD:\n"
                .asciiz "--->  "

RESULTADO_MCD:  .ascii "- El MCD entre los numeros ingresados es:\n"
                .asciiz "===>  "
ERROR:          .ascii  "\n"
                .asciiz "ERROR: El valor ingresado no puede ser negativo\n"

.text

main:
la $a0, bienvenida          # Cargando mensaje de bienvenida
jal PRINT_CADENA            # Mostrando mensaje en pantalla

la $a0, VALOR_A             # Pasando primer valor a a1
jal PRINT_CADENA            # Mostrando mensaje de indicación
jal MAYORZ                  # Llamando a funcion para validar valor > cero
                            # v1 es la salida de MAYORZ, es 1 cuando v0 < 0
bne $v1, $0, main           # si v1 != 0, repite el programa  
add $a1, $v0, $0            # Pasando primer valor a a1

la $a0, VALOR_B             # Cargando mensaje de indicación valor B
jal PRINT_CADENA            # Mostrando mensaje de indicación
jal MAYORZ                  # Llamando a funcion para validar valor > cero
                            # v1 es la salida de MAYORZ, es 1 cuando v0 < 0
bne $v1, $0, main           # si v1 != 0, repite el programa   
add $a2, $v0, $0            # Pasando primer valor a a2

jal MCD                     # llamando a función que calcula el mcd
                            # a1 y a2 son entradas, v0 es la salida

la $a0, RESULTADO_MCD       # Pasando primer valor de MCD
jal PRINT_CADENA            # Mostrando mensaje de indicación

add $a0, $v0, $0            # moviendo valor de v0 a a0 para mostrar el valor
jal PRINT_INTEGER           # mostrando el valor en a0

j main                      # repitiendo el programa

MCD:
# Esta funcoón toma toma dos valores y aplica el algoritmo euclidiano para 
# calcular el mcd. 
#
# Este algoritmo toma si b = 0, mcd = a 
# pero para los demás casos
# repite recursivamente el algoritmo hasta quedar con el valor b=0 
# 
# --- $a1: corresponde al primer valor de entrada
# --- $a2: corresponde al segundo valor de entrada
# --- $v0: corresponde al valor de salida, es decir al mcd.

addi $sp, $sp, -4               # Apartando espacio para $ra
sw $ra, 0($sp)                  # guardando el valor de $ra
beq $a2, $0, RESULTADO          # si el segundo valor es igual a cero
                                # no se aplicará a = b y b = a mod b
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
addi $sp, $sp, -4
li $v0, 5
syscall
sw $v0, 0($sp)

slt $v1, $v0, $0

beq $v1, $0, SALTAR_MENSAJE

li $v0, 4
la $a0, ERROR
syscall

lw $v0, 0($sp)
SALTAR_MENSAJE:
addi $sp, $sp, 4

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