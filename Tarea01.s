.data
Array: .word 87, 216, -54, 751, 1, 36, 1225, -446,
-6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1,
544, 6, 7899, 74, -42, -9, 0

.text 
main:
la $a0, Array
jal mayor_menor 


j end_funcions

mayor_menor:
# Para encontrar el mayor	
	addi $sp, $sp, -20
	addi $t7, $a0, 0 # Guardando puntero de array en valor temporal
	addi $t8, $0, 0  # variable para contar tamaño de lista (contando el cero)
	
	loop0:           # Loop para control del puntero
		lw $t0, 0($t7)
		addi $t8, $t8, 4 # espacio = 1 word
		addi $t7, $t7, 4 # se analizará el siguiente elemento
	bne $t0, $0, loop0   # si el elemento futuro no es cero se repite
	sub $sp, $sp, $t8    # Puntero = puntero - espacio_de_lista
	
	addi $t7, $a0, 0 #  Reiniciando el puntero temporal del Array
	
	loop1: # Loop de analisis para elemto M 
		addi $t6, $a0, 0 # Guardando puntero de array en valor temporal para loop2
		lw $t0, 0($t7) # Cargando primer elemento del Array
		addi $t3, $0, 0 # variable de puntaje que aumentará en 1
						# si el elemento M es menor al elemento N
		addi $t9, $0, 0 # variable de puntaje que aumentará en 1
						# si el elemento M es mayor al elemento N
						
		sub  $t4, $t7, $a0  # Desfase entre elemento 0 y elemento analizado
		
		loop2: # Loop de analisis de lemento N
			lw $t1, 0($t6)    # Carga de elemento N
			
			slt $t2, $t0, $t1 # $t2 = 1 si A[M] es menor que A[N]
			add $t3, $t3, $t2 # variable de puntaje para numero mayor 		
			
			slt $t2, $t1, $t0 # $t2 = 1 si A[N] es menor que A[M]
			add $t9, $t9, $t2 # variable de puntaje para numero menor 		
			
			addi $t6, $t6, 4  # Se analizará N + 1
			lw $t1, 0($t6)    # Se carga para N previamente al bne, 
							  # para no analizar el elemento cero
							  
							  # BORRAR ANTES DE ENTREGAR
			addi $s0, $s0, 1  # variable de control para ver cuantas iteraciones se hacen 
			       			  # BORRAR ANTES DE ENTREGAR
			       			  
		bne $t1, $0, loop2    # Reinicio de Loop2 
							  # si el elemento N en $t1 = 0
		# Creando lista 1, puntaje de numero mayor
		add $t5, $sp, $t4     # Se añade al puntero, el valor
							  # que corresponde al indice del elemento M analizado
							  
		sw $t3, 0($t5)        # Se guarda el puntaje del elemento M analizado
		
		# Creando lista 2, puntaje de numero menor
		sub $t5, $t5, $t8     # Se corre el puntero para guardar este segundo array
							  # correspondiendo igualmente al indice del elemento M
							  
		sw $t9, 0($t5)        # Se guarda el puntaje del elemento M analizado
		
		
		addi $t7, $t7, 4      # Se analizará M + 1
		lw $t0, 0($t7)        # Se carga para M previamente al bne, 
							  # para no analizar el elemento cero        
	bne $t0, $0, loop1		  # Reinicio de Loop1 
							  # si el elemento M en $t0 = 0
	

	
	addi $t7, $sp, 0          # Variable temporal para usar el puntero
							  # de lista 1
	
	loop3:  # Loop de busqueda del valor mayor
	lw $t0, 0($t7) # Carga el array de los puntajes
	sub $t1, $t7, $sp # desfase con el puntero 
	addi $t7, $t7, 4  # Aumenta en 4 para encontrar el indice siguiente
	bne $t0, $0, loop3
	
add $t3, $a0, $t1 # Una vez encontrado el indice del elemento mayor
				  # Se crea un temporal desde la dirección cero del array
				  # y se le suma el indice del cero encontrado anteriormente
				  # que corresponde al elemento de mayor valor
				  
lw $v1, 0($t3)    # Se guarda valor mayor 


#--------------------------------------------------------------------------------
	sub $sp, $sp, $t8  # Desplazamiento del puntero hacia lista 2 
	
	addi $t7, $sp, 0          # Variable temporal para usar el puntero
							  # de lista 2
	
	loop4:  # Loop de busqueda del valor menor
	lw $t0, 0($t7) # Carga el array de los puntajes
	sub $t1, $t7, $sp # desfase con el puntero 
	addi $t7, $t7, 4  # Aumenta en 4 para encontrar el indice siguiente
	bne $t0, $0, loop4
	
add $t3, $a0, $t1 # Una vez encontrado el indice del elemento mayor
				  # Se crea un temporal desde la dirección cero del array
				  # y se le suma el indice del cero encontrado anteriormente
				  # que corresponde al elemento de mayor valor
				  
lw $v0, 0($t3)    # Se guarda valor menor

jr $ra


end_funcions: