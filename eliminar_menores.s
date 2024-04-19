.data # Etiqueta para crear tipos de datos y almacenarlos en memoria de datos

Numeros:  # Etiqueta para el nombre del dato
# etiqueta .word para tamaño de cada dato, tamaño de 1 palabra = 32 bits
.word 8, 6, -5, 1, -23, 3, 25, -446, -6695, -8741, 13, 9635, 0

mensajeArr: .asciiz "Mostrando arreglo: \n"
mensajeRe: .asciiz "Mostrando arreglo después de ReLU: \n"
mensajeExit: .asciiz "\n\nSaliendo del programa... \n"

.text # etiqueta para instrucciónes, memoria de instrucciones


main: # etiqueta de función principal

addi $v0, $0, 4
la $a0, mensajeArr
syscall

la $a0, Numeros             # Carga primer elemento del array Numeros
addi $a1, $0, 13            # len de Numeros 
jal PrintNumberArray        # usa función para mostrar array

la $a0, Numeros             # Carga primer elemento del array Numeros
addi $a1, $0, 13            # len de Numeros 
jal ReLU                    # usa función para mostrar array

addi $v0, $0, 11            # syscall de un caracter
addi $a0, $0, 10            # 10 en $a0 corresponde a un salto de linea (\n)
syscall                     # salto de linea
syscall                     # salto de linea de nuevo


addi $v0, $0, 4
la $a0, mensajeRe
syscall

la $a0, Numeros             # Carga primer elemento del array Numeros
addi $a1, $0, 13            # len de Numeros 
jal PrintNumberArray        # usa función para mostrar array


addi $v0, $0, 4
la $a0, mensajeExit
syscall

addi $v0, $0, 10  # $v0 = 10 que es la llamada del sistema a la función exit
syscall     # ejecutar llamada del sistema

# FUNCIONES

PrintNumberArray:
# $a0: SE DEBE tener la dirección en memoria del array a mostrar en pantalla
# $a1: es el valor del tamaño del array
    addi $t9, $a0, 0    # $t9 = $a0 + 0: ahora $t9 es la direccion en memoria
                                         # De dicho arreglo
    addi $t8, $0, 0     # $t8 = i = 0   
    loopPrint:                  # etiqueta de inicio para bucle
    lw $t0, 0($t9)              # carga de valor
    
    slt	$t1, $t8, $a1        # si, $t8 < $a1; $t1 = 1

    beq $t1, $0, tnirPpool      # condicion de parada

    # Codigo interno del bucle
    addi $a0, $t0, 0            # $a0 es lo que se requiere imprimir
    addi $v0, $0, 1
    syscall

    addi $v0, $0, 11
    addi $a0, $0, ','
    syscall
    # fin del codigo interno del bucle
    
    addi $t9, $t9, 4            # siguiente palabra (4bytes)
    addi $t8, $t8, 1            # i++
    j loopPrint                 # repetir bucle
    tnirPpool: # etiqueta para fin del bucle

jr $ra                          # Salida hacia después del jal

# Esta función cambia los valores negativos de un array de enteros a el valor
# cero

ReLU:
# $a0: SE DEBE tener la dirección en memoria del array a aplicar la función
# $a1: es el valor del tamaño del array

    addi $t8, $0, 0             # $t8 = i = 0   
    loopReLU:                   # etiqueta de inicio para bucle
    lw $t0, 0($a0)              # carga de valor
    
    slt	$t1, $t8, $a1           # si, $t8 < $a1; $t1 = 1
    beq $t1, $0, ULeRpool       # condicion de parada

    # Codigo interno del bucle

    slt $t2, $t0, $0            # si, $t0 < $0; $t2 = 1
    beq $t2, $0, esMayor        # si es mayor salta
    sw $0, 0($a0)

    # fin del codigo interno del bucle
    
    esMayor:
    addi $a0, $a0, 4            # siguiente palabra (4bytes)
    addi $t8, $t8, 1            # i++
    j loopReLU                 # repetir bucle

    ULeRpool:                   # etiqueta para fin del bucle    

jr $ra