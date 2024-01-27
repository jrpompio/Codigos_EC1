.data 
                                    # Definiendo cadenas de texto
	msj_entrada:
	        .ascii "La cadena:"
		.asciiz "\n"	
    	cadena: .asciiz "aibofobia"    
	
	msj_si: .ascii "\n\n"
		.asciiz "Es palindromo\n"
	
	msj_no: .ascii "\n\n"
		.asciiz "No es palindromo\n"
.text
main:                       # Codigo principal
    li $v0, 4               # Valor 4 para mostrar contenido de cadena en pantalla
    la $a0, msj_entrada
    syscall
    la $a0, cadena
    syscall

    la $a0, cadena          # Se pasa dirección de inicio de la cadena a $a0
    jal UPPER               # Se llama a la función para cambiar minusculas por mayusculas
                            # que usa el argumento $a0 y devuelve $v1
    addi $a1, $v1, 0        # La salida de la función UPPER se pasa a $a1
    			            # También el inicio de la cadena en $a0
    jal PALINDROMO          # Se llama a la función para identificar palindromo 
					        # que usa los argumentos $a0, $a1 y devuelve $s1 = 1
					        # en caso de ser palindromo, $s1 = 0 en caso de que no sea.
    beq $s1, $0, no_msj     # si no es palindromo se pasa el inicio de la cadena 
    					    # al argumento $a0 para mostrar este mensaje
    la $a0, msj_si          # En caso contrario, se pasa el inicio de la cadena
    			            # del mensaje contrario
    j mensaje               # Se salta para no pasar por el mensaje de resultado negativo
    
    no_msj:
    la $a0, msj_no 
    
    mensaje: 

	syscall                 # se muestra el mensaje en pantalla
    
 	addi $v0, $0, 10        # el valor 10 corresponde al syscall de exit
 	syscall
 
 UPPER:             # Función para cambiar minusculas por mayusculas
 		            # Argumentos de entrada $a0: Argumento de inicio de la cadena de texto
 		            # que termina en valor nulo (asciiz)
 		            # Valor de salida $v1: tamaño de la cadena, incluyendo valor nulo. 
 		            # La función módifica el la cadena de texto original
 		            # convierte las minusculas en mayusculas.
 
 
 	addi $t0, $a0, 0    # Se pasa la dirección del inicio de la cadena
 					    # a un valor temporal
 					 
 	addi $t7, $0, 0     # Se inicializa $t7 en cero, es un contador
  
 	WHILE:              # mientras el caracter no sea nulo
	addi $t7, $t7, 1    # Se aumenta el contador en uno
					    # Al final contendrá el tamaño de la cadena
 	lb $t2, 0($t0)      # Se carga el byte con la dirección temporal

	slti $t1, $t2, 123  # si t2 es menor a 123 t1=1
 	slti $t3, $t2, 97   # si t2 es mayor o igual a 97 t2 = 0  
 
	                    # RANGO : [97;123[
 	
	beq $t1, $0, NO_ES_MINUSCULA        # Si el valor no está dentro de este rango
 	bne $t3, $0, NO_ES_MINUSCULA        # Se saltará hasta la etiqueta mostrada
 
	addi $t2, $t2, -32                  # En caso de ser minuscula se le resta 32
 
	 NO_ES_MINUSCULA: 
 
 	# si se requiere guardar en otro array, se agrega acá
 	# la linea para desfasar el puntero temporal
 	# ya que después se guardará
 
 	sb $t2, 0($t0)          # Se guarda el byte haya o no cambio 
 				            # Esta linea se ubica acá por si hay una modificación futura
 				            # si se requiere guardar la cadena en otro array
 	addi $t0, $t0, 1        # Se aumenta el valor del puntero temporal
 					        # Para acceder al siguiente byte
 
 	bne $t2, $0, WHILE      # si el byte analizado es diferente a cero
 					        # Se repite el while
 	                    # Tamaño de la cadena (contando el valor nulo)
 	addi $v1, $t7, 0    # Se mueve el valor del registro temporal
 					    # Al registro que se usa como salida de esta función
 	jr $ra              # Se devuelve al valor pc + 4 a pc que se guardó en $ra
 		                # al momento de hacer jal a la función
 
 PALINDROMO:            # Función que identifica si es un palindromo o no
 	addi $t0, $a0, 0    # Se pasa el inicio de la cadena 
 	addi $t1, $a0, 0    # a dos registros temporales $t0 y $t1
 	addi $t5, $a1, -2   # El tamaño de la cadena es n sin embargo se debe restar 1
 					    # Por el valor nulo, que no se analizará 
 					    # y -1 por que el primer elemento de la cadena es 0
	add $t1, $t1, $t5   # Se suma al segundo registro temporal el valor
					    # del último indice de la cadena
					    # así se compara el primero y el ultimo caracter de la cadena
 	srl $t5, $t5, 1     # si una cadena mide n, siendo n un valor par
 					    # se debe iterar la comparación n/2 veces como minimo
 					  
 	addi $t5, $t5, 1    # Se aumenta la cantidad de iteraciones en 1
 					    # Para los casos cuando el valor de la cadena sea impar
 					    # o sea de tamaño 1, ya se no se iterará ningúna vez
 					    # y se obtendrá como resultado que no es palindromo
 	
 	FOR:                # Se etiqueta a este loop como for	
 	lb $t7, 0($t0)      # Se carga el byte inferior 
 	lb $t6, 0($t1)      # Se carga el byte superior
 	
 	bne $t7, $t6, NO_ES     # Para el primer caso en que la comparación
 						    # indique que no son iguales, ya se termina 
 						    # ya que se tiene la certeza de que no es un 
 						    # palindromo
 	
 	addi $t5, $t5, -1   # Se resta uno al valor de control de iteración
 	addi $t0, $t0, 1    # Se aumenta uno al valor de dirección del byte inferior
 	addi $t1, $t1, -1   # Se resta uno al valor de dirección del byte superior
 		
	bne $t5, $0, FOR    # siempre y cuando la variable de control
					    # no llegue a cero, se repetirá
	
	j SI        # si no se encontró ninguna comparación en la que indique
		    # que la cadena no es un palindromo, se salta al valor que indica 
		    # que si lo es $s1 = 1
 	
 	NO_ES:
 	addi $s1, $0, 0     # $s1 = 0, indica que no es un palindromo
 	j FIN               # se salta a la etiqueta "fin" para no pasar 
 		            # por el valor que indica que si es un palindromo
 	
 	SI:
 	addi $s1, $0, 1
 	
 	
 	FIN:
 	jr $ra              # Se devuelve al valor pc + 4 a pc que se guardó en $ra
 		            # al momento de hacer jal a la función
