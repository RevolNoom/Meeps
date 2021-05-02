#--------HELPER FUNCTIONS--------
# Including:
#
# QUICK_SAVE: 
# +) Allocate the stack.
# +) Save all $s? registers to the stack. 
# QUICK_LOAD: 
# +) Load all $s? registers from the stack. 
# +) Delocate the stack.
#--------------------------------

# Leave 0 and 36 to spare.
# The point is, 0 and 36 might be used before, or after a user call these functions
# Thus, leaving them out hurts nobody. Right?

QUICK_SAVE:
	addi $sp $sp -40
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	lw $s6 28($sp)
	lw $s7 32($sp)
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
	addi $sp $sp 40
	jr $ra	
