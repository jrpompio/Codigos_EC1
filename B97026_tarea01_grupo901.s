# Tarea01
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
#
# Este código toma un arreglo y encuentra los elementos de mayor y menor valor
# dentro del arreglo. El final del arreglo es marcado por el elemento cero.
#
# Usa un sistema de puntaje
#
# Si un elemento M es mayor a otro elemento N 
# recibe un punto en lista1; por cada elemento 
# al que M sea mayor a N al comparar,
# por lo que si un elemento M queda con cero puntos, este elemento es el menor
#
# Si un elemento M es menor a otro elemento N 
# recibe un punto en lista2; por cada elemento 
# al que M sea menor a N al comparar,
# por lo que si un elemento M queda con cero puntos, este elemento es el mayor
.data
Array: .word 87, 216, -54, 751, 1, 36, 1225, -446,
-6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1,
544, 6, 7899, 74, -42, -9, 0

msj1: .asciiz " \n Mostrando Array: \n "
msj2: .asciiz " \n Mostrando Array nuevamente: \n "
msj_mayor: .asciiz "\n Numero mayor: "
msj_menor: .asciiz "\n Numero menor: "

.text 
main:
la $a0, Array # Inicio del array en argument $a0

la $a1, msj1  	# Inicio de la cadena msj1 en argumento $a1
jal print_cadena # para usar función print_cadena
jal print_list	# Función print_list usa argumento $a0
				# y muestra el array cuyo puntero está en $a0

jal mayor_menor # Función para encontrar numero mayor y menor del array 
				# cuyo puntero se encuentra en $a0
				# $v0: Guarda el número menor
				# $v1: Guarda el numero mayor

la $a1, msj_mayor # Inicio de la cadena msj_mayor en argumento $a1
jal print_cadena  # para usar función print_cadena
jal valor_v1

la $a1, msj_menor # Inicio de la cadena msj_menor en argumento $a1
jal print_cadena  # para usar función print_cadena
jal valor_v0

la $a1, msj2     # Inicio de la cadena msj2 en argumento $a1
jal print_cadena # para usar función print_cadena
jal print_list  # Función print_list usa argumento $a0
				# y muestra el array cuyo puntero está en $a0


j end_funcions

mayor_menor:

# Esta función obtiene el número mayor y número menor de un array
# Usa un puntero el cual indica la dirección en la cual está la primera
# palabra del arreglo, analiza hasta encontrar el elemento cero
# el cual marca el fin del arreglo.
# $a0: argumento de dirección del elemento inicial del arreglo
# $v0: registro donde retorna el valor mínimo 
# $v1: registro donde retorna el valor máximo

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

				  # Ajustando $sp a su valor original
sub $sp, $sp, $t8   
sub $sp, $sp, $t8   

jr $ra

print_list:

# Esta función muestra en pantalla un arreglo
# usa como argumento de inicio la dirección en memoria del primer elemento
# que corresponde al arreglo, finaliza cuando encuentra un cero
# el cual no muestra en pantalla
# $a0: argumento de dirección del elemento inicial del arreglo
# Muestra la lista de la forma [a,b,c] \n


	addi $sp, $sp, -8 # apartando espacio en memoria para guardar $a0 y $v0
	sw  $a0, 4($sp)   # salvando valor de $a0 
	sw  $v0, 0($sp)	  # salvando valor de $v0
	addi $t0, $a0, 0  # salvando inicio de la lista en variable temporal
	
	addi $v0, $0, 11  # $v0 en 11 sirve para mostrar el caracter contenido en $a0
	addi $a0, $0, 91  # 91 en codigo ascii es: [
	syscall
	
	loop_list:
	addi $v0, $0, 1  # $v0 en 1 sirve para mostrar un número entero
	lw $a0, 0($t0)   # se carga el valor entero de la lista a mostrar
	syscall
	
	addi $t0, $t0, 4
	lw $a0, 0($t0)
	
	beq $a0, $0, no_coma
	
	addi $v0, $0, 11  # $v0 en 11 sirve para mostrar el caracter contenido en $a0
	addi $a0, $0, 44  # 44 en codigo ascii es: ,
	syscall	
	
	no_coma:
	bne $a0, $0, loop_list
	

	
	addi $v0, $0, 11  # $v0 en 11 sirve para mostrar el caracter contenido en $a0
	addi $a0, $0, 93  # 93 en codigo ascii es: ]
	syscall	
	
	addi $v0, $0, 11  # $v0 en 11 sirve para mostrar el caracter contenido en $a0
	addi $a0, $0, 10  # 10 en codigo ascii es un salto de linea \n
	syscall	
	
	lw  $v0, 0($sp)	# retornando valor de $v0
	lw  $a0, 4($sp)	# retornando valor de $a0
	addi $sp, $sp, 8 # devolviendo el puntero a su valor original
jr $ra

print_cadena:
# esta función obtiene del argumento el inicio de una cadena de carácteres
# tipo asciiz, muestra desde el primer elemento de la cadena
# hasta encontrar un valor 0 y detenerse
# $a1: argumento de dirección del elemento inicial de la cadena

	addi $sp, $sp, -8 # apartando espacio en memoria para guardar $a0 y $v0
	sw  $a0, 4($sp)   # salvando valor de $a0 
	sw  $v0, 0($sp)	  # salvando valor de $v0
	addi $t0, $a1, 0  # salvando inicio de la lista en variable temporal
					  # usará el argumento $a1
					  
	addi $v0, $0, 4 # el valor 4 en $v0 muestra en pantalla una cadena
			        # esta cadena empieza en la dirección de memoria que contiene $a0
			        
	addi $a0, $a1, 0 # inicio de la cadena de carácteres
	syscall
	
	lw  $v0, 0($sp)	# retornando valor de $v0
	lw  $a0, 4($sp)	# retornando valor de $a0
	addi $sp, $sp, 8 # devolviendo el puntero a su valor original
jr $ra

valor_v0:
# muestra en pantalla el valor correspondiente al registro $v0

	addi $sp, $sp, -8 # apartando espacio en memoria para guardar $a0 y $v0
	sw  $a0, 4($sp)   # salvando valor de $a0 
	sw  $v0, 0($sp)	  # salvando valor de $v0
	
	addi $a0, $v0, 0
	addi $v0, $0, 1
	syscall
	
	addi $v0, $0, 11  # $v0 en 11 sirve para mostrar el caracter contenido en $a0
	addi $a0, $0, 10  # 10 en codigo ascii es un salto de linea \n
	syscall	
	
	lw  $v0, 0($sp)	# retornando valor de $v0
	lw  $a0, 4($sp)	# retornando valor de $a0
	addi $sp, $sp, 8 # devolviendo el puntero a su valor original
	
jr $ra

valor_v1:
# muestra en pantalla el valor correspondiente al registro $v1
	addi $sp, $sp, -12 # apartando espacio en memoria para guardar $a0 y $v0
	sw  $v1, 12($sp)   # salvando valor de $v1
	sw  $a0, 4($sp)    # salvando valor de $a0 
	sw  $v0, 0($sp)	   # salvando valor de $v0
	
	addi $a0, $v1, 0
	addi $v0, $0, 1
	syscall
	
	addi $v0, $0, 11  # $v0 en 11 sirve para mostrar el caracter contenido en $a0
	addi $a0, $0, 10  # 10 en codigo ascii es un salto de linea \n
	syscall	
	
	lw  $v0, 0($sp)	   # retornando valor de $v0
	lw  $a0, 4($sp)	   # retornando valor de $a0
	lw  $v1, 12($sp)   # salvando valor de $v1
	addi $sp, $sp, 12   # devolviendo el puntero a su valor original
jr $ra




end_funcions:

# Conclusiones:
#  - El código es muy poco optimo, ya que se itera n^2 veces
#    donde n es el numero de elementos sin contar el cero.
#  - El código fue útil para poner en práctica todo lo aprendido en clases
#    por lo que es buen código para estudiar el uso de los comandos, además
#    es altamente reusable, debido a que la mayor parte se realizó con funciones