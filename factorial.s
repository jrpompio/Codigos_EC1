main:
li $a0, 3
jal fact

j main_end

fact: 
addi $sp, $sp, -8 # Se ajusta la pila para guardar dos valores
sw $ra, 4($sp)    # Se guarda el valor de ra, ya que se usará recursión
sw $a0, 0($sp)    # Se guarda el valor de a0, mismo motivo que $ra

slti $t0, $a0, 1  # Se verifica si el argumento usado es menor a 1
                  # Si $a0 es menor a 1, entonces t0=1
beq $t0, $zero, noesmenor

addi $v0, $zero, 1 # Valor de retorno = 1
addi $sp, $sp, 8   # Se ajusta la pila a su valor inicial
jr $ra

noesmenor:
addi $a0, $a0, -1 # Se modifica el valor ingresado, restandole 1 a0 = a0 - 1
jal fact          # Se llama así misma por recursión

lw $a0, 0($sp)    # Se retoma el valor de a0, inicial
lw $ra, 4($sp)    # Se retoma el valor de ra, inicial

addi $sp, $sp, 8   # Se ajusta la pila a su valor inicial

mul $v0, $a0, $v0
jr $ra 

main_end:

