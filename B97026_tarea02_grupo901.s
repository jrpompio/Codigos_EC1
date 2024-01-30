# Tarea02
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026

.data
cadena_parentesis: .asciiz ")hola({)}"

.text
main:
addi $s0, $0, 100
la $a0, cadena_parentesis
jal VALIDACION_PARENTESIS



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

# acá se debe guardar los parentesis de inicio para reconocer cual debe ser 
# el siguiente parentesis de cierre
# no se debe tener uno de cierre sin su pareja previa de inicio

add $sp, $sp, $s0   # devolviendo puntero
lw $s0, 0($sp)
addi $sp, $sp, 4

jr $ra
EXIT:
# Esta función ejecuta el syscall de $v0 = 10
# que corresponde a la salida del programa
	addi $v0, $0, 10
	syscall	
	
jr $ra