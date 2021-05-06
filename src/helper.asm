#--------HELPER FUNCTIONS--------
# Including:
#
# QUICK_SAVE: 
# +) Allocate the stack.
# +) Save all $s? $a? $v? registers to the stack. 
# QUICK_LOAD: 
# +) Load all $s? $a? $v? registers from the stack. 
# +) Delocate the stack.
#--------------------------------

# Leave 0 and 60 to spare.
# The point is, 0 and 60 might be used before, or after a user call these functions
# Thus, leaving them out hurts nobody. Right?

QUICK_SAVE:
	addi $sp $sp -60
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	lw $s6 28($sp)
	lw $s7 32($sp)
	lw $a0 36($sp)
	lw $a1 40($sp)
	lw $a2 44($sp)
	lw $a3 48($sp)
	lw $v0 52($sp)
	lw $v1 56($sp)
	jr $ra	

QUICK_LOAD:
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	sw $s6 28($sp)
	sw $s7 32($sp)
	sw $a0 36($sp)
	sw $a1 40($sp)
	sw $a2 44($sp)
	sw $a3 48($sp)
	sw $v0 52($sp)
	sw $v1 56($sp)
	addi $sp $sp 60
	jr $ra	
