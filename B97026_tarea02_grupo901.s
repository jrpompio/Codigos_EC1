# Tarea02
# Estudiante: Junior Ruiz Sánchez
# Carné: B97026
#
# Este código toma una cadena de texto, y de dicha cadena verifica la validez
# de los parentesis, tanto la paridad como orden de los mismos.
# 
# Muestra la cadena analizada y un mensaje del resultado de validez de los 
# parentesis de la cadena analizada. 
# 
# Para ello guarda en memoria el último parentesis de apertura encontrado,
# si se encuentra un parentesis de cierre que coincide con el tipo de 
# parentesis de apertura último, se pasa a buscar la concidencia del penultimo
# y de la misma manera sucesivamente hasta verificar todos los parentesis de
# cierre, de esta manera si todos los parentesis de cierre tienen su pareja
# correcta, se da la cadena como valida. 


.data
msj_init:       .ascii "\n"
                .asciiz "Mostrando Cadena:\n"

msj_valido:     .ascii  "\n\n"
                .ascii "----Resultado:\n"
                .asciiz "parentesis validos\n"

msj_invalido:   .ascii  "\n\n"
                .ascii "----Resultado:\n"
                .asciiz "parentesis invalidos\n"
                
cadena_1: .asciiz "Aca no hay parentesis"
cadena_2: .asciiz "muchos parentesis () [] {} {{{()}[]}()}"
cadena_3: .asciiz "este cierra 2 veces sin abrir])”"
cadena_4: .asciiz "[{y este último cierra en un orden incorrecto]}"


.text
main:
                        # Solo se comentará para la primera cadena
                        # es lo mismo para las demás
la $a0, msj_init            # <-- Se carga el primer elemento de msj_init
jal PRINT_CADENA            # Se muestra dicha cadena cargada
la $a0, cadena_1            # <-- Se carga el primer elemento de cadena_1
jal PRINT_CADENA            # <-- Se muestra dicha cadena cargada
jal VALIDACION_PARENTESIS   # <-- Se Usa la función
jal VALIDACION_VO           # <-- Se muestra el mensaje de validación
                            # que está relacionado a V0

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_2
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_3
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO

la $a0, msj_init
jal PRINT_CADENA
la $a0, cadena_4
jal PRINT_CADENA
jal VALIDACION_PARENTESIS
jal VALIDACION_VO


jal EXIT

VALIDACION_PARENTESIS:
# Está función toma un arrglo, lo analiza elemento por elemento, encuentra un
# parentesis de apertura de tipo "(,[,{" y busca la coincidencia del último 
# parentesis encontrado para verificar que el orden sea el correcto
# --- $a0: Debe ser el valor de dirección del primer elemento de la cadena
#              tipo ascciz, por qué debe terminar en valor nulo.
# --- $v0: Valor de retorno. $v0 = 1 si la cadena contiene parentesis validos
#              $v0 = 0 si la cadena contiene parentesis no validos

addi $sp, $sp, -4  # apartando espacio en puntero para $s0
sw $s0, 0($sp)     # Salvando el valor de $s0
addi $s0, $0, 0    # Variable tamaño de cadena
addi $t0, $a0, 0   # t0 dirección primer elemento de la cadena, hacia temporal

LEN:                # Loop para medir el tamaño de la cadena, contando el
                    # contando el valor nulo \0
lb $t1, 0($t0)      # <-- se sustrae el valor de la cadena
addi $s0, $s0, 1    # <-- se aumenta el contador en 1 por cada elemento
beq $t1, $0, NEL    # <-- si el elemento es cero, se termina el loop
addi $t0, $t0, 1    # <-- se pasa al siguiente elemento (byte)
j LEN               # <-- se repite el loop
NEL:                # <-- etiqueta para fin de loop

sub $sp, $sp, $s0   # se aparta tamaño en en memoria igual a la cadena
                    # se asume que todos los caracteres son paréntesis

addi $t9, $0, 40    # Registro para guardar ( 
addi $t8, $0, 41    # Registro para guardar )
addi $t7, $0, 91    # Registro para guardar [
addi $t6, $0, 93    # Registro para guardar ]
addi $t5, $0, 123   # Registro para guardar {
addi $t4, $0, 125   # Registro para guardar }

addi $sp, $sp, -1   # Se ocupa un byte más, para guardar como último
                    # parentesis el valor 0, ya que si aparece un parentesis
                    # de cierre, antes que uno de apertura, es un error

addi $t3, $sp, 0    # Variable temporal para usar el puntero
sb   $0, 0($t3)     # <-- se guarda el valor cero al inicio de la cadena
                    # esta cadena solo tendrá parentesis de apertura
                    # que aun no tengan coincidencia

addi $t0, $a0, 0    # t0 dirección primer elemento, hacia valor temporal

PURGE:              # Este loop verificará las coincidencias de los parentesis
lb $t1, 0($t0)      # <-- se carga el primer elemento de la cadena principal
beq $t1, $0, EGRUP  # <-- si este elemento es cero, se termina el loop
lb  $t2, 0($t3)     # <-- se carga el ultimo elemento existente de la cadena
                    # de prentensis de apertura
beq $t1, $t9, ABRE  # <--|
beq $t1, $t7, ABRE  # <--| Si se encuentra un parentesis de apertura se pasa 
beq $t1, $t5, ABRE  # <--| al loop de apertura

j CIERRA            # <-- Si no coincide se salta hacia el loop de cierre

ABRE:               # Loop de apertura
addi $t3, $t3, 1    # <-- si se encuentra un parentesis de apertura, se pasa
                    # al siguiente elemento de la cadena secundaria
sb $t1, 0($t3)      # <-- en dicho espacio se guarda el parentesis de apertura

CIERRA:                     # Loop de cierre
beq $t1, $t8, CIERRA_41     # si se encuentra ) se salta a su respectivo loop
beq $t1, $t6, CIERRA_93     # si se encuentra ] se salta a su respectivo loop
beq $t1, $t4, CIERRA_125    # si se encuentra } se salta a su respectivo loop

j SIGUIENTE                 # si el caracter no coincide con ninguno de estos,
                            # se salta la verificación de coincidencia

CIERRA_41:                  # Coincidencia con )
bne $t2, $t9, NO_VALIDO     # Si el último parentesis no es ( , caso invalido
addi $t3, $t3, -1           # Se retrocede un espacio
                            # para verificar el anterior
j SIGUIENTE
CIERRA_93:                  # Coincidencia con ]
bne $t2, $t7, NO_VALIDO     # Si el último parentesis no es [ , caso invalido
addi $t3, $t3, -1           # Se retrocede un espacio
                            # para verificar el anterior
j SIGUIENTE
CIERRA_125:                 # Coincidencia con }
bne $t2, $t5, NO_VALIDO     # Si el último parentesis no es { , caso invalido
addi $t3, $t3, -1           # Se retrocede un espacio
                            # para verificar el anterior
SIGUIENTE:                  # <-- Etiqueta para saltar verificación
addi $t0, $t0, 1      # <-- Se pasa al siguiente elemento 
                      # de la cadena principal
j PURGE               # se repite el loop PURGUE
EGRUP:                # fin del loop PURGUE


VALIDO:               # Para caso valido V0 = 1
addi $v0, $0, 1    
j TERMINAR_VALIDO

NO_VALIDO:            # Para caso no valido V0 = 0
addi $v0, $0, 0

TERMINAR_VALIDO:

addi $sp, $sp, 1    # devolviendo puntero con respecto al 1 byte tomado 
add $sp, $sp, $s0   # devolviendo puntero con respecto al tamaño de la cadena
lw $s0, 0($sp)      # devolviendo valor s0
addi $sp, $sp, 4    # devolviendo puntero con respecto al tamaño de $s0

jr $ra


VALIDACION_VO:
# muestra en pantalla el mensaje correspondiente al valor del registro $v0

	addi $t0, $v0, 0  # Valor de v0 a t0
	addi $v0, $0, 4   # mostrar cadena terminada en \0
    beq $t0, $0, VALOR_0
    la $a0, msj_valido
    j VALOR_1
	VALOR_0:
    la $a0, msj_invalido
    VALOR_1:
    syscall
	
jr $ra

PRINT_CADENA:
# esta función obtiene del argumento el inicio de una cadena de carácteres
# tipo asciiz, muestra desde el primer elemento de la cadena
# hasta encontrar un valor 0 y detenerse
# $a0: argumento de dirección del elemento inicial de la cadena

	addi $v0, $0, 4 # el valor 4 en $v0 muestra en pantalla una cadena
			        # esta cadena empieza en la dirección de memoria
                    # que contiene $a0
	syscall
jr $ra

EXIT:
# Esta función ejecuta el syscall de $v0 = 10
# que corresponde a la salida del programa
	addi $v0, $0, 10
	syscall	
	
jr $ra

# Conclusiones:
# - La función es optima, se ejecuta n veces el loop para obtener
#   el tamaño de la cadena. 
#       se puede ejecutar otras n veces para analizar la cadena
#   en el loop de verificación ( en caso de ser valido),
#   más pasos intermedios (c). (2n + c)
# - El código, prácticamente, se basa en saltos y etiquetas, por lo que se
#   entrena la ubicación espacial dentro del código. 