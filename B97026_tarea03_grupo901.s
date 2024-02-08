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
la $a0, bienvenida          # <-- Cargando mensaje de bienvenida
jal PRINT_CADENA            # <-- Mostrando mensaje en pantalla

la $a0, VALOR_A             # <-- Pasando primer valor a a1
jal PRINT_CADENA            # <-- Mostrando mensaje de indicación
la $a3, ERROR               # <-- Cargando mensaje de error para MAYORZ
                            #     solo se necesita hacer una vez
                            #     puesto que no se requiere modificar
jal MAYORZ                  # <-- Llamando a funcion para validar valor > cero
                            # v1 es la salida de MAYORZ, es 1 cuando v0 < 0
bne $v1, $0, main           # <-- si v1 != 0, repite el programa  
add $a1, $v0, $0            # <-- Pasando primer valor a a1

la $a0, VALOR_B             # <-- Cargando mensaje de indicación valor B
jal PRINT_CADENA            # <-- Mostrando mensaje de indicación
jal MAYORZ                  # <-- Llamando a funcion para validar valor > cero
                            # v1 es la salida de MAYORZ, es 1 cuando v0 < 0
bne $v1, $0, main           # <-- si v1 != 0, repite el programa   
add $a2, $v0, $0            # <-- Pasando primer valor a a2

jal MCD                     # <-- llamando a función que calcula el mcd
                            # a1 y a2 son entradas, v0 es la salida

la $a0, RESULTADO_MCD       # <-- Cargando mensaje de indicación MCD
jal PRINT_CADENA            # <-- Mostrando mensaje de indicación

add $a0, $v0, $0            # <-- moviendo valor de v0 a a0
                            # para mostrar el valor
jal PRINT_INTEGER           # <-- mostrando el valor en a0

j main                      # <-- repitiendo el programa

MCD:
# Esta funcoón toma toma dos valores y aplica el algoritmo euclidiano para 
# calcular el mcd. 
#
# Este algoritmo toma si b = 0, mcd = a 
# pero para los demás casos
# repite recursivamente el algoritmo hasta quedar con el valor b=0
# pero cada vez que se repite  a = b, el valor presente de b, pasa al valor
# futuro de a.
# y b = a mod b, a modulo b, en donde el resultado que se entrega es lo mismo
# que el residuo de dividir a/b, por lo que el mcd entre los dos valores
# será el penultimo residuo encontrado antes del residuo cero.  
# 
# --- $a1: corresponde al primer valor de entrada
# --- $a2: corresponde al segundo valor de entrada
# --- $v0: corresponde al valor de salida, es decir al mcd.

addi $sp, $sp, -4               # <-- Apartando espacio para $ra
sw $ra, 0($sp)                  # <-- guardando el valor de $ra
                                # ya que se usará recursión
beq $a2, $0, RESULTADO          # <-- si el segundo valor es igual a cero
                                # no se aplicará a = b y b = a mod b
div $a1, $a2                    # <-- se necesita el residuo de a/b 
addi $a1, $a2, 0                # <-- se mueve el valor de presente de b
                                # hacia el valor futuro de a
mfhi $a2                        # <--  el residuo de la division anterior
                                # se mueve hacia el valor futuro de b

jal MCD                         # <-- Se usa recursión

RESULTADO:                      # <-- etiqueta para entregar el resultado
add $v0, $a1, 0                 # cuando b = 0
lw $ra, 0($sp)                  # <-- carga de registro $ra guardado
addi $sp, $sp, 4                # <-- devolviendo puntero a su valor original
jr $ra

MAYORZ:
# Esta función sirve para validar si un numero es mayor o igual a cero
# este numero debe ser la salida de otra función, la cual su salida esté en
# el registro $v0.
# El valor de salida $v1 servirá para usarse con un branch
# a donde se deba saltar.
# --- $a3: entrada de dirección correspondiente al mensaje de error
# --- $v0: valor a validar si es mayor a cero
# --- $v1: valor de salida $v1=1 si el numero es menor a cero
#                          $v1=0 si el numero es mayor o igual a cero

addi $sp, $sp, -4           # <-- apartando espacio para guardar el valor $v0
                            # ya que se usará para mostrar un mensaje
li $v0, 5                   # <-- valor de syscall input
syscall
sw $v0, 0($sp)              # <-- guardando valor en v0

slt $v1, $v0, $0            # <-- valor de salida de la función

beq $v1, $0, SALTAR_MENSAJE # <-- si el valor no es erroneo, se salta
                            # la sección que muestra el mensaje

li $v0, 4                   
move $a0, $a3
syscall                     # <-- mostrando mensaje de error

lw $v0, 0($sp)              # <-- cargando valor de v0

SALTAR_MENSAJE:             
addi $sp, $sp, 4            # <-- devolviendo el puntero

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

    lw $v0, 0($sp)
    addi $sp, $sp, 4
jr $ra

# Conclusiones:
# - El programa usa recursión, por lo que sirve para practicar como usar esta
#   propiedad en ensamblador. 
# - El código está basado en su mayor parte en funciones, por lo qué es 
#   altamente reciclable y muy corto.
# - Fue muy útil el algoritmo euclidiano para resolver el MCD, ya que dicha
#   impementación acorta mucho el trabajo.