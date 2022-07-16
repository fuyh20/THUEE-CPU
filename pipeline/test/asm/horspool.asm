# load string and pattern
addi $s0, $zero, 15            # $s0 = 15 (string length)
addi $s1, $zero, 2             # $s1 = 2 (pattern length)

addi $s2, $zero, 1024          # $s2  string address
lui  $t0, 0x3332
addi $t0, $t0, 0x3231
sw   $t0, 0($s2)
lui  $t0, 0x3136
addi $t0, $t0, 0x3534
sw   $t0, 4($s2)
lui  $t0, 0x3231
addi $t0, $t0, 0x3231
sw   $t0, 8($s2)
lui  $t0, 0x0036
addi $t0, $t0, 0x3534
sw   $t0, 12($s2)

addi $s3, $zero, 1536          # $s3 pattern address
lui  $t0, 0x0000
addi $t0, $t0, 0x3231
sw   $t0, 0($s3)

# call horspool
move $a0, $s0
move $a2, $s1
move $a1, $s2
move $a3, $s3
jal  horspool

loop:
addi $t0, $zero, 0
j    loop

horspool:
addi $t0, $zero, 0
sub  $t0, $zero, $t0

li   $v0, 0                    # cnt = 0
li   $t1, 0                    # i = 0
for1:                          #
slti $t2, $t1, 256             # $t2 = i < 256
beq  $t2, $0, end_for1         #
sll  $t4, $t1, 2               #  
add  $t2, $t4, $t0             # $t2 = &table[i]
li   $t3, -1                   # $t3 = -1
sw   $t3, 0($t2)               # table[i] = -1
addi $t1, $t1, 1               # ++i
j    for1                      #
end_for1:                      #

li   $t1, 0                    # i = 0
for2:                          #
slt  $t2, $t1, $a2             # $t2 = j < len_pattern
beq  $t2, $0, end_for2         # i >= len_pattern then end_for2
add  $t3, $t1, $a3             # $t3 = &pattern[i]
lb   $t3, 0($t3)               # $t3 = pattern[i]
sll  $t3, $t3, 2               #
add  $t2, $t3, $t0             # $t3 = &table[pattern[i]]
sw   $t1, 0($t2)               # table[pattern[i]] = i
addi $t1, $t1, 1               # ++i
j    for2                      #
end_for2:                      #

addi $t1, $a2, -1              # i = len_pattern - 1
outer_while:                   #
slt  $t2, $t1, $a0             # $t2 = i < len_str
beq  $t2, $0, outer_while_end  # i >= len_str then

li   $t3, 0                    # j = 0
inner_while:                   #
slt  $t4, $t3, $a2             # $t4 = j < len_pattern
addi $t5, $a2, -1              # $t5 = len_pattern - 1
sub  $t5, $t5, $t3             # $t5 = len_pattern - 1 - j
add  $t5, $t5, $a3             # $t5 = &pattern[len_pattern - 1 - j]
lb   $t5, 0($t5)               # $t5 = pattern[len_pattern - 1 - j]
sub  $t6, $t1, $t3             # $t6 = i - j
add  $t6, $t6, $a1             # $t6 = &str[i - j]
lb   $t6, 0($t6)               # $t6 = str[i - j]
seq  $t5, $t5, $t6             # $t5 = $t5 == $t6
and  $t4, $t4, $t5             # condition
beq  $t4, $0, inner_while_end  # condition is false then
addi $t3, $t3, 1               # j += 1
j    inner_while               # 
inner_while_end:               #
bne  $t3, $a2, end_if          # j != len_pattern then
addi $v0, $v0, 1               # cnt += 1
end_if:                        #
add  $t4, $t1, $a1             # $t4 = &str[i]
lb   $t4, 0($t4)               # $t4 = str[i]
sll  $t4, $t4, 2               #
add  $t4, $t4, $t0             # $t4 = &table[str[i]]
lw   $t4, 0($t4)               # $t4 = table[str[i]]
addi $t6, $t4, 1               # $t6 = table[str[i]] + 1
addi $t5, $a2, -1              # $t5 = len_pattern - 1
sub  $t5, $t5, $t3             # $t5 = len_pattern - 1 - j
bgt  $t6, $t5, else            # condition is false then
add  $t5, $t5, $t3             # $t5 = len_pattern - 1
sub  $t5, $t5, $t4             # $t5 = len_pattern - 1 - table[str[i]]
add  $t1, $t1, $t5             # i += len_pattern - 1 - table[str[i]]
j end_else                     #
else:                          #
addi $t1, $t1, 1               # i += 1
end_else:                      #
j    outer_while               #
outer_while_end:               #

jr   $ra                       # return cnt