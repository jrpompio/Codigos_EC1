# Tarea03
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
#
.data 

msj_prueba: .asciiz "El programa está corriendo \n"


.text

main:

li $a1, 5


jal FAREY_SUC

li $v0, 10
syscall


#
# FUNCIONES
#

FAREY_SUC:
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

 add $s2, $0, $ra               # <-- Guardando $ra en temporal 

add $a1, $0, $sp               # <-- Guardando $ra en temporal 
jal BUBBLE_SORT_FRAQ                        # <-- Llamado a función
 add $ra, $0, $s2               # <-- restaurando $ra

add $t2, $0, $sp

LOOP_PRINT:
lw $t3, 0($t2)
lw $t1, 4($t2)

beq $t3, $0, END_LOOP_PRINT

li $v0, 1 
add $a0, $t3, $0
syscall

li $v0, 11
li $a0, 47
syscall


li $v0, 1 # para depurar
addu $a0, $t1, $0
syscall

li $v0, 11
li $a0, 44
syscall
li $a0, 32
syscall

addi $t2, $t2, 8
j LOOP_PRINT
END_LOOP_PRINT:

add $sp, $sp, $t9        # <-- Devolviendo espacio en pila para numeradores
add $sp, $sp, $t9        # <-- Devolviendo espacio en pila para denominadores

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

SWAPING:              # mientras los swap sean 0
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
j SWAPING

notwhile: 

lw $ra, 0($sp)                  # <-- carga de registro $ra guardado
addi $sp, $sp, 4                # <-- devolviendo puntero a su valor original

jr $ra


# Conclusiones:

