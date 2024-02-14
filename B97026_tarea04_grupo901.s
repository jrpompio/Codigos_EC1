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
FOR_NUMERADORES:

addi $t7, $0, 1          # <-- Creando variable de aumento para denominadores

    FOR_DENOMINADORES:
                                       # No agregando valores mayores a 1
    slt $t1, $t7, $t8                  # <-- si dem < num  t1 = 1
    bne $t1, $0, SIGUIENTE_ELEMENTO    # <-- siguiente elemento si t1 no es 0
    
                                       # Simplificando

    add $a2, $0, $t8                   # Preparando valores para función MCD
    add $a1, $0, $t7 
    
    add $t2, $0, $ra
    jal MCD
    add $ra, $0, $t2  
    
    div $t8, $v0
    mflo $t5
    div $t7, $v0
    mflo $t4

    # salvando datos

    sw $t5, 0($t0)          # <-- Guardando numerador
    sw $t4, 4($t0)          # <-- Guardando denominador
                            li $v0, 1 # para depurar
                            addu $a0, $t5, $0
                            syscall
                            addu $a0, $t4, $0
                            syscall
                            li $v0, 11
                            li $a0, 10
                            syscall
    
    SIGUIENTE_ELEMENTO:
    addi $t7, $t7, 1        # aumentando el valor del denominador  
    addi $t0, $t0, 8        # <-- siguientes dos elementos 
    bne $t7, $t6, FOR_DENOMINADORES

addi $t8, $t8, 1
bne $t8, $t6, FOR_NUMERADORES


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


# Conclusiones:

