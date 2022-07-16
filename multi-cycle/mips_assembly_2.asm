addi $a0, $zero, 5       # $a0 = 5
xor $v0, $zero, $zero    # $v0 = 0
jal sum                  # jump sum and link $ra = loop;

Loop:
beq $zero, $zero, Loop

sum:                     # sum
addi $sp, $sp, -8        # $sp = $sp - 8
sw $ra, 4($sp)           # save $ra in $sp + 4 
sw $a0, 0($sp)           # save $a0 in $sp
slti $t0, $a0, 1         # $t0 = ($a0 < 1)
beq $t0, $zero, L1       # if $t0 == 0 then L1 (if $a0 >= 1 then L1)
addi $sp, $sp, 8         # $sp = $sp + 8
jr $ra                   # jump $ra

L1:                      # L1:
add $v0, $a0, $v0        # $v0 = $v0 + $a0
addi $a0, $a0, -1        # $a0 = $a0 - 1
jal sum                  # jump sum and link
lw $a0, 0($sp)           # load $a0
lw $ra, 4($sp)           # load $ra
addi $sp, $sp, 8         # $sp = $sp + 8
add $v0, $a0, $v0        # $v0 = $a0 + $v0
jr $ra                   # jump $ra


# int n = 5, sum = 0;
# void sum(n)
# {
#     if (n >= 1)
#     {
#         sum += n;
#         sum(n - 1);
#         sum += n;
#     }
# }
# sum(n);
#
