.data 
    msj: .asciiz "hola 1 \n"
    msj2: .asciiz "hola 2 \n"

.text
    li $v0, 4
    
    li $s0, 1
    li $s1, 1

    beq $s0, $s1, iguales
    
    la $a0, msj
    
 
     j end
iguales:
    la $a0, msj2
    
end:

	syscall
