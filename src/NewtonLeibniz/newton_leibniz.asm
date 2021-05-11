# Calculate taylor serires for arctan(x)

.text

# Initialize variables
li	$a0, 0
li	$a1, 2
li	$a3, 100

main:
# Note: (-1)^n/(2n+1)*x^(2n+1)

li	$s0, -1
li	$s1, 0	# main counter	n

main_loop:
# calculating exponent and denominator of function
mul	$s2, $s1, 2
addi	$s2, $s2, 1	# Now s2 store the exponent and denominator, 2n+1
mtc1.d	$s2, $f2
cvt.d.w	$f2, $f2

# calculate (-1)^n and store in $s8

la	$s3, ($s0)
la	$s4, ($s1)
jal	POWER
mtc1.d	$t0, $f8
cvt.d.w	$f8, $f8


# calculate x^(2^n+1) and store in $s6
la	$s3, ($a1)
la	$s4, ($s2)
jal	POWER
mtc1.d	$t0, $f6
cvt.d.w	$f6, $f6

# calculate (-1)^n/(2n+1)*x^(2n+1)
mul.d	$f10, $f8, $f6
div.d	$f4, $f10, $f2

# add result to final register $f30
add.d 	$f30, $f30, $f4

# increase counter
addi	$s1, $s1, 1
ble	$s1, $a3, main_loop

# exit 
li	$v0, 10
syscall

# move result to $f30 register

# POWER function
POWER:

la	$t0, 1	# Load value
li	$t1, 0		# Initialize counter
beq	$s4, $zero, end_loop_power
loop_power:
mul	$t0, $t0, $s3
addi	$t1, $t1, 1
bne	$t1, $s4, loop_power	# Replace 5 with some other register that stores the power coefficent
end_loop_power:
jr	$ra


