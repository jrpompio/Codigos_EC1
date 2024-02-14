# Tarea03
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
#
.data 

msj_prueba: .asciiz "El programa está corriendo \n"


.text

main:

li $a1, 3


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

addi $t8, $0, 1         # <-- Creando variable de aumento para numeradores


FOR_NUMERADORES:

    addi $t7, $0, 1         # <-- Creando variable de aumento para denominadores

    FOR_DENOMINADORES:
    sw $t8, 0($t0)          # <-- Guardando numerador
    addu $t0, $t0, $t9       # <-- Desplazando a lista de denominador
    sw $t7, 0($t0)          # <-- Guardando denominador
    sub $t0, $t0, $t9       # <-- Desplazando a lista de numerador
    addi $t0, $t0, 4        # <-- siguiente elemento 
                            li $v0, 1 # para depurar
                            addu $a0, $t8, $0
                            syscall
                            addu $a0, $t7, $0
                            syscall

    addi $t7, $t7, 1        # aumentando el valor del denominador
    slt $t1, $t7, $a1
    bne $t1, $0, FOR_DENOMINADORES







jr $ra

# Conclusiones:










































