.data 
msj: .asciiz "áa ée íi óo úu \n"
.text

main:
li $t9, 0

loop:
lb $t0, msj($t9)
beq $t0, $0, pool
li $v0, 1
addi $a0, $t0, 0
syscall
li $a0, 32
li $v0, 11
syscall
addi $t9, $t9, 1
j loop
pool:



li $v0, 10
syscall