addi $sp, $sp, -24 # espacio para 24 bytes
li $v0, 4 # print
li $t0, 100  # variable de control del ciclo de saltos
li $s0, 0 # variable a controlar

inicio: # etiqueta para repetir el ciclo

slti $t1, $t0, 66  # si $t0 >= 66; $t1=1

bne $t1, $0, fin_for # si $t1 =/ 0 saltar a fin_for

sb $t0, 0($sp) # guardar byte en la dirección almacenada en $sp

addi $t0, $t0, -1 # reduce $t0 en 1 cada vez que cicle
addi $s0, $s0, 1 # aumentar $t0 en 1 cada vez que cicle

j inicio # saltar al inicio
fin_for: # etiqueta para fin del for

addi $a0, $sp, 0 # añadir dirección del puntero
syscall # al ser el byte de la dirección en memoria correspondiente a $sp
        # un valor igual a 65, mostrará B en pantalla
