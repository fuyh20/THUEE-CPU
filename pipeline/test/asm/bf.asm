# load leds and digitalTube
lui  $s4, 0x4000
addi $s4, $s4, 0x000c
lui  $s5, 0x4000
addi $s5, $s5, 0x0010

# load string and pattern
addi $s0, $zero, 15            # $s0 = 15 (string length)
addi $s1, $zero, 2             # $s1 = 2 (pattern length)

sub $s2, $zero, 512           # $s2  string address
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

sub $s3, $zero, 1024          # $s3 pattern address
lui  $t0, 0x0000
addi $t0, $t0, 0x3231
sw   $t0, 0($s3)

# call brute_force
move $a0, $s0
move $a2, $s1
move $a1, $s2
move $a3, $s3
jal  brute_force

# show result
addi $t0, $zero, 0
beq  $v0, $t0, bcd_0
addi $t0, $zero, 1
beq  $v0, $t0, bcd_1
addi $t0, $zero, 2
beq  $v0, $t0, bcd_2
addi $t0, $zero, 3
beq  $v0, $t0, bcd_3
addi $t0, $zero, 4
beq  $v0, $t0, bcd_4
addi $t0, $zero, 5
beq  $v0, $t0, bcd_5
addi $t0, $zero, 6
beq  $v0, $t0, bcd_6
addi $t0, $zero, 7
beq  $v0, $t0, bcd_7
addi $t0, $zero, 8
beq  $v0, $t0, bcd_8
addi $t0, $zero, 9
beq  $v0, $t0, bcd_9
addi $t0, $zero, 10
beq  $v0, $t0, bcd_A
addi $t0, $zero, 11
beq  $v0, $t0, bcd_B
addi $t0, $zero, 12
beq  $v0, $t0, bcd_C
addi $t0, $zero, 13
beq  $v0, $t0, bcd_D
addi $t0, $zero, 14
beq  $v0, $t0, bcd_E
addi $t0, $zero, 15
beq  $v0, $t0, bcd_F

bcd_0:
li   $t1, 0x13F
sw   $t1, 0($s5)
j    end
bcd_1:
li   $t1, 0x106
sw   $t1, 0($s5)
j    end
bcd_2:
li   $t1, 0x15B
sw   $t1, 0($s5)
j    end
bcd_3:
li   $t1, 0x14F
sw   $t1, 0($s5)
j    end
bcd_4:
li   $t1, 0x166
sw   $t1, 0($s5)
j    end
bcd_5:
li   $t1, 0x16D
sw   $t1, 0($s5)
j    end
bcd_6:
li   $t1, 0x17D
sw   $t1, 0($s5)
j    end
bcd_7:
li   $t1, 0x107
sw   $t1, 0($s5)
j    end
bcd_8:
li   $t1, 0x17F
sw   $t1, 0($s5)
j    end
bcd_9:
li   $t1, 0x16F
sw   $t1, 0($s5)
j    end
bcd_A:
li   $t1, 0x177
sw   $t1, 0($s5)
j    end
bcd_B:
li   $t1, 0x17C
sw   $t1, 0($s5)
j    end
bcd_C:
li   $t1, 0x139
sw   $t1, 0($s5)
j    end
bcd_D:
li   $t1, 0x15E
sw   $t1, 0($s5)
j    end
bcd_E:
li   $t1, 0x179
sw   $t1, 0($s5)
j    end
bcd_F:
li   $t1, 0x171
sw   $t1, 0($s5)
j    end

end:
j    end


# brute_force
brute_force:
li   $v0, 0                    # cnt = 0
sub	 $t2, $a0, $a2             # $t2 = len_str - len_pattern
li   $t0, 0                    # i = 0
outer_loop:                    #  
bgt	 $t0, $t2, outer_loop_end  #

li   $t1, 0                    # j = 0
inner_loop:                    #
bge  $t1, $a2, inner_loop_end  #

add  $t3, $t0, $t1             # $t3 = i + j  
add  $t3, $t3, $a1             # $t3 = &str[i + j]
lb   $t3, 0($t3)               # $t3 = str[i + j]
add  $t4, $t1, $a3             # $t4 = &pattern[j]
lb   $t4, 0($t4)               # $t4 = pattern[j]
bne  $t3, $t4, inner_loop_end  # str[i + j] != pattern[j] break
addi $t1, $t1, 1               # j += 1
j    inner_loop                # 
inner_loop_end:                #

bne  $t1, $a2, end_if          # $t1 = j != len_pattern
addi $v0, $v0, 1               # cnt += 1
end_if:                        #

addi $t0, $t0, 1               # i += 1
j    outer_loop                #
outer_loop_end:                #

jr   $ra   