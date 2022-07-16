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

# call kmp
move $a0, $s0
move $a2, $s1
move $a1, $s2
move $a3, $s3
jal  kmp

loop:
addi $t0, $zero, 0
j    loop

kmp:
addi $s0, $zero, 0             # $s0 next
addi $sp, $sp, -24             # protect current situation
sw   $a0, 20($sp)              # 
sw   $a1, 16($sp)              #
sw   $a2, 12($sp)              #
sw   $a3, 8($sp)               #
sw   $s0, 4($sp)               #
sw   $ra, 0($sp)               #

# transport parameter
move $a0, $s0                  # $ao = *next
move $a1, $a2                  # $a1 = len_pattern
move $a2, $a3                  # $a2 = *pattern
jal  generateNext              # call generateNext

lw   $ra, 0($sp)               # restore situation         
lw   $s0, 4($sp)               #
lw   $a3, 8($sp)               #
lw   $a2, 12($sp)              #
lw   $a1, 16($sp)              #
lw   $a0, 20($sp)              #
addi $sp, $sp, 24              #

li   $t0, 0                    # i = 0
li   $t1, 0                    # j = 0
li   $v0, 0                    # cnt = 0

while:                         #
slt  $t2, $t0, $a0             # $t2 = i < len_str
beq  $t2, $0, end_while        # i >= len_str then end_while

add  $t2, $t0, $a1             # $t2 = &str[i]
lb   $t2, 0($t2)               # $t2 = str[i]
add  $t3, $t1, $a3             # $t3 = pattern[j]
lb   $t3, 0($t3)               # $t3 = pattern[j]
seq  $t2, $t2, $t3             # str[i] == pattern[j]
beq  $t2, $0, else             # str[i] != pattern[j] then

addi $t2, $a2, -1              # $t2 = len_pattern - 1
bne  $t1, $t2, else1           # j != len_pattern - 1 then
addi $v0, $v0, 1               # cnt += 1
sll  $t2, $t2, 2               # 
add  $t2, $t2, $s0             # $t2 = &next[len_pattern - 1]
lw   $t1, 0($t2)               # j = next[len_pattern - 1]
addi $t0, $t0, 1               # i += 1
j    end_if                    #
else1:                         #
addi $t0, $t0, 1               # i += 1
addi $t1, $t1, 1               # j += 1
j    end_if                    #

else:                          #
ble  $t1, $0, else2            # j <= 0 then
addi $t2, $t1, -1              # $t2 = j - 1
sll  $t2, $t2, 2               #
add  $t2, $t2, $s0             # $t2 = &next[j - 1]
lw   $t1, 0($t2)               # j = next[j - 1]
j    end_if                    #
else2:                         #
addi $t0, $t0, 1               # i += 1
end_if:                        #
j    while                     #
end_while:                     #
jr   $ra                       # return cnt


generateNext:                  # generateNext
li   $t0, 1                    # i = 1 
li   $t1, 0                    # j = 0
bne  $a1, $0, end_if1          # len_pattern != 0  then
li   $v0, 1                    #
jr   $ra                       # return 1
end_if1:                       #  
lw   $0, 0($a0)                # next[0] = 0
while_generateNext:            #
slt  $t2, $t0, $a1             # $t2 = i < len_pattern
beq  $t2, $0, end_while_generateNext

add  $t2, $t0, $a2             # $t2 = &pattern[i]
lb   $t2, 0($t2)               # $t2 = pattern[i]
add  $t3, $t1, $a2             # $t3 = $pattern[j]
lb   $t3, 0($t3)               # $t3 = pattern[j]
seq  $t2, $t2, $t3             # pattern[i] == pattern[j]
beq  $t2, $0, end_if2          #
sll  $t2, $t0, 2               #
add  $t2, $t2, $a0             # $t2 = &next[i]
addi $t3, $t1, 1               # $t3 = j + 1
sw   $t3, 0($t2)               # next[i] = j + 1
addi $t0, $t0, 1               # i += 1
addi $t1, $t1, 1               # j += 1
j    end_else                  #
end_if2:                       #
sgt  $t2, $t1, $0              # j > 0 ?
beq  $t2, $0, else_if          #
addi $t2, $t1, -1              # $t2 = j - 1
sll  $t2, $t2, 2               #
add  $t2, $t2, $a0             # $t2 = &next[j - 1]
lw   $t1, 0($t2)               # j = next[j - 1]
j    end_else                  #
else_if:                       #
sll  $t2, $t0, 2               #
add  $t2, $t2, $a0             # $t2 = &next[i]
sw   $0, 0($t2)                # next[i] = 0
addi $t0, $t0, 1               # i++
end_else:                      #
j    while_generateNext        #
end_while_generateNext:        #
li   $v0, 0                    #
jr   $ra                       # return 0