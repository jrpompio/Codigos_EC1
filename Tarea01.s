.data
Array: .word 87, 216, -54, 751, 1, 36, 1225, -446,
-6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1,
544, 6, 7899, 74, -42, -9, 0

.text 

main:

la $a1, Array
jal mayor_menor 



j end_funcions

mayor_menor:
# Para encontrar el mayor
	addi $t7, $a0, 0 # Guardando puntero de array en valor temporal
	
	
	loop1:
		lw $t0, 0($t7)
		addi $t6, $a0, 0 # Guardando puntero de array en valor temporal
		addi $t3, $0, 0 # variable de puntaje
		sub  $t4, $t7, $a0  # Desfase entre elemento 0 y elemento analizado
		
		loop2:
			lw $t1, 0($t6)
			slt $t2, $t0, $t1 # $t2 = 1 si A[M] es menor que A[N]
			add $t3, $t3, $t2 # variable de puntaje 		
			addi $t6, $t6, 4  
			lw $t1, 0($t6)
			addi $s0, $s0, 1
		bne $t1, $0, loop2
		
		add $t5, $sp, $t4
		sw $t3, 0($t5)
		addi $t7, $t7, 4
		lw $t0, 0($t7)
	bne $t0, $0, loop1
	
	addi $t7, $sp, 0
	
	loop3:
	lw $t0, 0($t7)
	sub $t1, $t7, $sp
	addi $t7, $t7, 4
	bne $t0, $0, loop3
	
add $t3, $a0, $t1
lw  $v1, 0($t3)
jr $ra

end_funcions:



