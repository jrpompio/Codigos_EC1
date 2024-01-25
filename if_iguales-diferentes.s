li $s0, 1
li $s1, 1

ADDI $sp, $sp, -12 # espacio de 12 bytes para la cadena 


beq $s0, $s1, saltar

ADDI $t0, $zero, 100 # d
SB $t0, 0($sp)
ADDI $t0, $zero, 105 # i
SB $t0, 1($sp) 
ADDI $t0, $zero, 102 # f 
SB $t0, 2($sp)
ADDI $t0, $zero, 101 # e
SB $t0, 3($sp)
ADDI $t0, $zero, 114 # r
SB $t0, 4($sp)
ADDI $t0, $zero, 101 # e
SB $t0, 5($sp)
ADDI $t0, $zero, 110 # n
SB $t0, 6($sp)
ADDI $t0, $zero, 116 # t
SB $t0, 7($sp)
ADDI $t0, $zero, 101 # e
SB $t0, 8($sp)
ADDI $t0, $zero, 115 # s
SB $t0, 9($sp)
ADDI $t0, $zero, 10 # \n
SB $t0, 10($sp)
ADDI $t0, $zero, 0 # null
SB $t0, 11($sp)

ADDI $v0, $zero, 4 # 4 is for print string
ADDI $a0, $sp, 0
syscall 			# print to the log

j end

saltar:
ADDI $t0, $zero, 105 # i
SB $t0, 0($sp)
ADDI $t0, $zero, 103 # g
SB $t0, 1($sp) 
ADDI $t0, $zero, 117 # u 
SB $t0, 2($sp)
ADDI $t0, $zero, 97 # a
SB $t0, 3($sp)
ADDI $t0, $zero, 108 # l
SB $t0, 4($sp)
ADDI $t0, $zero, 101 # e
SB $t0, 5($sp)
ADDI $t0, $zero, 115 # s
SB $t0, 6($sp)
ADDI $t0, $zero, 10 # \n
SB $t0, 7($sp)
ADDI $t0, $zero, 0 # null
SB $t0, 8($sp)

ADDI $v0, $zero, 4 # 4 is for print string
ADDI $a0, $sp, 0
syscall 			# print to the log

end: 
