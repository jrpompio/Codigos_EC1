# Tarea04
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
# 
# Este código solicita por medio de terminar un valor entero mayor a cero
# posterior mente entrega la sucesión de Farey en pantalla
#
# Para ello guarda fracciones unicamente mayores a 1, en su forma simplificada
# y ordenadas de valores menores a valores mayores
# se usa una función especifica para mostrar el contenido en pantalla
# pero necesita dos funciones, MCD para simplificar los valores mediante su 
# máximo común divisor, y BUBBLE_SORT_FRAQ que es bubble sort adaptada a
# fracciones.
.data 

msj_entrada: .ascii "\n\n"
             .ascii "Introduzca un valor entero mayor a cero "
             .asciiz "para entregar las sucesion de Farey: \n-->"

msj_salida:  .ascii "\n"
             .asciiz "La sucesion de Farey correspondiente es: \n\n"


.text

main:

la $a0, msj_entrada             # Cargando mensaje para entrada de valor n
jal PRINT_CADENA                # Mostrando mensaje

addi $v0, $0, 5                 # Valor $v0 para input
syscall
add $a1, $0, $v0                # moviendo el valor ingresado hacia $a1

la $a0, msj_salida              # Cargando mensaje de salida relacionado 
                                # a la sucesion
jal PRINT_CADENA                # Mostrando mensaje

jal FAREY_SUC                   # Llamando a la función para mostrar
                                # la sucesion correspondiente a n

j main


FAREY_SUC:
# Esta función recibe un valor entero mayor a cero y devuelve la sucesion
# de Farey en pantalla  
#
# dicha función es dependiente de las funciones MCD y BUBBLE_SORT_FRAQ
# --- $a1: corresponde al valor natural a ingresar
#          para mostrar en pantalla la sucesion de Farey

addi $sp, $sp, -4        # <-- Apartando espacio en pila para guardar $s0
sw $s0, 0($sp)           # <-- Guardando $s0

addi $sp, $sp, -8        # <-- Apartando espacio en pila para guardar
                         #     dos ceros al final de la lista.
                         # Esto servirá para detener algún escaneo

mul $t9, $a1, $a1        # <-- Creando valor para reservar espacio en pila
sll $t9, $t9, 2          #     que es el cuadrado de n multiplicado por 4
sub $sp, $sp, $t9        # <-- Apartando espacio en pila para numeradores
sub $sp, $sp, $t9        # <-- Apartando espacio en pila para denominadores
add $t0, $0, $sp         # <-- Variable temporal control pila numerador

addi $t8, $0, 1          # <-- Creando variable de aumento para numeradores
addi $t6, $a1, 1         # <-- aumentando valor de parametro
                         #     para ser usado en ciclo for 
                         #     y pasando a variable temporal
                         #     ya que se usará otra función que usa a1

addi $t2, $0, 1          # Anticipando valores 1/1 para control
sw $t2, 0($sp)           # de numeros repetidos
sw $t2, 4($sp)           # ya que se debe tener un valor inicial para comparar
sw $0,  8($sp)           # y agregando 0/0 después de 1/1 
sw $0,  12($sp)          # ya que se debe tener un valor final para detener

FOR_NUMERADORES:

addi $t7, $0, 1          # <-- Creando variable de aumento para denominadores

    FOR_DENOMINADORES:
                                   # No agregando valores mayores a 1
    slt $t1, $t7, $t8              # <-- si dem < num  t1 = 1
    bne $t1, $0, DEN_MAS_1         # <-- siguiente elemento si t1 no es 0

                                   # Simplificando
    add $a2, $0, $t8               # <-- Preparando valores para función MCD
    add $a1, $0, $t7 

    add $t2, $0, $ra               # <-- Guardando $ra en temporal 
    jal MCD                        # <-- Llamado a función
    add $ra, $0, $t2               # <-- restaurando $ra
    
    div $t8, $v0                   # <-- Se divide el numerador entre el MCD
    mflo $t5                       # <-- Se pasa el resultado a t5 
    div $t7, $v0                   # <-- Se divide el denominador entre el MCD
    mflo $t4                       # <-- Se pasa el resultado a t4
    
    add $t2, $0, $sp               # <-- Se pasa el puntero a una varibale 
                                   # este puntero tiene el inicio del arreglo
                                   # de las fracciones

    while:
    lw $a2, 0($t2)                 # obteniendo valor del numerador
    lw $a1, 4($t2)                 # obteniendo valor del denominador
    beq $a1, $0, SALVANDO_DATOS    # si el denominador es igual a cero
                                   # se procede a guardar la fracción
                                   # ya que el lugar de eleminar el valor
                                   # se decide en su lugar, no guardarlo

    bne $a2, $t5, NUM_DIFERENTE    # Se verifica si el numerador es diferente
                                   # al numerador del arreglo almacenado
                                   # para en caso de ser diferente proceder
                                   # al siguiente numerador almacenado.

        beq $a1, $t4, DEN_MAS_1    # Se verifica si el denominador es igual
                                   # en caso de ser iguales, no se guarda 
                                   # el valor, y se procede a denominador + 1
    NUM_DIFERENTE:
    addi $t2, $t2, 8               # <-- siguientes dos elementos (fracción)
    j while

    SALVANDO_DATOS:
    addi $t0, $t0, 8        # <-- siguientes dos elementos 
    sw $t5, 0($t0)          # <-- Guardando numerador
    sw $t4, 4($t0)          # <-- Guardando denominador
    sw $0, 8($t0)           # <-- Guardando 0/0 para indicar fin del arreglo
    sw $0, 12($t0)          #     esto para poder detener algún loop
                            # Al inicio de la función se apartó espacio
                            # para este elemento, es decir, no se sobre pasará
                            # del valor de $sp original
    
    DEN_MAS_1:
    addi $t7, $t7, 1        # aumentando el valor del denominador  
    bne $t7, $t6, FOR_DENOMINADORES

addi $t8, $t8, 1
bne $t8, $t6, FOR_NUMERADORES

add $s0, $0, $ra               # <-- Guardando $ra en temporal 
add $a1, $0, $sp               # <-- Guardando $ra en temporal 
jal BUBBLE_SORT_FRAQ                        # <-- Llamado a función
add $ra, $0, $s0               # <-- restaurando $ra

add $t2, $0, $sp               # <-- puntero a temporal 2 para imprimir 
                               #     el array de la sucesion

li $v0, 11                      #
li $a0, 40                      #
syscall                         #  Toda esta seccion
li $a0, 48                      #  es usada para mostrar
syscall                         #  el inicio de la sucesion
li $a0, '/'                     #  que corresponde a:
syscall                         #
li $a0, 49                      #  
syscall                         #   ( 1/1, 
li $a0, 44                      # 
syscall                         #
li $a0, 32                      #
syscall                         #

LOOP_PRINT:
lw $t3, 0($t2)                  # Se carga el numerador
lw $t1, 4($t2)                  # Se carga el denominador

beq $t1, $0, END_LOOP_PRINT     # Si el denominador es igual a cero
                                # se termina el print
li $v0, 1                       # valor $v0 para imprimir un entero
add $a0, $t3, $0                # se pasa el valor del numerador a $a0
syscall                         

li $v0, 11                      # valor $v0 para imprimir un caracter ascii
li $a0, 47                      # caracter "/"
syscall                             


li $v0, 1                       
add $a0, $t1, $0                # se pasa el valor del numerador a $a0
syscall

li $v0, 11                  
li $a0, 44                      # caracter ","
syscall
li $a0, 32                      # espacio
syscall

addi $t2, $t2, 8                # Siguientes dos elementos (fraccion)
j LOOP_PRINT
END_LOOP_PRINT:

li $v0, 11                      #
li $a0, 49                      #
syscall                         #
li $a0, '/'                     #   Toda esta seccion es para mostrar
syscall                         #   el cierre de la sucesion
li $a0, 48                      #   es decir:
syscall                         #       
li $a0, 41                      #   1/0)
syscall                         #



add $sp, $sp, $t9        # <-- Devolviendo espacio en pila para numeradores
add $sp, $sp, $t9        # <-- Devolviendo espacio en pila para denominadores
addi $sp, $sp, 8         # <-- Devolviendo espacio en pila de ultimos ceros
lw $s0, 0($sp)           # <-- Guardando $s0
addi $sp, $sp, 4        # <-- Apartando espacio en pila para guardar $s0

jr $ra

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

BUBBLE_SORT_FRAQ:
addi $sp, $sp, -4               # <-- Apartando espacio para $ra
sw $ra, 0($sp)                  # <-- guardando el valor de $ra

SWAPING:                        # mientras los swap sean 0
li $t9, 0                       # variable de verificación de swap
add $t8, $0, $a1

ITERATION: 
lw $t1, 0($t8)          # se carga numerador i 
lw $t2, 4($t8)          # se carga el denominador i

lw $t3, 8($t8)          # se carga el numerador j
lw $t4, 12($t8)         # se carga el denominador j


beq $t4, $0, SALIR # si el denominador j es cero, se terminan las iteraciones

# obteniendo valores de referencia
mul $t5, $t1, $t4               # Valor de referencia de fracción [m]
mul $t6, $t3, $t2               # Valor de referencia de fracción [m + 1]

slt $t7, $t6,  $t5  

beq $t7, $0, NO_MINUS      # si no es menor se salta el cambio
sw $t1, 8($t8)             # se guarda numerador j en el lugar del numerador i 
sw $t2, 12($t8)        # se guarda denominador j en el lugar del denominador i

sw $t3, 0($t8)         # se guarda numerador i en el lugar del numerador j
sw $t4, 4($t8)         # se guarda denominador j en el lugar del denominador i
addi $t9, $t9, 1       # se hizo cambio, $t9 no es 0

NO_MINUS: 

addi $t8, $t8, 8                # Siguiente elemento
j ITERATION

SALIR:
beq $t9, $0, NOT_SWAP           # Si no se realiza ningun swap se termina
j SWAPING

NOT_SWAP: 
lw $ra, 0($sp)                  # <-- carga de registro $ra guardado
addi $sp, $sp, 4                # <-- devolviendo puntero a su valor original

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

# Conclusiones:
#   - El código contiene funciones usadas en trabajos anteriores
#     por lo qué fue buena práctica realizar esas funciones de manera que
#     se pudiesen reusar en otros codigos sin generar problemas
#   - El código no es muy optimo, contiene varias secciones que iteran 
#     de forma cuadrática, el espacio en pila se reserva el doble del cuadrado
#     del valor ingresado, 
