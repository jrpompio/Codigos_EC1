main:

addi $a0, $0, 100
addi $a1, $0, 120

jal multiplicar

j end_funtions

multiplicar:
addi $t0, $a0, 0

for:
addi $t0, $t0, -1
add $v0, $v0, $a1


slti $t1, $t0, 1
beq $t1, $0, for
jr $ra

end_funtions:
