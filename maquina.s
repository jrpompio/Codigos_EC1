# Práctica de lenguaje maquina

addi $s0, $0, 13
addi $t0, $0, -12
addi $v0, $0, 0

saltar:

add  $t0, $s0, $t0
slti $t1, $t0, 1000 # si t0 < 1000; t1=1
addi $v0, $v0, 1
beq $t1, $0, terminar
beq $0, $0, saltar
add $v0, $0, $0

terminar:
