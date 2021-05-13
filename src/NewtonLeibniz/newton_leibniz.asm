## Calculate taylor serires for arctan(x)
#
#.text
#
## Initialize variables
#li	$a0, 0
#li	$a1, 2
#li	$a2, 10
#
#main:
#la	$s5, ($a1)	# Absolutely stunning. I have no idea this can be done
#jal	series
## What are $f14 and $f12?
## Did you assume them to be 0.0 at the beginning
## Or they are function output?
#add.d	$f14, $f14, $f12
#
#la	$s5, ($a0)
#jal	series
#add.d	$f16, $f16, $f12	# $f16 is...?
#
## subtract			# Very helpful comment :)))
#sub.d	$f18, $f14, $f16	# $f18 is...?
#
#li	$v0, 10			# Exit program
#syscall
#
## ================= SERIES FUNCTION ==============
#series:
## Note: (-1)^n/(2n+1)*x^(2n+1)
#
#li	$s0, -1
#li	$s1, 0	# main counter	n
#
#loop_series:
## calculating exponent and denominator of function
#mul	$s2, $s1, 2
#addi	$s2, $s2, 1	# Now s2 store the exponent and denominator, 2n+1
#mtc1.d	$s2, $f2
#cvt.d.w	$f2, $f2
#
## calculate (-1)^n and store in $s8
#
#la	$s3, ($s0)
#la	$s4, ($s1)
#jal	POWER
#mtc1.d	$t0, $f8
#cvt.d.w	$f8, $f8
#
#
## calculate x^(2^n+1) and store in $s6
#la	$s3, ($a1)
#la	$s4, ($s2)
#jal	POWER
#mtc1.d	$t0, $f6
#cvt.d.w	$f6, $f6
#
## calculate (-1)^n/(2n+1)*x^(2n+1)
#mul.d	$f10, $f8, $f6
#div.d	$f4, $f10, $f2
#
## add result to final register $f30
#add.d 	$f12, $f12, $f4
#
## increase counter
#addi	$s1, $s1, 1
#ble	$s1, $a3, loop_series
## return
#jr	$ra
#
## ================== POWER function =============
#POWER:
#
#la	$t0, 1	# Load value
#li	$t1, 0		# Initialize counter
#beq	$s4, $zero, end_loop_power
#loop_power:
#mul	$t0, $t0, $s3
#addi	$t1, $t1, 1
#bne	$t1, $s4, loop_power
#end_loop_power:
#jr	$ra


# LAM's


li	$a0 0
li	$a1 1
li	$a2 50
.data
one.d:	.double	1.0
two.d:	.double 2.0
four.d: .double 4.0

# ============== NEWTON_LEIBNIZ ===========
# Calculate 4*(arctan(b) - arctan(a))
# using infinite series for arctan()
# @param $a0: int a (>= 0)
# @param $a1: int b (>= 0)
# @param $a2: int n. Result precision 
#	(the number of terms in the series)
# 
# @return $f30: double-precision result
# =========================================
.text
	# VARIABLES LOOK-UP TABLE
	# $f0-1  = arctan(a)
	# $f4-5	 = double 4.0
	
	addi	$sp $sp -4
	sw	$ra 0($sp)	# Saves $ra before calling arctan()
	
	add	$s0 $a0 $zero	# Saves a to s0 to reserve slot for arctan
	add	$s1 $a1 $zero	# Saves b to s1 to reserve slot for arctan
	
	add	$a1 $a2 $zero	# Setup n in place of b
	jal	ARCTAN		# $f20 = arctan(a, n)
	
	mov.d	$f0 $f20	# $f0 = arctan(a, n)
	
	add	$a0 $s1 $zero	# Setup b in place of a
	
	jal	ARCTAN		# $f20 = arctan(b, n)
	
	sub.d	$f30 $f20 $f0	# result = arctan(b) - arctan(a)
	l.d	$f4 four.d	# $f4 = 4.0
	mul.d	$f30 $f4 $f30	# result = 4*(arctan(b) - arctan(a))

	add	$a0 $s0 $zero	# Move the arguments back to their rightful places
	add	$a1 $s1 $zero	# Shhhhh! Don't tell anyone I take you for a walk, kids
	
	lw	$ra 0($sp)	# End the procedure
	add	$sp $sp 4
	#jr	$ra		# Uncomment when we merge this file with other .asm files
	
	li	$v0 10		# Exit. Comment these two lines 
	syscall			# when merging with other files

# ============== ARCTAN ================
# Calculate arctan(x)
# using infinite series
# @param $a0: int x (>= 0)
# @param $a1: int n. The number of terms
# 
# @return $f20: double-precision result
# ======================================
ARCTAN:
.text
	# I'm doing a shortcut for this project
	# return arctan(0) = 0
	bnez	$a0 NOT_ZERO 
	mtc1.d	$a0 $f20	# Convert $a0 to double
	cvt.d.w	$f20 $f20	# And return 0
	jr	$ra

	# The series is:
	# arctan(x) = x - x^3/3 + x^5/5 - x^7/7 +...
	# If x = 1, the terms get smaller and smaller
	# So, to retain precision, we calculate from right to left
	#
	# For x > 1, the terms rise exponentially
	# It'd be wise to calculate from left to right
	
	
	# TODO (?): Actually, the ratio between (x-x^3/3) and x^5/5 might be huge. 
	# A better plan would be to group adjacent operands together
	# And then calculate recursively
	# i.e. ( ((x - x^3/3) + (x^5/5 - x^7/7)) + ... )
	# Maybe another time
	
	NOT_ZERO:
	
	MAY_I_BORROW_THEM:
		addi	$sp $sp -52	# Saves the last owner's registers	
		swc1	$f0 0($sp)	# Before we use
		swc1	$f1 4($sp)
		swc1	$f2 8($sp)
		swc1	$f3 12($sp)
		swc1	$f4 16($sp)
		swc1	$f5 20($sp)
		swc1	$f6 24($sp)
		swc1	$f7 28($sp)
		swc1	$f8 32($sp)
		swc1	$f9 36($sp)
		swc1	$f10 40($sp)
		swc1	$f11 44($sp)
			
	CALCULATE_EACH_TERM:
	# VARIABLES LOOK-UP TABLE
	# $f0-1  = x = $a0 = numerator
	# $f2-3  = 1.0 = denominator  
	# $f4-5  = x^2 = step of each numerator
	# $f6-7  = 2.0 = step of each denominator
	# $f8-9  = sign (-1 or 1)
	# $f10-11= sign * numerator / denominator
	##
	# $t0 = 0 to n-1 (loop counter)
	# $t1 = (before) array begin
	# ($sp = array end. But not now. After CALCULATE_EACH_TERM is done)
	
		VARIABLES_SET_UP:
		mtc1	$a0 $f0
		cvt.d.w	$f0 $f0	# Convert x to double	
		
		l.d	$f2 one.d	# Set initial denominator to 1.0
		
		mul.d	$f4 $f0 $f0	# Numerator Step = x^2
		
		l.d	$f6 two.d	# Denominator Step = 2.0
		
		# First, set sign bit to 1.0
		# Because first term is positive x
		l.d	$f8 one.d	# Set sign bit to 1.0
		
		
		add	$t1 $sp $zero		# Save pointer to (before) the beginning of our array of terms
		
		add	$t0 $zero $zero		# Initiallize loop counter = 0
		
		mtc1	$zero $f20	# Don't forget to 
		mtc1	$zero $f21	# reset the result!
		
		CALCULATE_NEXT_TERM:
			mul.d	$f10 $f0 $f8	# numerator = x*sign
			div.d	$f10 $f10 $f2	# numerator / denominator
			
			addi	$sp $sp -8	# Store the term to stack
			swc1	$f10 0($sp)	
			swc1	$f11 4($sp)
			
			addi	$t0 $t0 1	# ++loop counter
			mul.d	$f0 $f0 $f4	# Calculate the next numerator
			add.d	$f2 $f2 $f6	# Add 2 to the denominator
			neg.d	$f8 $f8		# Invert sign of the next term
			
			blt	$t0 $a1	CALCULATE_NEXT_TERM	# See if we have reached the number of required terms
	
	CALCULATE_THE_SUM:
	# VARIABLES LOOK-UP TABLE
	# $f0-1  = a term in array
	##
	# $t0 = temporary. Use for anything you like.
	# $t1 = (before) array begin
	# $t2 = iterator
	# $t3 = iterator step
	# $t4 = iterator end
	# $sp = array end 
	
		X_IS_ONE:
			bgt	$a0 1 X_GREATER_ONE
			# Calculation direction: Right -> Left
			add	$t2 $sp $zero	# Iterator begins from the end of array
			addi	$t3 $zero 8	# Iterator step
			addi	$t4 $t1	0	# End Iterator is array before-beginning.
			j	SUMMING
			
		X_GREATER_ONE:
			# Calculation direction: Left -> Right
			add	$t2 $sp $zero	# Iterator starts from array beginning
			addi	$t3 $zero -8	# Iterator step
			add	$t4 $sp	-8	# End Iterator is array past-the-end.
			
		SUMMING:
			lwc1	$f0 0($t2)	# Load the double from stack
			addi	$t0 $t2 4 
			lwc1	$f1 0($t0)
			
			add.d	$f20 $f20 $f0	# Add the double to result
			
			add	$t2 $t2 $t3	# iterator += step
			
			bne	$t2 $t4 SUMMING	# loop if iterator != end
	
	RETURN_THE_REGISTERS_AS_PROMISED:
		add	$sp $t1 $zero	# Deallocate the array of terms
				
		addi	$sp $sp 52
		lwc1	$f0 0($sp)
		lwc1	$f1 4($sp)
		lwc1	$f2 8($sp)
		lwc1	$f3 12($sp)
		lwc1	$f4 16($sp)
		lwc1	$f5 20($sp)
		lwc1	$f6 24($sp)
		lwc1	$f7 28($sp)
		lwc1	$f8 32($sp)
		lwc1	$f9 36($sp)
		lwc1	$f10 40($sp)
		lwc1	$f11 44($sp)
		
	END_ARCTAN:
		jr	$ra
			
	
